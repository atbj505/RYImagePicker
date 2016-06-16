//
//  RYScaleImageView.h
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYScaleImageView;


@interface RYScaleImageView : UIView

/**
 *  当前显示图片
 */
@property (nonatomic, strong) UIImage *image;


/**
 *  是否需要遮挡视图
 */
@property (nonatomic, assign) bool needBlurView;

/**
 *  重置放大倍数
 */
- (void)restScale;

@end
