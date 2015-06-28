//
//  CallOutDateView.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/28.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "CallOutDateView.h"



#define kPortraitMargin     5
#define kPortraitWidth      300
#define kPortraitHeight     240

#define kTitleWidth         300
#define kTitleHeight        20


@interface CallOutDateView ()
@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong,readwrite) UIButton *calloutButton;

@end

@implementation CallOutDateView


- (void)initSubViews
{
    // 添加图片
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin, kPortraitWidth, kPortraitHeight)];
    
    self.portraitView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.portraitView];
    
    // 添加标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin , kPortraitMargin+ kPortraitHeight, kTitleWidth, kTitleHeight)];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"titletitletitletitle";
    [self addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin , kPortraitMargin + kPortraitHeight+kTitleHeight, kTitleWidth, kTitleHeight*2)];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.backgroundColor = [UIColor whiteColor];
    self.subtitleLabel.text = @"subtitleLabelsubtitleLabelsubtitleLabel";
    [self addSubview:self.subtitleLabel];
    
    self.calloutButton =[[UIButton alloc] initWithFrame:CGRectMake(kPortraitMargin  , kPortraitMargin + kPortraitHeight+kTitleHeight*3, kTitleWidth, kTitleHeight*2)];
    self.calloutButton.autoresizingMask =
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    self.calloutButton.backgroundColor = [UIColor blackColor];
    self.calloutButton.layer.cornerRadius = 5;
    [self.calloutButton setTitle:@"约约约" forState:UIControlStateNormal];
    [self.calloutButton addTarget:self action:@selector(calloutAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.calloutButton];
    
}

-(void)calloutAction{
    self.calloutButton.backgroundColor = [UIColor redColor];
    //    AboutViewController *controller = [[AboutViewController alloc]init];
    //    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
}


#pragma mark - life cycle


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

#pragma mark - Override

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.subtitleLabel.text = subtitle;
}

- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
}


#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    
    CGContextFillPath(context);
    
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

