//
//  PubFeedViewController.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/7/5.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "PubFeedViewController.h"
#import "FeedCollectionViewCell.h"

@interface PubFeedViewController ()

@end

@implementation PubFeedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCollection];
    
    
    UIButton *newSignButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newSignButton.frame = CGRectMake(240, CGRectGetHeight(self.view.bounds)-100, 40, 40);
    newSignButton.autoresizingMask =
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    [newSignButton addTarget:self action:@selector(newSignAction) forControlEvents:UIControlEventTouchUpInside];
    [newSignButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [self.view addSubview:newSignButton];
}

-(void)newSignAction{
    [self performSegueWithIdentifier:@"new_sign" sender:self];
    
}

-(void)setUpCollection{
    self.dataMArr = [NSMutableArray array];
    for(NSInteger index = 0;index<9; index++){
        UIImage *image = [UIImage imageNamed:@"gym"];
        NSString *title = [NSString stringWithFormat:@"{0,%ld}",(long)index+1];
        NSDictionary *dic = @{@"image": image, @"title":title};
        [self.dataMArr addObject:dic];
    }
    self.myCollection.delegate = self;
    self.myCollection.dataSource = self;
    //[self.myCollection registerClass:[FeedCollectionViewCell class] forCellWithReuseIdentifier:@"myCollectionCell"];
    
    
}
#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataMArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *collectionCellID = @"myCollectionCell";
    FeedCollectionViewCell *cell = (FeedCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    NSDictionary *dic    = self.dataMArr[indexPath.row];
    UIImage *image       = dic[@"image"];
    NSString *title      = dic[@"title"];
    
    cell.img.image = image;
    cell.brief.text = title;
    
    return cell;
};

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

@end
