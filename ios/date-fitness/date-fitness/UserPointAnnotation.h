//
//  UserPointAnnotation.h
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/28.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface UserPointAnnotation : MAPointAnnotation {
NSString * _uid;
NSString * _img;
}

/*!
 @brief 标题
 */
@property (copy) NSString *_uid;

/*!
 @brief 副标题
 */
@property (copy) NSString *_img;

@end
