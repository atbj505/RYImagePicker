//
//  RYImageManager.h
//  RYImagePicker
//
//  Created by Robert on 16/6/15.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class RYAlbumModel, RYAssetModel;


@interface RYImageManager : NSObject

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;

+ (instancetype)sharedManager;

/**
 *  获取权限
 *
 *  @return 权限结果
 */
- (BOOL)authorizationStatusAuthorized;

- (void)getCameraRollAlbumCompletion:(void (^)(RYAlbumModel *model))completion;
- (void)getAllAlbumsCompletion:(void (^)(NSArray<RYAlbumModel *> *models))completion;

- (void)getAssetsFromFetchResult:(id)result allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(NSArray<RYAssetModel *> *models))completion;
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index allowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^)(RYAssetModel *model))completion;

- (void)getPostImageWithAlbumModel:(RYAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;
- (PHImageRequestID)getPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;
- (PHImageRequestID)getPhotoWithAsset:(id)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info))completion;

@end
