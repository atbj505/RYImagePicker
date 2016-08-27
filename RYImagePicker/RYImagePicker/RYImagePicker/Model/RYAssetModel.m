//
//  RYAssetModel.m
//  RYImagePicker
//
//  Created by Robert on 16/8/24.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYAssetModel.h"


@implementation RYAssetModel

+ (instancetype)modelWithAsset:(id)asset
{
    RYAssetModel *model = [[RYAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    return model;
}

@end
