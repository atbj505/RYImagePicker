//
//  RYImagePicker.m
//  RYImagePicker
//
//  Created by Robert on 16/6/2.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import "RYImagePicker.h"
#import "RYImagePickerTableViewCell.h"
#import "RYImagePickerSelect.h"
#import "RYImageManager.h"
#import "RYAlbumModel.h"


@interface RYImagePicker () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *photoGroups;

@property (nonatomic, strong) UITableView *tableView;

@end


@implementation RYImagePicker

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.photoGroups = [NSMutableArray array];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;

    [self.view addSubview:({
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.tableView registerClass:[RYImagePickerTableViewCell class] forCellReuseIdentifier:identifier];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = [[UIView alloc] init];

        self.tableView;
    })];

    [self loadData];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadData
{
    //    self.library = [[ALAssetsLibrary alloc] init];
    //
    //    WS(weakSelf);
    //    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
    //        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    //            if (group) {
    //                [weakSelf.photoGroups addObject:group];
    //            } else {
    //                [self.tableView reloadData];
    //            }
    //        }
    //        failureBlock:^(NSError *error) {
    //            NSLog(@"%@", error);
    //        }];
    WS(weakSelf);
    [[RYImageManager sharedManager] getAllAlbumsCompletion:^(NSArray<RYAlbumModel *> *models) {
        weakSelf.photoGroups = [models copy];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoGroups.count;
}

static NSString *identifier = @"RYImagePickerTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RYImagePickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RYImagePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.album = self.photoGroups[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    RYAlbumModel *album = self.photoGroups[indexPath.row];

    RYImagePickerSelect *imageSelect = [[RYImagePickerSelect alloc] init];
    imageSelect.album = album;
    [self.navigationController pushViewController:imageSelect animated:YES];
}

@end
