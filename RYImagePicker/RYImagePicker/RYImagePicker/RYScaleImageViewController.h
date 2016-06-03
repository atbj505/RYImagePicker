//
//  RYScaleImageViewController.h
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RYScaleImageViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *imageBrowser;

@property (nonatomic, strong) NSArray *imagesData;

@property (nonatomic, assign) NSIndexPath *currentIndexPath;

@end
