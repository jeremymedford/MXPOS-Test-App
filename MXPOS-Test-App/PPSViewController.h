//
//  PPSViewController.h
//  MXPOS-Test-App
//
//  Created by Jeremy Medford on 12/25/12.
//  Copyright (c) 2012 Priority Payment Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPSAPI.h"

@interface PPSViewController : UIViewController <PPSAPIDelegate>

- (IBAction)authorize:(UIButton *)sender;
- (IBAction)getCustomers:(id)sender;
- (IBAction)setCredentials:(UIButton *)sender;

@end
