//
//  RYScaleImageView.m
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYScaleImageView.h"

static const CGFloat RYMinimumZoomScale = 0.5;

static const CGFloat RYMaximumZoomScale = 3.0;

@interface RYScaleImageView () <UIScrollViewDelegate>

/**
 *  放大缩小图片用
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  显示图片用
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  遮挡视图
 */
@property (nonatomic, strong) UIView *blurView;

/**
 *  重新加载按钮
 */
@property (nonatomic, strong) UIButton *reloadButton;

@end

@implementation RYScaleImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.scrollView];
        [self addSubview:self.blurView];
    }
    return self;
}

- (void)restScale {
    [self.scrollView setZoomScale:1.0];
}

#pragma mark - Masonry
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    WS(weakSelf);
    
    [self.blurView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.mas_equalTo(weakSelf);
        make.height.mas_equalTo(49);
    }];
    
    [super updateConstraints];
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale == 1.0) {
        CGPoint point = [tap locationInView:self];
        
        CGFloat zoomWidth = self.bounds.size.width / RYMaximumZoomScale;
        CGFloat zoomHeight = self.bounds.size.height / RYMinimumZoomScale;
        
        [self.scrollView zoomToRect:CGRectMake(point.x - zoomWidth / 2, point.y - zoomHeight / 2, zoomWidth, zoomHeight) animated:YES];
        
    }else {
        [self.scrollView zoomToRect:self.bounds animated:YES];
    }
    
}

- (void)dismiss {
    if (self.delegate && [self.delegate respondsToSelector:@selector(singleTapImage:)]) {
        [self.delegate singleTapImage:self];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setScrollViewContentInset];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - Private Method
- (void)setScrollViewContentInset {
    CGSize imageViewSize = self.imageView.bounds.size;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0;
    CGFloat horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding);
}

#pragma mark - Setter && Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.minimumZoomScale = RYMinimumZoomScale;
        _scrollView.maximumZoomScale = RYMaximumZoomScale;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.imageView];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tap];
        
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIView *)blurView {
    if (!_blurView) {
        _blurView = [[UIView alloc] init];
        _blurView.backgroundColor = [UIColor blackColor];
        _blurView.alpha = 0.5f;
        _blurView.hidden = YES;
    }
    return _blurView;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setNeedBlurView:(bool)needBlurView {
    _needBlurView = needBlurView;
    self.blurView.hidden = !needBlurView;
}

@end
