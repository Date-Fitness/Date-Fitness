//
//  EventCreateViewController.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/21.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCreateViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *topic;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *tag;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)addVoice:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)pub:(id)sender;

@end
