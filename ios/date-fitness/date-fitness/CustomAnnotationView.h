//
//  CustomAnnotationView.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/21.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAAnnotationView

@property(nonatomic, readonly) CustomCalloutView *calloutView;

@end
