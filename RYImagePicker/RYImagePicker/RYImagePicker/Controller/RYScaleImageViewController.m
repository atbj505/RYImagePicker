//
//  RYScaleImageViewController.m
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYScaleImageViewController.h"
#import "RYScaleImageView.h"
#import "RYScaleImageCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RYTransitionAnimation.h"
#import "RYTransitionInteractive.h"
#import "RYScaleImageToolBar.h"

@interface RYScaleImageViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSIndexPath *preIndexPath;

@property (nonatomic, strong) RYTransitionInteractive *transitionInteractive;

@property (nonatomic, strong) RYScaleImageToolBar *toolbar;

@end

@implementation RYScaleImageViewController

- (instancetype)init {
    if (self = [super init]) {
        
        [self.view addSubview:self.imageBrowser];
        
        [self.view addSubview:self.toolbar];
    }
    return self;
}

#pragma mark - Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.transitionInteractive = [RYTransitionInteractive interactiveTransitionWithTransitionType:RYTransitionInteractiveTypePop GestureDirection:RYTransitionInteractiveGestureDirectionUp|RYTransitionInteractiveGestureDirectionDown];
    
    [self.transitionInteractive addPanGestureForViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = false;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.delegate = nil;
    self.navigationController.interactivePopGestureRecognizer.enabled = true;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RYScaleImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    self.preIndexPath = indexPath;
    
    ALAsset *asset = self.imagesData[indexPath.row];
    
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    
    UIImage *image = [UIImage imageWithCGImage:assetRep.fullScreenImage scale:0.5 orientation:UIImageOrientationUp];
    
    cell.scaleImage.image = image;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    RYScaleImageCell *scaleCell = (RYScaleImageCell *)cell;
    [scaleCell.scaleImage restScale];
}

#pragma mark - Getter
- (UICollectionView *)imageBrowser {
    if (!_imageBrowser) {
        
        _imageBrowser = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.flowLayout];
        _imageBrowser.backgroundColor = [UIColor clearColor];
        _imageBrowser.pagingEnabled = YES;
        _imageBrowser.scrollEnabled = YES;
        _imageBrowser.showsHorizontalScrollIndicator = NO;
        _imageBrowser.showsVerticalScrollIndicator = NO;
        [_imageBrowser registerClass:[RYScaleImageCell class] forCellWithReuseIdentifier:@"Cell"];
        _imageBrowser.dataSource = self;
        _imageBrowser.delegate = self;
    }
    return _imageBrowser;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (void)setCurrentIndexPath:(NSIndexPath *)currentIndexPath {
    _currentIndexPath = currentIndexPath;
    [self.imageBrowser scrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    UIImageView *fromView;
    UIView *toView;
    UIView *fromViewSuperView;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scaleImageViewControllerFromView)] && [self.delegate respondsToSelector:@selector(scaleImageViewControllerToView)] && [self.delegate respondsToSelector:@selector(scaleImageViewControllerFromViewSuperView)]) {
        
        fromView = [self.delegate scaleImageViewControllerFromView];
        toView = [self.delegate scaleImageViewControllerToView];
        fromViewSuperView = [self.delegate scaleImageViewControllerFromViewSuperView];
        
    }else {
        return nil;
    }
    
    if (operation == UINavigationControllerOperationPush) {
        return [RYTransitionAnimation animationWithTransitionType:RYTransitionAnimationPush FromView:fromView FromViewSuperView:fromViewSuperView ToView:toView];
    }else {
        return [RYTransitionAnimation animationWithTransitionType:RYTransitionAnimationPop FromView:fromView FromViewSuperView:fromViewSuperView ToView:toView];
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{

    return self.transitionInteractive.interation ? self.transitionInteractive : nil;
}

@end
