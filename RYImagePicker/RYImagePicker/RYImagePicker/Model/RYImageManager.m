//
//  RYImageManager.m
//  RYImagePicker
//
//  Created by Robert on 16/6/15.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImageManager.h"
#import "RYAlbumModel.h"
#import "RYAssetModel.h"
#import <UIImage+FixOrientation.h>
#import "UIImage+Resize.h"


@interface RYImageManager ()

@property (nonatomic, assign) CGSize assetThumbSize;

@end


@implementation RYImageManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static RYImageManager *imageManager;
    dispatch_once(&onceToken, ^{
        imageManager = [[self alloc] init];
        imageManager.cachingImageManager = [[PHCachingImageManager alloc] init];
        imageManager.cachingImageManager.allowsCachingHighQualityImages = false;

        imageManager.assetLibrary = [[ALAssetsLibrary alloc] init];

        imageManager.assetThumbSize = CGSizeMake((RYScreenWidth - 2 * 5) / 4, (RYScreenWidth - 2 * 5) / 4);
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

- (void)getCameraRollAlbumCompletion:(void (^)(RYAlbumModel *model))completion
{
    __block RYAlbumModel *model;
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        // option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        option.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES] ];

        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];

        for (PHAssetCollection *collection in smartAlbums) {
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"] || [collection.localizedTitle isEqualToString:@"所有照片"]) {
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                model = [self modelWithResult:fetchResult name:collection.localizedTitle];
                if (completion) completion(model);
                break;
            }
        }
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"] || [name isEqualToString:@"所有照片"]) {
                model = [self modelWithResult:group name:name];
                if (completion) completion(model);
                *stop = YES;
            }
        } failureBlock:nil];
    }
}

- (void)getAllAlbumsCompletion:(void (^)(NSArray<RYAlbumModel *> *models))completion
{
    NSMutableArray *albumArr = [NSMutableArray array];
    if (iOS8Later) {
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        // option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        option.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES] ];

        PHAssetCollectionSubtype smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumVideos;

        if (iOS9Later) {
            smartAlbumSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary | PHAssetCollectionSubtypeSmartAlbumRecentlyAdded | PHAssetCollectionSubtypeSmartAlbumScreenshots | PHAssetCollectionSubtypeSmartAlbumSelfPortraits | PHAssetCollectionSubtypeSmartAlbumVideos;
        }
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:smartAlbumSubtype options:nil];
        for (PHAssetCollection *collection in smartAlbums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]) continue;
            if ([collection.localizedTitle isEqualToString:@"Camera Roll"] || [collection.localizedTitle isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
            } else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }

        PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        for (PHAssetCollection *collection in albums) {
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (fetchResult.count < 1) continue;
            if ([collection.localizedTitle isEqualToString:@"My Photo Stream"] || [collection.localizedTitle isEqualToString:@"我的照片流"]) {
                [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:1];
            } else {
                [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
            }
        }
        if (completion && albumArr.count > 0) completion(albumArr);
    } else {
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group == nil) {
                if (completion && albumArr.count > 0) completion(albumArr);
            }
            if ([group numberOfAssets] < 1) return;
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:@"Camera Roll"] || [name isEqualToString:@"相机胶卷"]) {
                [albumArr insertObject:[self modelWithResult:group name:name] atIndex:0];
            } else if ([name isEqualToString:@"My Photo Stream"] || [name isEqualToString:@"我的照片流"]) {
                [albumArr insertObject:[self modelWithResult:group name:name] atIndex:1];
            } else {
                [albumArr addObject:[self modelWithResult:group name:name]];
            }
        } failureBlock:nil];
    }
}

- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<RYAssetModel *> *models))completion
{
    NSMutableArray *photoArr = [NSMutableArray array];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        [fetchResult enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;

            if (asset.mediaType == PHAssetMediaTypeImage) {
                RYAssetModel *model = [RYAssetModel modelWithAsset:asset];

                [photoArr addObject:model];
            }
        }];
        if (completion) completion(photoArr);
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                if (completion) completion(photoArr);
            }

            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                RYAssetModel *model = [RYAssetModel modelWithAsset:result];

                [photoArr addObject:model];
            }
        }];
    }
}

- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index completion:(void (^)(RYAssetModel *model))completion
{
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        PHAsset *asset = fetchResult[index];

        RYAssetModel *model;
        if (asset.mediaType == PHAssetMediaTypeImage) {
            model = [RYAssetModel modelWithAsset:asset];
        }
        if (completion) completion(model);
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
        [group enumerateAssetsAtIndexes:indexSet options:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result == nil) {
                if (completion) completion(nil);
            }

            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                RYAssetModel *model = [RYAssetModel modelWithAsset:result];
                if (completion) completion(model);
            }
        }];
    }
}

- (void)getPostImageWithAlbumModel:(RYAlbumModel *)model completion:(void (^)(UIImage *postImage))completion
{
    if (iOS8Later) {
        PHAsset *asset = (PHAsset *)[model.result lastObject];
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;

        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:self.assetThumbSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *_Nullable result, NSDictionary *_Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && result) {
                result = [result fixOrientation];
                if (completion) completion(result);
            }
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.networkAccessAllowed = YES;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData *_Nullable imageData, NSString *_Nullable dataUTI, UIImageOrientation orientation, NSDictionary *_Nullable info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    //                    resultImage = [self scaleImage:resultImage toSize:imageSize];
                    resultImage = [resultImage resizedImage:self.assetThumbSize interpolationQuality:0];
                    if (resultImage) {
                        resultImage = [result fixOrientation];
                        if (completion) completion(resultImage);
                    }
                }];
            }
        }];
    } else {
        ALAssetsGroup *group = model.result;
        UIImage *postImage = [UIImage imageWithCGImage:group.posterImage];
        if (completion) completion(postImage);
    }
}

#pragma mark Private Method
- (RYAlbumModel *)modelWithResult:(id)result name:(NSString *)name
{
    RYAlbumModel *model = [[RYAlbumModel alloc] init];
    model.result = result;
    model.name = [self getNewAlbumName:name];
    if ([result isKindOfClass:[PHFetchResult class]]) {
        PHFetchResult *fetchResult = (PHFetchResult *)result;
        model.count = fetchResult.count;
    } else if ([result isKindOfClass:[ALAssetsGroup class]]) {
        ALAssetsGroup *group = (ALAssetsGroup *)result;
        model.count = [group numberOfAssets];
    }
    return model;
}

- (NSString *)getNewAlbumName:(NSString *)name
{
    if (iOS8Later) {
        NSString *newName;
        if ([name rangeOfString:@"Roll"].location != NSNotFound)
            newName = @"相机胶卷";
        else if ([name rangeOfString:@"Stream"].location != NSNotFound)
            newName = @"我的照片流";
        else if ([name rangeOfString:@"Added"].location != NSNotFound)
            newName = @"最近添加";
        else if ([name rangeOfString:@"Selfies"].location != NSNotFound)
            newName = @"自拍";
        else if ([name rangeOfString:@"shots"].location != NSNotFound)
            newName = @"截屏";
        else if ([name rangeOfString:@"Videos"].location != NSNotFound)
            newName = @"视频";
        else if ([name rangeOfString:@"Panoramas"].location != NSNotFound)
            newName = @"全景照片";
        else if ([name rangeOfString:@"Favorites"].location != NSNotFound)
            newName = @"个人收藏";
        else
            newName = name;
        return newName;
    } else {
        return name;
    }
}

@end
