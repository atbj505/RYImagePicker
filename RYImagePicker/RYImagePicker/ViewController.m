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
    RYImagePickerSelect *imagePickerSelect = [[RYImagePickerSelect alloc] init];
    [self.navigationController pushViewController:imagePickerSelect animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    RYActionSheet *actionSheet = [RYActionSheet actionSheetWithSelectPhotoBlock:^(NSInteger index, UIImage *image) {
        
    } actionBlock:^(NSInteger index, RYActionSheetType type) {
        
    }];
    
    [actionSheet show];
    
}

@end
