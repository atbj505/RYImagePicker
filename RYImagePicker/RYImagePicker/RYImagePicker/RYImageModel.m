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

@property (nonatomic, strong) NSMutableDictionary *assetsArray;

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
        self.assetsArray = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addImage:(id)asset Indexpath:(NSIndexPath *)indexPath; {
    if (self.assetsArray) {
        if ([asset isKindOfClass:[ALAsset class]]) {
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            
            UIImage *image = [UIImage imageWithCGImage:assetRep.fullScreenImage scale:0.5 orientation:UIImageOrientationUp];
            
            [self.assetsArray setObject:image forKey:indexPath];
        }else if ([asset isKindOfClass:[UIImage class]]) {
            [self.assetsArray setObject:asset forKey:indexPath];
        }
    }
}

- (void)deleteImage:(NSIndexPath *)indexPath {
    if (self.assetsArray) {
        [self.assetsArray removeObjectForKey:indexPath];
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
