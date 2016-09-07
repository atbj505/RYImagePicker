//
//  RYImagePickerSelect.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerSelect.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RYImagePickerToolBar.h"
#import "RYImagePickerColletionViewCell.h"
#import "RYScaleImageViewController.h"
#import "RYImagePicker.h"
#import "ALAssetsLibrary+Singleton.h"
#import "RYAlbumModel.h"
#import "RYImageManager.h"

static const NSUInteger collectionViewGap = 2;


@interface RYImagePickerSelect () <UICollectionViewDelegate, UICollectionViewDataSource, RYImagePickerColletionViewCellDelegate, UINavigationControllerDelegate, RYScaleImageViewControllerDelegate, RYImagePickerToolBarDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) RYImagePickerToolBar *toolBar;

@property (nonatomic, strong) NSMutableArray *assetsArray;

@property (nonatomic, strong) RYScaleImageViewController *scaleImage;

@property (nonatomic, strong) NSIndexPath *selectedIndexpath;

@end


@implementation RYImagePickerSelect

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;

    self.assetsArray = [NSMutableArray array];

    [self.view addSubview:self.collectionView];

    [self.view addSubview:self.toolBar];

    self.title = self.album.name;

    [[RYImageManager sharedManager] getAssetsFromFetchResult:self.album.result completion:^(NSArray<RYAssetModel *> *models) {
        self.assetsArray = [models mutableCopy];
        [self.collectionView reloadData];
    }];

    RYImagePicker *imagePicker = [[RYImagePicker alloc] init];
    NSMutableArray *naviControllers = [self.navigationController.viewControllers mutableCopy];
    [naviControllers insertObject:imagePicker atIndex:1];
    self.navigationController.viewControllers = naviControllers;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - RYImagePickerColletionViewCellDelegate
- (void)didTapSelectButton:(RYAssetModel *)asset
{
    [self.toolBar updateSelectCount];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsArray.count;
}

static NSString *identifier = @"RYImagePickerColletionViewCell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RYImagePickerColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    cell.delegate = self;
    cell.asset = self.assetsArray[indexPath.row];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexpath = indexPath;
    self.scaleImage = [[RYScaleImageViewController alloc] init];
    self.scaleImage.imagesData = self.assetsArray;
    self.scaleImage.currentIndexPath = indexPath;
    self.scaleImage.delegate = self;
    self.navigationController.delegate = self.scaleImage;
    [self.navigationController pushViewController:self.scaleImage animated:YES];
}

#pragma mark - RYScaleImageViewControllerDelegate
- (UIImageView *)scaleImageViewControllerFromView
{
    RYImagePickerColletionViewCell *cell = (RYImagePickerColletionViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexpath];
    return cell.imgView;
}

- (UIView *)scaleImageViewControllerFromViewSuperView
{
    return self.view;
}

- (UIView *)scaleImageViewControllerToView
{
    return self.scaleImage.imageBrowser;
}

#pragma mark - RYImagePickerToolBarDelegate
- (void)didTapDoneButton
{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)didTapCancelButton
{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 48) collectionViewLayout:self.flowLayout];
        [_collectionView registerClass:[RYImagePickerColletionViewCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.scrollEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width - collectionViewGap * 5) / 4, (self.view.bounds.size.width - collectionViewGap * 5) / 4);
        _flowLayout.minimumLineSpacing = collectionViewGap;
        _flowLayout.minimumInteritemSpacing = collectionViewGap;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (RYImagePickerToolBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[RYImagePickerToolBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 48, self.view.bounds.size.width, 48)];
        _toolBar.backgroundColor = [UIColor redColor];
        _toolBar.delegate = self;
    }
    return _toolBar;
}

@end
