//
//  RYAlbumModel.m
//  RYImagePicker
//
//  Created by Robert on 16/8/26.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYAlbumModel.h"
#import "RYImageManager.h"
#import "RYAssetModel.h"


@implementation RYAlbumModel

- (void)setResult:(id)result
{
    _result = result;

    [[RYImageManager sharedManager] getAssetsFromFetchResult:result completion:^(NSArray<RYAssetModel *> *models) {
        _models = models;
    }];
}

- (void)setSelectedModels:(NSArray *)selectedModels
{
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels
{
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (RYAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (RYAssetModel *model in _models) {
        if ([[RYImageManager sharedManager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount++;
        }
    }
}

@end
