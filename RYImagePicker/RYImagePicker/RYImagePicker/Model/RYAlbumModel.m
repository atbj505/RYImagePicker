//
//  RYAlbumModel.m
//  RYImagePicker
//
//  Created by Robert on 16/8/26.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYAlbumModel.h"
#import "RYImageManager.h"


@implementation RYAlbumModel

- (void)setResult:(id)result
{
    _result = result;

    [[RYImageManager sharedManager] getAssetsFromFetchResult:result completion:^(NSArray<RYAssetModel *> *models) {
        _models = models;
    }];
}

@end
