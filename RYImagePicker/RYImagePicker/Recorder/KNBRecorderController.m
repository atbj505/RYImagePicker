//
//  KNBRecorderController.m
//  KenuoTraining
//
//  Created by Robert on 16/3/3.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "KNBRecorderController.h"
#import "UIColor+Hex.h"
#import <LLSimpleCamera.h>
#import <UIImage+FixOrientation.h>
#import "UIImage+Resize.h"
#import <CoreMotion/CoreMotion.h>

static NSString *const KNBRecordCancel = @"camera-cancel";
static NSString *const KNBRecordSwitch = @"camera-switch";
static NSString *const KNBRecordFlash  = @"camera-flash";
static const CGFloat  KNBRecordGap     = 15;

@interface KNBRecorderController ()

@property (nonatomic, assign) KNBRecorderType type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) LLSimpleCamera *camera;

//错误提示框
@property (nonatomic, strong) UILabel *errorLabel;

//录制按钮
@property (nonatomic, strong) UIButton *snapButton;

//自拍切换开关
@property (nonatomic, strong) UIButton *switchButton;

//闪光灯开关
@property (nonatomic, strong) UIButton *flashButton;

//取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) CMMotionManager * motionManager;

@property (nonatomic, assign) UIImageOrientation orientation;

@end

@implementation KNBRecorderController

- (void)dealloc {
    [_motionManager stopDeviceMotionUpdates];
}

+ (KNBRecorderController *)recorderWithType:(KNBRecorderType)type Name:(NSString *)name {
    KNBRecorderController *controller = [[KNBRecorderController alloc] initWithType:type Name:name];
    return controller;
}

- (instancetype)initWithType:(KNBRecorderType)type Name:(NSString *)name {
    if (self = [super init]) {
        _type = type;
        _name = name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setUpCamera];
    [self setUpCoreMotion];
    self.orientation = UIImageOrientationUp;
    
    [self.view addSubview:self.errorLabel];
    [self.view addSubview:self.snapButton];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.flashButton];
    [self.view addSubview:self.cancelButton];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.camera start];
}

- (void)setUpCamera {
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetMedium
                                                 position:LLCameraPositionRear
                                             videoEnabled:YES];
    
    [self.camera attachToViewController:self withFrame:[UIScreen mainScreen].bounds];
    
    self.camera.fixOrientationAfterCapture = YES;
    
    [self.camera updateFlashMode:LLCameraFlashOff];
    
    if(![LLSimpleCamera isFrontCameraAvailable] || ![LLSimpleCamera isRearCameraAvailable]) {
        self.switchButton.hidden = YES;
    }
    
    WS(weakSelf);
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel.hidden) {
                    weakSelf.errorLabel.hidden = NO;
                }
            }
        }
    }];
}

- (void)setUpCoreMotion {
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 1/15.0;
    if (_motionManager.deviceMotionAvailable) {
        NSLog(@"Device Motion Available");
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler: ^(CMDeviceMotion *motion, NSError *error){
                                                [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
                                                
                                            }];
    } else {
        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    if (fabs(y) >= fabs(x))
    {
        if (y >= 0){
            self.orientation = UIImageOrientationDown;
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");
        }
        else{
            self.orientation = UIImageOrientationUp;
            NSLog(@"UIDeviceOrientationPortrait");
        }
    }
    else
    {
        if (x >= 0){
            self.orientation = UIImageOrientationRight;
            NSLog(@"UIDeviceOrientationLandscapeRight");
        }
        else{
            self.orientation = UIImageOrientationLeft;
            NSLog(@"UIDeviceOrientationLandscapeLeft");
        }
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didCancelPreview {
    [self.camera start];
}

#pragma mark - Target-Action
- (void)snapButtonPressed:(UIButton *)button {
    if (self.type == KNBRecorderPhoto) {
        WS(weakSelf);
        
        [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
            
            if(!error) {
                UIImage *fixedImage = [UIImage image:image rotation:weakSelf.orientation];
                
                [camera performSelector:@selector(stop) withObject:nil afterDelay:0.2];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                if (weakSelf.didSelectedConfirmBlock) {
                    weakSelf.didSelectedConfirmBlock(KNBRecorderPhoto, nil, nil, fixedImage);
                }
                
            }
            else {

            }
        } exactSeenImage:YES];
    }
}

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
    if (self.camera.position == LLCameraPositionRear) {
        self.switchButton.selected = NO;
        self.switchButton.backgroundColor = [UIColor clearColor];
    }else if (self.camera.position == LLCameraPositionFront) {
        self.switchButton.selected = YES;
        self.switchButton.backgroundColor = [UIColor colorWithHex:0xFF5e84];
    }
}

- (void)flashButtonPressed:(UIButton *)button {
    if(self.camera.flash == LLCameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.backgroundColor = [UIColor colorWithHex:0xFF5e84];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:LLCameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void)cancelButtonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter
- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.text = @"需要摄像头权限。\n请在设置中进行设置。";
        _errorLabel.numberOfLines = 2;
        _errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.font = [UIFont systemFontOfSize:13];
        _errorLabel.textColor = [UIColor whiteColor];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        [_errorLabel sizeToFit];
        _errorLabel.hidden = YES;
    }
    return _errorLabel;
}

-(UIButton *)snapButton {
    if (!_snapButton) {
        _snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _snapButton.size = CGSizeMake(70, 70);
        [_snapButton setImage:[UIImage imageNamed:@"camera-snap-nor"] forState:UIControlStateNormal];
        [_snapButton setImage:[UIImage imageNamed:@"camera-snap-sel"] forState:UIControlStateSelected];
        [_snapButton setImage:[UIImage imageNamed:@"camera-snap-sel"] forState:UIControlStateHighlighted];
        [_snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _snapButton;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:[UIImage imageNamed:KNBRecordSwitch] forState:UIControlStateNormal];
        _switchButton.imageEdgeInsets = UIEdgeInsetsMake(8.0f, 5.0f, 8.0f, 5.0f);
        _switchButton.layer.cornerRadius = 20;
        _switchButton.layer.masksToBounds = YES;
        [_switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setImage:[UIImage imageNamed:KNBRecordFlash] forState:UIControlStateNormal];
        _flashButton.imageEdgeInsets = UIEdgeInsetsMake(6.5f, 10.0f, 6.5f, 10.0f);
        _flashButton.layer.cornerRadius = 20;
        _flashButton.layer.masksToBounds = YES;
        [_flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cancelButton.tintColor = [UIColor whiteColor];
        [_cancelButton setImage:[UIImage imageNamed:KNBRecordCancel] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)viewWillLayoutSubviews {
    WS(weakSelf);
    
    [self.errorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf.view);
    }];
    
    [self.snapButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.width.and.height.mas_equalTo(@50);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-KNBRecordGap);
    }];
    
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-15);
        make.centerY.mas_equalTo(weakSelf.flashButton.mas_centerY);
        make.width.mas_equalTo(@(40));
        make.height.mas_equalTo(@(40));
    }];
    
    [self.flashButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(KNBRecordGap);
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(@(40));
        make.height.mas_equalTo(@(40));
    }];
    
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(KNBRecordGap);
        make.centerY.mas_equalTo(weakSelf.flashButton.mas_centerY);
        make.width.mas_equalTo(@(32));
        make.height.mas_equalTo(@(32));
    }];
}

@end
