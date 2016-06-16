//
//  RYImagePickerTableViewCell.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface RYImagePickerTableViewCell ()

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation RYImagePickerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.photoImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    WS(weakSelf);

    [self.photoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(5);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5);
        make.left.equalTo(weakSelf.mas_left).offset(5);
        make.width.equalTo(weakSelf.photoImageView.mas_height);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.photoImageView.mas_right).offset(10);
        make.height.equalTo(@(15));
        make.centerY.equalTo(weakSelf.photoImageView.mas_centerY);
    }];

    [super updateConstraints];
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
    }
    return _photoImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (void)setGroup:(ALAssetsGroup *)group
{
    CGImageRef posterImageRef = [group posterImage];
    UIImage *posterImage = [UIImage imageWithCGImage:posterImageRef];
    self.photoImageView.image = posterImage;
    self.titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
}

@end
