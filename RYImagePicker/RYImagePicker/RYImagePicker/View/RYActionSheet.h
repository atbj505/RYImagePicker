//
//  RYActionSheet.h
//  RYImagePicker
//
//  Created by Robert on 16/6/13.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RYActionSheetType) {
    RYActionSheetFile,
    RYActionSheetLocation,
    RYActionSheetCards,
};

typedef void(^RYActionSheetSelectPhotoBlock) (UIImage *image, BOOL isCamera);
typedef void(^RYActionSheetActionBlock) (RYActionSheetType type);

@interface RYActionSheet : UIView

+ (instancetype)actionSheetWithSelectPhotoBlock:(RYActionSheetSelectPhotoBlock)photoBlock
                                    actionBlock:(RYActionSheetActionBlock)actionBlock;

- (void)show;

@end
