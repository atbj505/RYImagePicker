//
//  RYImagePickerActionCell.m
//  RYImagePicker
//
//  Created by Robert on 16/6/15.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerActionCell.h"

@implementation RYImagePickerActionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nameLabel];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    
    WS(weakSelf);
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];

    [super updateConstraints];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
