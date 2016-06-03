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
#import "RYImageModel.h"

static const NSUInteger collectionViewGap = 2;

@interface RYImagePickerSelect () <UICollectionViewDelegate, UICollectionViewDataSource, RYImagePickerColletionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) RYImagePickerToolBar *toolBar;

@property (nonatomic, strong) NSMutableArray *assetsArray;

@end

@implementation RYImagePickerSelect

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.group valueForProperty:ALAssetsGroupPropertyName];
    
    self.assetsArray = [NSMutableArray array];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.toolBar];
    
    [self loadAsset];
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
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                }
            }];
        }
    });
}

#pragma mark - RYImagePickerColletionViewCellDelegate
- (void)didTapSelectButton:(ALAsset *)asset add:(BOOL)add {
    if (add) {
        [[RYImageModel sharedInstance] addImage:asset];
    }else {
        [[RYImageModel sharedInstance] deleteImage:asset];
    }
    [self.toolBar updateSelectCount];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetsArray.count;
}

static NSString *identifier = @"RYImagePickerColletionViewCell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RYImagePickerColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.asset = self.assetsArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)index {
    
}

- (UICollectionView *)collectionView {
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

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake((self.view.bounds.size.width - collectionViewGap * 5) / 4, (self.view.bounds.size.width - collectionViewGap * 5) / 4);
        _flowLayout.minimumLineSpacing = collectionViewGap;
        _flowLayout.minimumInteritemSpacing = collectionViewGap;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (RYImagePickerToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[RYImagePickerToolBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 48, self.view.bounds.size.width, 48)];
        _toolBar.backgroundColor = [UIColor redColor];
    }
    return _toolBar;
}

@end
