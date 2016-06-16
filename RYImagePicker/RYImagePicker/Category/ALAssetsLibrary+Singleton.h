//
//  ALAssetsLibrary+Singleton.h
//  RYImagePicker
//
//  Created by Robert on 16/6/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>


@interface ALAssetsLibrary (Singleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
