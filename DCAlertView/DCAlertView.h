//
//  DXAlertView.h
//  WirelessEducation
//
//  Created by Richard Shen on 14-3-6.
//  Copyright (c) 2014年 Dianchu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCAlertView : UIView

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;

- (void)setAlertViewClickBlock:(void (^)(NSString *buttonTitle))block;

- (void)dismissAlertView;
@end
