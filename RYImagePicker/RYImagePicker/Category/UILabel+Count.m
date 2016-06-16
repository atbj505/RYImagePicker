//
//  UILabel+Count.m
//  RYImagePicker
//
//  Created by Robert on 16/6/12.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "UILabel+Count.h"


@implementation UILabel (Count)

- (void)updateCount:(NSInteger)count
{
    if (!count) {
        self.text = @"";
        return;
    }

    self.hidden = false;
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewSize];

    animation.fromValue = [NSValue valueWithCGSize:CGSizeZero];
    animation.toValue = [NSValue valueWithCGSize:self.bounds.size];
    [animation setAnimationDidStartBlock:^(POPAnimation *animation) {
        self.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    }];
    [self pop_addAnimation:animation forKey:@"kPOPViewBounds"];
}

@end
