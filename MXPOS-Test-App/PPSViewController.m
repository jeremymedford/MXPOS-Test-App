//
//  PPSViewController.m
//  MXPOS-Test-App
//
//  Created by Jeremy Medford on 12/25/12.
//  Copyright (c) 2012 Priority Payment Systems. All rights reserved.
//

#import "PPSViewController.h"
#import "PPSAPI.h"
#import "PPSMerchant.h"
#import "PPSCustomer.h"
#import "PPSAPINotifications.h"
#import "PPSAPIError.h"
#import "PPSOAuth1Token.h"

@interface PPSViewController ()

@end

@implementation PPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAPIRequestFailure:) name:PPSAPI_SERVICE_COMMAND_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOAuthRequestFailure:) name:PPSAPI_OAUTH_SERVICE_COMMAND_ERROR object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authorize:(UIButton *)sender
{
    [PPSAPI setDelegate:self];
    
    [PPSAPI setCredentialsWithClientId:@"7D6C9315-B732-4D57-A259-380E5E80B110" sharedSecret:@"ghK6aeRG5I+TQiRsb52x/pCdnM0="];
//    [PPSAPI setCredentialsWithClientId:@"7D6C9315-B732-4D57-A259-380E5E80B110" sharedSecret:@"unsafe_secret"];

    [PPSAPI temporaryAuthorizationWithCallbackURL:[NSURL URLWithString:@"myapp://oauth"]];
    
}

- (IBAction)getCustomers:(id)sender {
    
    BOOL authorized = YES;
    
    if (authorized) {
        [PPSCustomer findByValue:@"Sean" limit:@(10) offset:@(0) sortField:@"alias" ascending:YES completion:^(NSArray *customers) {
            
            NSLog(@"customers: %@", customers);
        } failure:^(NSNumber *statusCode, NSError *error) {
            
            NSLog(@"Returned code: %@, error: %@", statusCode, error);
        }];
    }
}

- (IBAction)setCredentials:(UIButton *)sender {
    
    NSString *tokenId = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    NSString *secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessTokenSecret"];
    
    PPSOAuth1Token *token = [[PPSOAuth1Token alloc] initWithTokenId:tokenId secret:secret];
    [PPSAPI setTokenCredentialsWithAccessToken:token];
    
}

#pragma mark PPSAPIDelegate methods

- (void) performLoginAuthenticationWithRequestToken:(NSString *)token authenticateURL:(NSURL *)url;
{
    NSLog(@"Token returned: %@", token);
    NSLog(@"URL returned: %@", [url absoluteString]);
    
    NSString *authURL = [NSString stringWithFormat:@"%@?oauth_token=%@",[url absoluteString], token];
    NSLog(@"authURL: %@", authURL);

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
}

- (void) handleAPIRequestFailure:(NSNotification *)note;
{
    NSLog(@"failed api request in viewcontroller: %@", note);
    
}

- (void) handleOAuthRequestFailure:(NSNotification *)note;
{
    NSLog(@"failed oauth step in viewcontroller:%@ object:%@", self, note.object);

}

@end

