//
//  RYImagePickerToolBar.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerToolBar.h"
#import "RYImageModel.h"

@interface RYImagePickerToolBar ()

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation RYImagePickerToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.cancelButton];
        
        [self addSubview:self.doneButton];
        
        [self addSubview:self.countLabel];
    }
    return self;
}

- (void)updateSelectCount {
    NSUInteger selectCount = [RYImageModel sharedInstance].imageCounts;
    self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)selectCount];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];
    
    animation.fromValue = [NSValue valueWithCGSize:self.countLabel.bounds.size];
    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(self.countLabel.bounds.size.width * 1.1, self.countLabel.bounds.size.height * 1.1)];
    
    [self.countLabel pop_addAnimation:animation forKey:@"kPOPViewBounds"];
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
    
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.doneButton.mas_left);
        make.width.equalTo(@(20));
        make.height.equalTo(@(15));
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

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
    }
    return _countLabel;
}

@end
