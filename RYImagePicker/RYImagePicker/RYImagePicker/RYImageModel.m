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

@property (nonatomic, strong) NSMutableArray *assetsArray;

@end

@implementation RYImageModel

+ (RYImageModel *)sharedInstance {
    static dispatch_once_t onceToken;
    static RYImageModel *model;
    dispatch_once(&onceToken, ^{
        model = [[[self class] alloc] init];
    });
    return model;
}

- (instancetype)init {
    if (self = [super init]) {
        self.assetsArray = [NSMutableArray array];
    }
    return self;
}

- (void)addImage:(ALAsset *)asset {
    if (self.assetsArray) {
        [self.assetsArray addObject:asset];
    }
}

- (void)deleteImage:(ALAsset *)asset {
    if (self.assetsArray) {
        [self.assetsArray removeObject:asset];
    }
}

- (void)deleteAllImages {
    if (self.assetsArray) {
        [self.assetsArray removeAllObjects];
    }
}

- (NSUInteger)imageCounts {
    return self.assetsArray.count;
}

@end
