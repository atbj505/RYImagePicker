//
//  RYImageManager.m
//  RYImagePicker
//
//  Created by Robert on 16/6/15.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImageManager.h"


@implementation RYImageManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static RYImageManager *imageManager;
    dispatch_once(&onceToken, ^{
        imageManager = [[self alloc] init];
    });
    return imageManager;
}

- (BOOL)authorizationStatusAuthorized
{
    if (iOS8Later) {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) return YES;
    } else {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) return YES;
    }
    return NO;
}

@end
