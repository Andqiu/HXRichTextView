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

static NSString *richString = @"不同领域、不同层次的人，<hxlink type='1' src=\"www.baidu.com\" >@我们</hxlink>对需求的描述方式都是不同的。仅仅是通过别人对需求的<hximg type='3' src='分享_u589.png' height='277' width='409'></hximg>描述实际上很<hximg type='3' src='分享_u589.png' height='277' width='409'></hximg>难了解对<hximg type='3' src='分享_u589.png' height='277' width='409'></hximg>方真正的意图比<hxlink type='2' pro_id=\"24\" src=\"http://www.baidu.com\"> ➞这个是产品 </hxlink>如上面加链接的需求，实际提出这个需求的人想要<hxlink type='1' src=\"www.baidu.com\" >@我们</hxlink>的可能是：<hxlink type='1' src=\"www.baidu.com\" >@我们</hxlink><hxlink type='1' src=\"www.baidu.com\" >@我们</hxlink> <hximg type='3' src='分享_u589.png' height='277' width='409'></hximg>";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    _richTextView = [[HXTextView alloc]initWithFrame:CGRectMake(0, 64, 375, 500)];
    [self.view addSubview:_richTextView];
    [_richTextView setRichText:richString];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 600, 70, 50);
    [btn setTitle:@"添加图片" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(80, 600, 70, 50);
    [btn setTitle:@"添加用户/链接" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(addLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(160, 600, 70, 50);
    [btn setTitle:@"重排" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(240, 600, 70, 50);
    [btn setTitle:@"导出" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(export) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)addImage{
    [_richTextView insertImage:[UIImage imageNamed:@"分享_u589.png"]];
}
-(void)addLink{
    [_richTextView insertUser:@"厚行投资"];
}
-(void)reset{
    _textView.text = @"";
    _textView.attributedText = nil;
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
