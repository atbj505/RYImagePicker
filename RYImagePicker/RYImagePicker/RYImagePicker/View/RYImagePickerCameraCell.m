//
//  RYImagePickerCameraCell.m
//  RYImagePicker
//
//  Created by Robert on 16/6/14.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePickerCameraCell.h"
#import <AVFoundation/AVFoundation.h>

@interface RYImagePickerCameraCell ()

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation RYImagePickerCameraCell

- (void)dealloc {
    [self.session stopRunning];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self requestCameraPermission:^(BOOL granted) {
        if (granted) {
            self.session = [[AVCaptureSession alloc] init];
            self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera]error:nil];
            self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
            
            NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
            [self.stillImageOutput setOutputSettings:outputSettings];
            
            if ([self.session canAddInput:self.videoInput]) {
                [self.session addInput:self.videoInput];
            }
            if ([self.session canAddOutput:self.stillImageOutput]) {
                [self.session addOutput:self.stillImageOutput];
            }
            
            [self setUpCameraLayer];
            
            [self.session startRunning];
        }
    }];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (void)setUpCameraLayer {
    if (self.previewLayer == nil) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        self.layer.masksToBounds = true;
        
        [self.previewLayer setFrame:self.bounds];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
         [self.layer addSublayer:self.previewLayer];
    }
}

- (void)requestCameraPermission:(void (^)(BOOL granted))completionBlock {
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            // return to main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completionBlock) {
                    completionBlock(granted);
                }
            });
        }];
    } else {
        completionBlock(YES);
    }
    
}

@end
