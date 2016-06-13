//
//  RYActionSheet.m
//  RYImagePicker
//
//  Created by Robert on 16/6/13.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYActionSheet.h"

@interface RYActionSheet ()

@property (nonatomic, copy) RYActionSheetSelectPhotoBlock photoBlock;

@property (nonatomic, copy) RYActionSheetActionBlock actionBlock;

@property (nonatomic, strong) UIWindow *backWindow;

@property (nonatomic, strong) UIView *darkView;

@property (nonatomic, strong) UIView *contentView;

@end

@implementation RYActionSheet

+ (instancetype)actionSheetWithSelectPhotoBlock:(RYActionSheetSelectPhotoBlock)photoBlock
                                    actionBlock:(RYActionSheetActionBlock)actionBlock {
    return [[[self class] alloc] initWithSelectPhotoBlock:photoBlock actionBlock:actionBlock];
}

- (instancetype)initWithSelectPhotoBlock:(RYActionSheetSelectPhotoBlock)photoBlock
                             actionBlock:(RYActionSheetActionBlock)actionBlock {
    if (self = [super init]) {
        [self addSubview:self.darkView];
        [self addSubview:self.contentView];
        self.userInteractionEnabled = YES;
        
        self.photoBlock = photoBlock;
        self.actionBlock = actionBlock;
    }
    return self;
}

- (void)show {
    [self.backWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [self.darkView setAlpha:0.35];
        
        CGRect frame = self.contentView.frame;
        frame.origin.y -= frame.size.height;
        [self.contentView setFrame:frame];
        
    } completion:^(BOOL finished) {
        [self.darkView setUserInteractionEnabled:YES];
    }];
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [self.darkView setAlpha:0];
        [self.darkView setUserInteractionEnabled:NO];
        
        CGRect frame = self.contentView.frame;
        frame.origin.y += frame.size.height;
        [self.contentView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView = [[UIView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
        [_darkView setAlpha:0];
        [_darkView setBackgroundColor:RYColor(46, 49, 50)];
        [_darkView setUserInteractionEnabled:false];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_darkView addGestureRecognizer:tap];
    }
    return _darkView;
}

- (UIWindow *)backWindow {
    if (!_backWindow) {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.userInteractionEnabled = YES;
        _backWindow.windowLevel = UIWindowLevelAlert;
        _backWindow.backgroundColor = [UIColor clearColor];
        [_backWindow addSubview:self];
    }
    return _backWindow;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 100)];
        _contentView.backgroundColor = RYColor(233, 233, 238);
    }
    return _contentView;
}

@end
