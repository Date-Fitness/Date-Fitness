//
//  ViewController.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/14.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//25627fb1f7c265b6d7485ba590ca0569

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

- (IBAction)verifyAction:(id)sender;
-(IBAction)textFieldDoneEditing:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

