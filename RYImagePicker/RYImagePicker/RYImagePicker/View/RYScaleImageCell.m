//
//  RYScaleImageCell.m
//  RYImagePicker
//
//  Created by Robert on 16/6/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYScaleImageCell.h"


@implementation RYScaleImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scaleImage = [[RYScaleImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.scaleImage];
    }
    return self;
}

@end
