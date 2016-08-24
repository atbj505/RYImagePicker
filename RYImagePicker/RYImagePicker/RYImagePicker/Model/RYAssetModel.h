//
//  RYAssetModel.h
//  RYImagePicker
//
//  Created by Robert on 16/8/24.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;


@interface RYAssetModel : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic, assign) BOOL isSelected;

@end
