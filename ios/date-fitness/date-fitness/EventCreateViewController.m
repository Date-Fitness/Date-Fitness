//
//  EventCreateViewController.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/21.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "EventCreateViewController.h"

@interface EventCreateViewController ()

@end

@implementation EventCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)finished:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addVoice:(id)sender {
}

- (IBAction)cancel:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pub:(id)sender {
    NSLog(@"topic: %@ address: %@",self.topic.text,self.address.text);
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"发布成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    [alertview show];
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
