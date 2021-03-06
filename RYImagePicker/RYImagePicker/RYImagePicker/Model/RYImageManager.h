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

/**
 *  获取所有Album
 *
 *  @param completion Albums对象回调
 */
- (void)getAllAlbumsCompletion:(void (^)(NSArray<RYAlbumModel *> *models))completion;

/**
 *  获取Camera Roll相册
 *
 *  @param completion Camera Roll相册对象回调
 */
- (void)getCameraRollAlbumCompletion:(void (^)(RYAlbumModel *model))completion;

/**
 *  获取所有Assets
 *
 *  @param result     Album对象
 *  @param completion Assets对象回调
 */
- (void)getAssetsFromFetchResult:(id)result completion:(void (^)(NSArray<RYAssetModel *> *models))completion;

/**
 *  获取指定位置Asset
 *
 *  @param result     Album对象
 *  @param index      指定位置
 *  @param completion Asset对象回调
 */
- (void)getAssetFromFetchResult:(id)result atIndex:(NSInteger)index completion:(void (^)(RYAssetModel *model))completion;

/**
 *  获取图片
 *
 *  @param model      Album对象
 *  @param completion 图像回调
 */
- (void)getPostImageWithAlbumModel:(RYAlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

/**
 *  获取原图
 *
 *  @param asset      Asset对象
 *  @param completion 图像回调
 */
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(UIImage *photo, NSDictionary *info))completion;

/**
 *  判断时候已选择
 *
 *  @param assets 所有Asset模型
 *  @param asset  待判断asset
 *
 *  @return 是否已选择
 */
- (BOOL)isAssetsArray:(NSArray *)assets containAsset:(id)asset;

@end
