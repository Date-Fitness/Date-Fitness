//
//  FeedTableViewController.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/7/26.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedTableItem.h"
@interface FeedTableViewController ()

@end

@implementation FeedTableViewController

NSMutableArray *_items;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* imageURL = @"http://yuejian001.sinaapp.com/images/katong.jpg";
   
   // user_image = [UIImage circleImage:user_image];
    
        _items = [[NSMutableArray alloc]initWithCapacity:20];
        FeedTableItem *item;
        item = [[FeedTableItem alloc]init];
    item.nickname = @"嫦娥";
    item.text = @"观看嫦娥";
 
    item.createtime = @"12 点";
 item.img  =imageURL;

        [_items addObject:item];
     item.img  =imageURL;
    
        item = [[FeedTableItem alloc]init];
     item.nickname = @"嫦娥";
    item.text = @"观看灰熊";

    item.createtime = @"12 点";
     item.img  =imageURL;
  
        [_items addObject:item];
    
        item = [[FeedTableItem alloc]init];
    item.createtime = @"12 点";
    item.text = @"观看苍老师";
     item.nickname = @"嫦娥";

    item.img  =imageURL;
        [_items addObject:item];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedTableItem"];
    
    
    FeedTableItem *item = _items[indexPath.row];
    
    //username
    UILabel *userLabel = (UILabel*)[cell viewWithTag:1000];
    userLabel.text = item.nickname;
    
    UILabel *contentLabel = (UILabel*)[cell viewWithTag:1001];
    contentLabel.text = item.text;
    
   
    
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:item.img]];
    UIImage *img = [[UIImage alloc] initWithData:imageData];
    
    UIImageView *userImageView =(UIImageView*)[cell viewWithTag:1002];
    userImageView.image =img;
    UIImageView *imageView =(UIImageView*)[cell viewWithTag:1003];
    imageView.image = img;
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:1004];
    timeLabel.text = item.createtime;
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)newSign:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}
@end
