//
//  RYScaleImageCell.h
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYScaleImageView.h"

@class ALAsset;

@protocol RYScaleImageCellDelegate <NSObject>

- (void)didTapSelectButton:(ALAsset *)asset add:(BOOL)add;

@end

@interface RYScaleImageCell : UICollectionViewCell

@property (nonatomic, strong) RYScaleImageView *scaleImage;

@property (nonatomic, weak) id<RYScaleImageCellDelegate> delegate;

@end
