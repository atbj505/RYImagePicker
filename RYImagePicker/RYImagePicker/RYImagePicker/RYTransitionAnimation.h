//
//  RYTransitionAnimation.h
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIViewControllerTransitioning.h>

typedef NS_ENUM(NSUInteger, RYTransitionAnimationType) {
    RYTransitionAnimationPush,
    RYTransitionAnimationPop
};

@interface RYTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

+ (RYTransitionAnimation *)animationWithTransitionType:(RYTransitionAnimationType)type indexpath:(NSIndexPath *)indexpath;

@end
