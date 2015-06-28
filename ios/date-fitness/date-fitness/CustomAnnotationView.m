//
//  CustomAnnotationView.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/21.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "CustomAnnotationView.h"

@interface CustomAnnotationView()

@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;


@end

@implementation CustomAnnotationView
@synthesize  calloutView = calloutView;


-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if(self.selected == selected){
        return;
    }
    if(selected){
        if(self.calloutView == nil){
#define kCalloutWidth 200.0
#define kCalloutHeight 70.0
            self.calloutView = [[CustomCalloutView alloc]initWithFrame:
                                CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(
                    self.bounds)/2.f ,
                                                  -CGRectGetHeight(self.calloutView.bounds)/2.f);
        }
        
        self.calloutView.image = [UIImage imageNamed:@"building"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        
        [self addSubview:self.calloutView];
    }else{
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    if (!inside && self.selected) {
        inside = [self.calloutView pointInside: [self convertPoint:point
                    toView:self.calloutView] withEvent:event];
    }
    return inside;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
