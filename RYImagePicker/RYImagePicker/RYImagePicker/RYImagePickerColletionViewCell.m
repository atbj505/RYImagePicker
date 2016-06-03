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

- (void)tapSelectButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapSelectButton:add:)]) {
        if (self.selectButton.selected) {
            [self.delegate didTapSelectButton:self.asset add:false];
        }else {
            [self.delegate didTapSelectButton:self.asset add:true];
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
        [_selectButton addTarget:self action:@selector(tapSelectButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
    self.imgView.image = [UIImage imageWithCGImage:asset.thumbnail];
}

@end
