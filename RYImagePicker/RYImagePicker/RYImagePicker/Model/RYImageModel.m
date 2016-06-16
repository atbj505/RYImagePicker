//
//  RYImageModel.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImageModel.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface RYImageModel ()

@property (nonatomic, strong) NSMutableDictionary *assetsDic;

@end


@implementation RYImageModel

+ (RYImageModel *)sharedInstance
{
    static dispatch_once_t onceToken;
    static RYImageModel *model;
    dispatch_once(&onceToken, ^{
        model = [[[self class] alloc] init];
    });
    return model;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.assetsDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addImage:(ALAsset *)asset
{
    if (self.assetsDic) {
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        NSDictionary *dic = [asset valueForProperty:ALAssetPropertyURLs];
        UIImage *image = [UIImage imageWithCGImage:assetRep.fullScreenImage scale:0.5 orientation:UIImageOrientationUp];

        [self.assetsDic setObject:image forKey:dic[@"public.jpeg"]];
    }
}

- (void)deleteImage:(ALAsset *)asset
{
    if (self.assetsDic) {
        NSURL *assetUrl = [asset valueForProperty:ALAssetPropertyURLs];
        [self.assetsDic removeObjectForKey:assetUrl];
    }
}

- (void)deleteAllImages
{
    if (self.assetsDic) {
        [self.assetsDic removeAllObjects];
    }
}

- (NSArray *)getKeys;
{
    return self.assetsDic.allKeys;
}

- (NSUInteger)imageCounts
{
    return self.assetsDic.count;
}

@end
