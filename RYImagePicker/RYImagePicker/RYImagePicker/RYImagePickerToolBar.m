//
//  RYImagePickerToolBar.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerToolBar.h"

@interface RYImagePickerToolBar ()

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation RYImagePickerToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.cancelButton];
        
        [self addSubview:self.doneButton];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    WS(weakSelf);
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.height.equalTo(weakSelf.mas_height);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [self.doneButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-5);
        make.height.equalTo(weakSelf.mas_height);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
    [super updateConstraints];
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _doneButton;
}
@end
