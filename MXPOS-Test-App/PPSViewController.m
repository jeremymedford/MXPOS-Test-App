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

@interface PPSViewController ()

@end

@implementation PPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFailure:) name:@"PPSRequestFailedNotification" object:nil];
    
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
    [PPSAPI temporaryAuthorizationWithCallbackURL:[NSURL URLWithString:@"myapp://oauth"]];
    
    NSLog(@"authorized.");
}

- (IBAction)getCustomers:(id)sender {
    
    BOOL authorized = YES;
    
    if (authorized) {
        [PPSCustomer findByValue:@"a" limit:@(10) offset:@(0) sortField:@"alias" ascending:YES completion:^(NSArray *customers) {
            
            NSLog(@"customers: %@", customers);
        }];
    }
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

- (void) handleFailure:(NSNotification *)note;
{
    NSLog(@"failed in viewcontroller: %@", note);
}

@end

