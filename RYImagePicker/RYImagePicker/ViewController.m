//
//  ViewController.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "ViewController.h"
#import "RYImagePicker.h"
#import "RYImagePickerSelect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
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

- (void)tapButton {
//    RYImagePicker *imagePicker = [[RYImagePicker alloc] init];
//    [self.navigationController pushViewController:imagePicker animated:YES];
    RYImagePickerSelect *imagePickerSelect = [[RYImagePickerSelect alloc] init];
    [self.navigationController pushViewController:imagePickerSelect animated:YES];
}

@end
