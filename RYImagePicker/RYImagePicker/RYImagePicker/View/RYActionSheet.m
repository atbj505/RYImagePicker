//
//  RYActionSheet.m
//  RYImagePicker
//
//  Created by Robert on 16/6/13.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYActionSheet.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "ALAssetsLibrary+Singleton.h"
#import "RYImagePickerColletionViewCell.h"
#import "RYImagePickerCameraCell.h"

static const NSUInteger PhotoHeight = 100;

@interface RYActionSheet () <UICollectionViewDelegate, UICollectionViewDataSource, RYImagePickerColletionViewCellDelegate>

@property (nonatomic, copy) RYActionSheetSelectPhotoBlock photoBlock;

@property (nonatomic, copy) RYActionSheetActionBlock actionBlock;

@property (nonatomic, strong) UIWindow *backWindow;

@property (nonatomic, strong) UIView *darkView;

@property (nonatomic, strong) UICollectionView *photoContentView;

@property (nonatomic, strong) ALAssetsGroup *group;

@property (nonatomic, strong) NSMutableArray *assetsArray;

@end

@implementation RYActionSheet

+ (instancetype)actionSheetWithSelectPhotoBlock:(RYActionSheetSelectPhotoBlock)photoBlock
                                    actionBlock:(RYActionSheetActionBlock)actionBlock {
    return [[[self class] alloc] initWithSelectPhotoBlock:photoBlock actionBlock:actionBlock];
}

- (instancetype)initWithSelectPhotoBlock:(RYActionSheetSelectPhotoBlock)photoBlock
                             actionBlock:(RYActionSheetActionBlock)actionBlock {
    if (self = [super init]) {
        self.assetsArray = [NSMutableArray arrayWithCapacity:6];
        self.assetsArray[0] = @"camera";
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self addSubview:self.darkView];
        [self addSubview:self.photoContentView];
        self.userInteractionEnabled = YES;
        
        self.photoBlock = photoBlock;
        self.actionBlock = actionBlock;
        
        [self requestAssetGroup:^{
            [self loadAsset];
        }];
    }
    return self;
}

- (void)requestAssetGroup:(void(^)(void))finishBlock {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self loadGroup:finishBlock];
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self loadGroup:finishBlock];
    }
}

- (void)loadGroup:(void(^)(void))finishBlock {
    ALAssetsLibrary *library = [ALAssetsLibrary defaultAssetsLibrary];
    
    WS(weakSelf);
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               if (group) {
                                   weakSelf.group = group;
                                   *stop = true;
                                   finishBlock();
                               }
                           } failureBlock:^(NSError *error) {
                               NSLog(@"%@", error);
                           }];
}

- (void)loadAsset {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.group) {
            WS(weakSelf);
            [self.group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                        [weakSelf.assetsArray addObject:result];
                    }
                }
                if (weakSelf.assetsArray.count == 6) {
                    *stop = true;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.photoContentView reloadData];
                    });
                }
            }];
        }
    });
}

- (void)show {
    [self.backWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [self.darkView setAlpha:0.35];
        
        CGRect frame = self.photoContentView.frame;
        frame.origin.y -= frame.size.height;
        [self.photoContentView setFrame:frame];
        
    } completion:^(BOOL finished) {
        [self.darkView setUserInteractionEnabled:YES];
    }];
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        [self.darkView setAlpha:0];
        [self.darkView setUserInteractionEnabled:NO];
        
        CGRect frame = self.photoContentView.frame;
        frame.origin.y += frame.size.height;
        [self.photoContentView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count == 1 ? 0 : self.assetsArray.count;
}

static NSString *photoIdentifier = @"RYImagePickerPhotoCell";
static NSString *cameraIdentifier = @"RYImagePickerCameraCell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        RYImagePickerCameraCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cameraIdentifier forIndexPath:indexPath];
        return cell;
    }else {
        RYImagePickerColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoIdentifier forIndexPath:indexPath];
        
        cell.delegate = self;
        cell.asset = self.assetsArray[indexPath.row];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.photoBlock(nil, true);
    }
}

#pragma mark - RYImagePickerColletionViewCellDelegate

- (void)didTapSelectButton:(ALAsset *)asset add:(BOOL)add {
    if (self.photoBlock) {
        ALAssetRepresentation *assetRep = [asset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:assetRep.fullScreenImage];
        
        self.photoBlock(image, false);
    }
}

- (UIView *)darkView {
    if (!_darkView) {
        _darkView = [[UIView alloc] initWithFrame:(CGRect){0, 0, [UIScreen mainScreen].bounds.size}];
        [_darkView setAlpha:0];
        [_darkView setBackgroundColor:RYColor(46, 49, 50)];
        [_darkView setUserInteractionEnabled:false];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [_darkView addGestureRecognizer:tap];
    }
    return _darkView;
}

- (UIWindow *)backWindow {
    if (!_backWindow) {
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.userInteractionEnabled = YES;
        _backWindow.windowLevel = UIWindowLevelAlert;
        _backWindow.backgroundColor = [UIColor clearColor];
        [_backWindow addSubview:self];
    }
    return _backWindow;
}

- (UICollectionView *)photoContentView {
    if (!_photoContentView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(PhotoHeight - 5, PhotoHeight - 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _photoContentView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, self.bounds.size.height - 200, self.bounds.size.width - 10, PhotoHeight) collectionViewLayout:flowLayout];
        [_photoContentView registerClass:[RYImagePickerColletionViewCell class] forCellWithReuseIdentifier:photoIdentifier];
        [_photoContentView registerClass:[RYImagePickerCameraCell class] forCellWithReuseIdentifier:cameraIdentifier];
        
        _photoContentView.backgroundColor = [UIColor clearColor];
        _photoContentView.scrollEnabled = YES;
        _photoContentView.showsHorizontalScrollIndicator = NO;
        _photoContentView.showsVerticalScrollIndicator = NO;
        _photoContentView.delegate = self;
        _photoContentView.dataSource = self;
    }
    return _photoContentView;
}

@end
