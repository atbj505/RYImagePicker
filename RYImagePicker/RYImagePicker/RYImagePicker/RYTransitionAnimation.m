//
//  RYTransitionAnimation.m
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYTransitionAnimation.h"
#import "RYScaleImageViewController.h"
#import "RYImagePickerSelect.h"
#import "RYImagePickerColletionViewCell.h"

@interface RYTransitionAnimation ()

@property (nonatomic, assign) RYTransitionAnimationType type;

@property (nonatomic, strong) NSIndexPath *indexpath;

@end

@implementation RYTransitionAnimation

+ (RYTransitionAnimation *)animationWithTransitionType:(RYTransitionAnimationType)type indexpath:(NSIndexPath *)indexpath {
    RYTransitionAnimation *animation = [[RYTransitionAnimation alloc] initWithTransitionType:type indexpath:indexpath];
    return animation;
}

- (instancetype)initWithTransitionType:(RYTransitionAnimationType)type indexpath:(NSIndexPath *)indexpath{
    if (self = [super init]) {
        self.type = type;
        self.indexpath = indexpath;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.75f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == RYTransitionAnimationPush) {
        [self pushAnimationWithContext:transitionContext];
    }else if (self.type == RYTransitionAnimationPop) {
        [self popAnimationWithContext:transitionContext];
    }
}

- (void)pushAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    RYScaleImageViewController *ScaleImageVC = (RYScaleImageViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    RYImagePickerSelect *imagePickerSelect = (RYImagePickerSelect *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    RYImagePickerColletionViewCell *cell = (RYImagePickerColletionViewCell *)[imagePickerSelect.collectionView cellForItemAtIndexPath:self.indexpath];
    
    UIView *containerView = [transitionContext containerView];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:cell.imgView.frame];
    
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    tempView.frame = [cell.imgView convertRect:cell.imgView.bounds toView: containerView];
    
    cell.imgView.hidden = YES;
    ScaleImageVC.view.alpha = 0;
    ScaleImageVC.imageBrowser.hidden = YES;
    
    [containerView addSubview:ScaleImageVC.view];
    [containerView addSubview:tempView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [ScaleImageVC.imageBrowser convertRect:ScaleImageVC.imageBrowser.bounds toView:containerView];
        ScaleImageVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        ScaleImageVC.imageBrowser.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    RYScaleImageViewController *ScaleImageVC = (RYScaleImageViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    RYImagePickerSelect *imagePickerSelect = (RYImagePickerSelect *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    RYImagePickerColletionViewCell *cell = (RYImagePickerColletionViewCell *)[imagePickerSelect.collectionView cellForItemAtIndexPath:self.indexpath];
    
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = containerView.subviews.lastObject;
    
    cell.imgView.hidden = YES;
    ScaleImageVC.imageBrowser.hidden = YES;
    tempView.hidden = NO;
    
    [containerView insertSubview:imagePickerSelect.view atIndex:0];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [cell.imgView convertRect:cell.imgView.bounds toView:containerView];
        ScaleImageVC.view.alpha = 0;
    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:YES];
//        cell.imgView.hidden = NO;
//        [tempView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            tempView.hidden = YES;
            ScaleImageVC.imageBrowser.hidden = NO;
        }else{
            cell.imgView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

@end
