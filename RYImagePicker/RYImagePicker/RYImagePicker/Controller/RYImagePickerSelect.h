//
//  RYImagePickerSelect.h
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYAlbumModel;


@interface RYImagePickerSelect : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) RYAlbumModel *album;

@end
