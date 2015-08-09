//
//  NewSignTableViewController.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/7/19.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "NewSignTableViewController.h"
#import <QiniuSDK.h>

@interface NewSignTableViewController ()

@end

@implementation NewSignTableViewController
 BOOL takeImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancel:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addSign:(id)sender {
    NSString *token = @"RUs8meY4I5shtW50fgfXD-vXqBJRwErzRqck9LQ4:MaZzQM5lNvsa7vULB510bzPyYRU=:eyJzY29wZSI6ImRhdGUtZml0bmVzcyIsImRlYWRsaW5lIjoxNDM5MTE3MTI2fQ==";
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *data = UIImageJPEGRepresentation(self.displayImageView.image, 0.75);
    [upManager putData:data key:@"df/test2" token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
              } option:nil];
    
    
   [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.displayImageView.image = info[UIImagePickerControllerOriginalImage];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)chooseImage:(id)sender {
  takeImage = NO;
    [self getImage];
}
-(void) getImage{
    UIImagePickerController *imagePicker;
    imagePicker = [UIImagePickerController new];
        if (takeImage==YES) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)takeImage:(id)sender {
    takeImage = YES;
    [self getImage];
}
@end
