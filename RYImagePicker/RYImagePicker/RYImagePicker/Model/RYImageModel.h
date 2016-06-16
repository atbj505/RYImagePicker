//
//  RYImageModel.h
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;


@interface RYImageModel : NSObject

@property (nonatomic, assign, readonly) NSUInteger imageCounts;

+ (RYImageModel *)sharedInstance;

- (void)addImage:(ALAsset *)asset;

- (void)deleteImage:(ALAsset *)asset;

- (void)deleteAllImages;

- (NSArray *)getKeys;

@end
