//
//  RYImagePickerToolBar.h
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYImagePickerToolBarDelegate <NSObject>

- (void)didTapCancelButton;

- (void)didTapDoneButton;

@end

@interface RYImagePickerToolBar : UIView

@property (nonatomic, weak) id<RYImagePickerToolBarDelegate> delegate;

- (void)updateSelectCount;

@end
