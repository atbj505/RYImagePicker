//
//  RYImageModel.h
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RYImageModel : NSObject

@property (nonatomic, assign, readonly) NSUInteger imageCounts;

+ (RYImageModel *)sharedInstance;

- (void)addImage:(id)asset Indexpath:(NSIndexPath *)indexPath;

- (void)deleteImage:(NSIndexPath *)indexPath;

- (void)deleteAllImages;

@end
