//
//  RYImagePickerColletionViewCell.h
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

@protocol RYImagePickerColletionViewCellDelegate <NSObject>

- (void)didTapSelectButton:(ALAsset *)asset add:(BOOL)add;

@end

@interface RYImagePickerColletionViewCell : UICollectionViewCell

@property (nonatomic, strong) ALAsset *asset;

@property (nonatomic, weak) id<RYImagePickerColletionViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, assign) BOOL isSelected;

@end
