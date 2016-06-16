//
//  ViewController.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ViewController.h"
#import "RYImagePickerSelect.h"
#import "RYActionSheet.h"
#import <LLSimpleCamera.h>
#import "KNBRecorderController.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        [button setTitle:@"ImagePicker" forState:UIControlStateNormal];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];

        [button sizeToFit];

        button.center = self.view.center;

        button;
    })];
}

- (void)tapButton
{
    RYImagePickerSelect *imagePickerSelect = [[RYImagePickerSelect alloc] init];
    [self.navigationController pushViewController:imagePickerSelect animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    RYActionSheet *actionSheet = [RYActionSheet actionSheetWithSelectPhotoBlock:^(UIImage *image, BOOL isCamera) {
        if (isCamera) {
            KNBRecorderController *recordController = [KNBRecorderController recorderWithType:KNBRecorderPhoto Name:nil];

            WS(weakSelf);
            [recordController setDidSelectedConfirmBlock:^(KNBRecorderType type, NSString *name, UIImage *previewImage, UIImage *originImage){


            }];
            [weakSelf presentViewController:recordController animated:YES completion:nil];

        } else {
        }
    } actionBlock:^(RYActionSheetType type){

    }];

    [actionSheet show];
}

@end
