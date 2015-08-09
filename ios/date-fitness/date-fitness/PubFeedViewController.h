//
//  PubFeedViewController.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/7/5.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PubFeedViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)NSMutableArray *dataMArr;// 数据源
@property (weak, nonatomic) IBOutlet UICollectionView *myCollection;

@end
