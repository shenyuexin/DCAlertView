DCAlertView
===========

You can use it like UIAlertView

    DCAlertView *alertView = [[DCAlertView alloc] initWithTitle:@"Hello!"
                                                        message:@"AlertView"
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
    [alertView setAlertViewClickBlock:^(NSString *buttonTitle) {
        NSLog(@"buttonTitle:%@",buttonTitle);
    }];
    [alertView show];
