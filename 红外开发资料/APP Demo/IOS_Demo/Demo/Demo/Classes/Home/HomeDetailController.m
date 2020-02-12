//
//  HomeDetailController.m
//  Demo
//
//  Created by 李静莹 on 2018/12/21.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeDetailController.h"
#import "HomeMatchingController.h"

@interface HomeDetailController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation HomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设备详情";
    self.textView.delegate = self;
}
- (IBAction)BtnClick:(UIButton *)sender {
    NSString *url = [NSString stringWithFormat:@"http://www.huilink.com.cn/dk2018/getrid.asp?device_id=%@&mac=afc1d387b4ab661d&vcode=%@",self.dict[@"id"],self.textView.text];
    NSLog(@"%@",url);
    HomeMatchingController *matching = [[HomeMatchingController alloc]init];
    matching.hidesBottomBarWhenPushed = YES;
    matching.url = url;
    matching.dict = self.dict;
    [self.navigationController pushViewController:matching animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
