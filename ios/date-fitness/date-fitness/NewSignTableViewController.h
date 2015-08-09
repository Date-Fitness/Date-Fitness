//
//  NewSignTableViewController.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/7/19.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSignTableViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)cancel:(id)sender;
- (IBAction)addSign:(id)sender;
- (IBAction)chooseImage:(id)sender;
- (IBAction)takeImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;

@end
