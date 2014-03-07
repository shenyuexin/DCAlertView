//
//  ViewController.m
//  DCAlertView
//
//  Created by syx on 14-3-7.
//  Copyright (c) 2014年 Arcsoft. All rights reserved.
//

#import "ViewController.h"
#import "DCAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)showAlert:(UIGestureRecognizer *)gesture
{
    DCAlertView *alertView = [[DCAlertView alloc] initWithTitle:@"Hello!" message:@"AlertView" cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertView setAlertViewClickBlock:^(NSString *buttonTitle) {
        NSLog(@"buttonTitle:%@",buttonTitle);
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
