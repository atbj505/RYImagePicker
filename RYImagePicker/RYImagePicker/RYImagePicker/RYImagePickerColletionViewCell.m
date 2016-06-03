//
//  RYImagePickerColletionViewCell.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerColletionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface RYImagePickerColletionViewCell ()

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation RYImagePickerColletionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.imgView];
        
        [self addSubview:self.selectButton];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    WS(weakSelf);
    
    [self.selectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.width.and.height.equalTo(@(20));
    }];
    
    [super updateConstraints];
}

- (void)tapSelectButton {
    self.selectButton.selected = !self.selectButton.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapSelectButton:add:)]) {
        if (self.selectButton.selected) {
            [self.delegate didTapSelectButton:self.asset add:true];
        }else {
            [self.delegate didTapSelectButton:self.asset add:false];
        }
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imgView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setBackgroundColor:[UIColor redColor]];
        [_selectButton addTarget:self action:@selector(tapSelectButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
    self.imgView.image = [UIImage imageWithCGImage:asset.thumbnail];
}

@end
