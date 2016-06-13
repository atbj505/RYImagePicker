//
//  ALAssetsLibrary+Singleton.m
//  RYImagePicker
//
//  Created by Robert on 16/6/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ALAssetsLibrary+Singleton.h"

@implementation ALAssetsLibrary (Singleton)

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end
