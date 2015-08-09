//
//  ProfileTableViewController.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/7/19.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *dateRecords;
@property (weak, nonatomic) IBOutlet UITableViewCell *signRecords;
@property (weak, nonatomic) IBOutlet UITableViewCell *friends;

@end
