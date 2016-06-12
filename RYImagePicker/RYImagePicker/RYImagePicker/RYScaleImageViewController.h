//
//  RYScaleImageViewController.h
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALAsset;

@protocol RYScaleImageViewControllerDelegate <NSObject>

- (UIImageView*)scaleImageViewControllerFromView;

- (UIView *)scaleImageViewControllerFromViewSuperView;

- (UIView*)scaleImageViewControllerToView;

//- (void)didTapSelectButton:(ALAsset *)asset add:(BOOL)add;

@end

@interface RYScaleImageViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *imageBrowser;

@property (nonatomic, strong) NSArray *imagesData;

@property (nonatomic, assign) NSIndexPath *currentIndexPath;

@property (nonatomic, weak) id<RYScaleImageViewControllerDelegate> delegate;

@end
