//
//  DXAlertView.m
//  WirelessEducation
//
//  Created by Richard Shen on 14-3-6.
//  Copyright (c) 2014年 Dianchu. All rights reserved.
//

#import "DCAlertView.h"

#define kColorCancel  [UIColor colorWithRed:236/255.0 green:198/255.0 blue:73/255.0 alpha:1.0]
#define kColorConfirm [UIColor colorWithRed:113/255.0 green:157/255.0 blue:121/255.0 alpha:1.0]
#define kAlertMaxHeight 360
#define kAlertMinHeight 140
#define kBottomMargin 15
#define kButtonHeight 44
#define kButtonMargin 4

@interface DCAlertView()

@property (nonatomic, strong) NSMutableArray *otherBtns;
@property (nonatomic, copy) void (^clickBlock) (NSString *buttonTitle);
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *msgLaebl;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation DCAlertView

+ (NSArray *)btnBackgroundColors
{
    static NSArray *colors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors =[NSArray arrayWithObjects:
                  [UIColor colorWithRed:124/255.0 green:174/255.0 blue:133/255.0 alpha:1.0],
                  [UIColor colorWithRed:139/255.0 green:193/255.0 blue:148/255.0 alpha:1.0],
                  [UIColor colorWithRed:146/255.0 green:204/255.0 blue:157/255.0 alpha:1.0],
                  [UIColor colorWithRed:151/255.0 green:211/255.0 blue:163/255.0 alpha:1.0],
                  [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0],
                  nil];
    });
    return colors;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dealloc
{
    _otherBtns = nil;
    _clickBlock = nil;
    _titleLabel = nil;
    _msgLaebl = nil;
    _bgView = nil;
}

- (void)dismissAlertView
{
    [UIView animateWithDuration:0.51 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.hidden = YES;
        [_bgView removeFromSuperview];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnClick:(UIButton *)btn
{
    [self dismissAlertView];
    
    NSString *btnTitle = btn.currentTitle;
    if(self.clickBlock)
        self.clickBlock(btnTitle);
}

- (UIButton *)createBtnWithTitle:(NSString *)title
                 backgroundColor:(UIColor *)color
                         originY:(CGFloat)originY
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, originY, 280, 44)];
    [btn setBackgroundImage:[DCAlertView imageWithColor:color] forState:UIControlStateNormal];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if(self){
        if (otherButtonTitles)
        {
            _otherBtns = [[NSMutableArray alloc] initWithObjects:otherButtonTitles, nil];
            
            NSString *eachObject;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, NSString *)))
                [_otherBtns addObject: eachObject];
            va_end(argumentList);
        }

        CGFloat count = [_otherBtns count] + ((cancelButtonTitle != nil)?1:0);
        CGFloat btnsHeight =  (count-2)*kButtonHeight + (count-1)*kButtonMargin  + kBottomMargin;
        
        CGFloat messageHeight = 0;
        CGFloat originY = 10;
        
        if(title){
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 280, 20)];
            [_titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_titleLabel setTextColor:[UIColor whiteColor]];
            [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:_titleLabel];
            [_titleLabel setText:title];
            originY = CGRectGetMaxY(_titleLabel.frame) +7;
        }
        
        if(message){
            _msgLaebl = [[UILabel alloc] init];
            [_msgLaebl setTextAlignment:NSTextAlignmentCenter];
            [_msgLaebl setFont:[UIFont systemFontOfSize:15]];
            [_msgLaebl setNumberOfLines:0];
            [_msgLaebl setBackgroundColor:[UIColor clearColor]];
            [_msgLaebl setTextColor:[UIColor whiteColor]];
            [_msgLaebl setLineBreakMode:NSLineBreakByTruncatingTail];
            [self addSubview:_msgLaebl];
            [_msgLaebl setText:message];
            messageHeight = [_msgLaebl sizeThatFits:CGSizeMake(280, FLT_MAX)].height;
        }
        
        if(messageHeight>0)
        {
            CGFloat totalHeight = btnsHeight + originY + messageHeight;
            if(totalHeight > kAlertMaxHeight)
            {
                CGFloat frmHeight = kAlertMaxHeight - originY - btnsHeight;
                [_msgLaebl setFrame:CGRectMake(10, originY, 280, MAX(15, frmHeight))];
                originY = CGRectGetMaxY(_msgLaebl.frame) + 10;
            }
            else{
                [_msgLaebl setFrame:CGRectMake(10, originY, 280, messageHeight)];
                
                if(totalHeight < kAlertMinHeight)
                    originY = kAlertMinHeight - kButtonHeight - kBottomMargin;
                else
                    originY = CGRectGetMaxY(_msgLaebl.frame) + 10;
            }
        }
        else{
            if(count <= 2)
                originY = kAlertMinHeight -kButtonHeight -kBottomMargin;
            else
                originY += 10;
        }
        
        if(cancelButtonTitle && [_otherBtns count] == 0)
        {
            UIButton *cancelBtn = [self createBtnWithTitle:cancelButtonTitle backgroundColor:kColorCancel originY:originY];
            [self addSubview:cancelBtn];
            originY = CGRectGetMaxY(cancelBtn.frame);
        }
        else if (!cancelButtonTitle && [_otherBtns count] == 1)
        {
            UIButton *confirmBtn = [self createBtnWithTitle:[_otherBtns objectAtIndex:0] backgroundColor:kColorConfirm originY:originY];
            [self addSubview:confirmBtn];
            originY = CGRectGetMaxY(confirmBtn.frame);
        }
        else if(cancelButtonTitle && [_otherBtns count] == 1)
        {
            UIButton *cancelBtn = [self createBtnWithTitle:cancelButtonTitle backgroundColor:kColorCancel originY:originY];
            [self addSubview:cancelBtn];
            
            CGRect cancelFrm = cancelBtn.frame;
            cancelFrm.size.width = 135;
            [cancelBtn setFrame:cancelFrm];
            
            UIButton *confirmBtn = [self createBtnWithTitle:[_otherBtns objectAtIndex:0] backgroundColor:kColorConfirm originY:originY];
            [self addSubview:confirmBtn];
            
            CGRect confirmFrm = confirmBtn.frame;
            confirmFrm.origin.x = CGRectGetMaxX(cancelFrm) +5;
            confirmFrm.size.width = 135;
            [confirmBtn setFrame:confirmFrm];
            
            originY = CGRectGetMaxY(confirmBtn.frame);
        }
        else{
            UIButton *confirmBtn = [self createBtnWithTitle:[_otherBtns objectAtIndex:0] backgroundColor:kColorConfirm originY:originY];
            [self addSubview:confirmBtn];
            
            originY = CGRectGetMaxY(confirmBtn.frame)+kButtonMargin;
            
            NSArray *colors = [DCAlertView btnBackgroundColors];
            
            for(int i=1;i<[_otherBtns count];i++)
            {
                UIColor *color = kColorConfirm;
                if(i-1<[colors count])
                    color = [colors objectAtIndex:i-1];
                
                UIButton *confirmBtn = [self createBtnWithTitle:[_otherBtns objectAtIndex:i] backgroundColor:color originY:originY];
                [self addSubview:confirmBtn];
                
                originY = CGRectGetMaxY(confirmBtn.frame)+kButtonMargin;
            }
            
            if(cancelButtonTitle){
                UIButton *cancelBtn = [self createBtnWithTitle:cancelButtonTitle backgroundColor:kColorCancel originY:originY];
                [self addSubview:cancelBtn];
                originY = CGRectGetMaxY(cancelBtn.frame);
            }
            else
                originY -= kButtonMargin;
        }
        CGFloat height = originY +kBottomMargin;
        [self setFrame:CGRectMake(10, 0, 300, MIN(kAlertMaxHeight, MAX(kAlertMinHeight, height)))];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_bgView setBackgroundColor:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:0.2]];
        [keyWindow addSubview:_bgView];
    }
    [keyWindow addSubview:self];
    [self setCenter:keyWindow.center];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.layer addAnimation:popAnimation forKey:nil];
    
}

- (void)setAlertViewClickBlock:(void (^)(NSString *buttonTitle))block
{
    self.clickBlock = block;
}

@end
