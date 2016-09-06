//
//  RYImagePickerTableViewCell.h
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RYAlbumModel;


@interface RYImagePickerTableViewCell : UITableViewCell

@property (nonatomic, strong) RYAlbumModel *album;

@end
