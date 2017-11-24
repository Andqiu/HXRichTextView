//
//  ViewController.m
//  HXRichText
//
//  Created by kanon on 2017/11/15.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "ViewController.h"
#import "RichTextParser.h"
#import "HXTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController{
  
    HXTextView *_richTextView;

}

static NSString *richString = @"不同领域、不同层次的人，<HX_LINK type='1' src=\"www.baidu.com\" >@我们</HX_LINK>对需求的描述方式都是不同的。仅仅是通过别人对需求的描述实际上很<HX_IMG type='3' src='test.jpg' height='384' width='512'></HX_IMG>难了解对<HX_IMG type='3' src='test.jpg' height='384' width='512'></HX_IMG>方真正的意图比<HX_LINK type='2' pro_id=\"24\" src=\"http://www.baidu.com\"> ➞这个是链接 </HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src=\"www.baidu.com\" >@我们</HX_LINK>的可能是：<HX_LINK type='1' src=\"www.baidu.com\" >@我们</HX_LINK><HX_LINK type='1' src=\"www.baidu.com\" >@我们</HX_LINK>";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    _richTextView = [[HXTextView alloc]initWithFrame:CGRectMake(0, 64, 375, 500)];
    [self.view addSubview:_richTextView];
    [_richTextView setRichText:richString];
}


-(void)export{
    NSString *richText = [_richTextView getCurrentRichText];
    NSLog(@"%@",richText);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
