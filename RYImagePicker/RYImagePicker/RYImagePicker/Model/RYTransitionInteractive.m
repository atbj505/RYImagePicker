//
//  RYTransitionInteractive.m
//  RYImagePicker
//
//  Created by Robert on 16/6/4.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYTransitionInteractive.h"


@interface RYTransitionInteractive ()

@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic, assign) RYTransitionInteractiveGestureDirection direction;

@property (nonatomic, assign) RYTransitionInteractiveType type;

@end


@implementation RYTransitionInteractive

+ (instancetype)interactiveTransitionWithTransitionType:(RYTransitionInteractiveType)type GestureDirection:(RYTransitionInteractiveGestureDirection)direction
{
    return [[[self class] alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(RYTransitionInteractiveType)type GestureDirection:(RYTransitionInteractiveGestureDirection)direction
{
    self = [super init];
    if (self) {
        self.direction = direction;
        self.type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture
{
    CGFloat persent = 0;
    switch (self.direction) {
        case RYTransitionInteractiveGestureDirectionLeft: {
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        } break;
        case RYTransitionInteractiveGestureDirectionRight: {
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        } break;
        case RYTransitionInteractiveGestureDirectionUp: {
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        } break;
        case RYTransitionInteractiveGestureDirectionDown: {
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        } break;
        case RYTransitionInteractiveGestureDirectionDown | RYTransitionInteractiveGestureDirectionUp: {
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        } break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interation = YES;
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.interation = NO;
            if (persent > 0.1 | persent < -0.1) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture
{
    switch (_type) {
        case RYTransitionInteractiveTypePresent: {
            if (_presentConifg) {
                _presentConifg();
            }
        } break;

        case RYTransitionInteractiveTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case RYTransitionInteractiveTypePush: {
            if (_pushConifg) {
                _pushConifg();
            }
        } break;
        case RYTransitionInteractiveTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}

@end
