//
//  ViewController.m
//  date-fitness
//
//  Created by Shen Guanpu on 15/6/14.
//  Copyright (c) 2015年 Shen Guanpu. All rights reserved.
//

#import "LoginViewController.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <JSONKit/JSONKit.h>
#import "TabBarViewController.h"

@interface LoginViewController (){
    NSTimer *timer;
    int count;
    int retry;
}
@property(weak,nonatomic) IBOutlet UIProgressView *myProgressView;

@property (weak, nonatomic) IBOutlet UIButton *verifyButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)loginAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://yuejian001.sinaapp.com/PassportRest/get_cookie/254d40f3da1cc281ca2ff7a653b9199a"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
//    @try {
        if (error) {
            NSLog(@"[error] http request");
        }else{
            NSString *response = [request responseString];
            NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
            JSONDecoder* decoder = [[JSONDecoder alloc] init];
            NSDictionary *simpleDictionary = [decoder objectWithData:jsonData];
            NSString *err = [[simpleDictionary objectForKey:@"errno"] stringValue];
            NSLog(@"Person: %@",err);
            
            if ([err isEqualToString: @"0"]) {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"登录成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alertview show];
                
               [self performSegueWithIdentifier:@"tabbar" sender:self];
            }else{
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"标题" message:@"登录失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alertview show];
            }
        }

//    }
//    @catch (NSException *exception) {
//         NSLog(@"Exception=%@\nStack Trace:%@", exception, [exception callStackSymbols]);
//    }
    
        NSLog(@"[Completion] http request");
    return;
}

- (void)getWithUrl:(NSString *)url withCompletion:(void (^)(id responseObject))completion failed:(void (^)(NSError *error))failed
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    __weak ASIHTTPRequest *weakrequest = request;
    [request setCompletionBlock:^{
        NSString *responseString = [weakrequest responseString];
        completion(responseString);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [weakrequest error];
        failed(error);
    }];
    [request start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)verifyTimer{
    int inteval = 10; //测试用10
    count = count+1;
    [self.verifyButton setTitle:[NSString stringWithFormat:@"%i 秒", inteval - count] forState:UIControlStateNormal];
    if(count == inteval){
        [timer invalidate];
        count = 0;
        [self.verifyButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.verifyButton setEnabled:YES];
    }
}
/*
    发送验证码
*/
 - (IBAction)verifyAction:(id)sender {
     retry++;
     if (retry>3) {
             [self.verifyButton setTitle:@"明天再来吧！" forState:UIControlStateNormal];
         return;
     }
     [self.verifyButton setEnabled:NO];
     timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(verifyTimer) userInfo:nil repeats:YES];
}


@end
