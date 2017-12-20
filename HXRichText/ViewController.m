//
//  ViewController.m
//  HXRichText
//
//  Created by kanon on 2017/11/15.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "ViewController.h"
#import "HXTextView.h"
#import "RichToolView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController{
  
    HXTextView *_richTextView;

}

static NSString *richString = @"不同领域、不同层次的人，<HX_LINK el_type='1' src='www.baidu.com'>@我们</HX_LINK>对需求的描述方式都是不同的。仅仅是通过别人对需求的描述实际上很\
";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    RichToolView *v = [[NSBundle mainBundle] loadNibNamed:@"RichToolView" owner:self options:nil].firstObject;
    [v setClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:{
                KeyWordModel *keyword = [[KeyWordModel alloc]init];
                keyword.kid = _richTextView.textManger.keyWords.count;
                keyword.content = [NSString stringWithFormat:@"@我是你大爷"];
                keyword.props = @{PROP_UID:@(123),PROP_EL_TYPE:@(KeywordTypeUser)};
                [_richTextView.textManger insertKeyword:keyword];

            }
                break;
            case 1:{
                KeyWordModel *keyword = [[KeyWordModel alloc]init];
                keyword.props = @{PROP_IMAGE:[UIImage imageNamed:@"test"],PROP_EL_TYPE:@(KeywordTypeImage),PROP_WIDTH:@(512),PROP_HEIGHT:@(200)};
                keyword.kid = _richTextView.textManger.keyWords.count;
                [_richTextView.textManger insertKeyword:keyword];

            }
                break;
            case 2:
                break;
            case 3:
                [self export];
                break;
                
            default:
                break;
        }
    }];
    
    _richTextView = [[HXTextView alloc]initWithFrame:CGRectMake(0, 64, 375, 500)];
    _richTextView.keyboradToolView = v;
    [self.view addSubview:_richTextView];
    [_richTextView setRichText:richString];
    _richTextView.didClickKeywordBlock = ^(KeyWordModel *keyword) {
        NSLog(@"-----> %ld-,%@",keyword.kid,keyword.standardString);
    };
}


-(void)export{
    
    // 将关键字位置排序
    [_richTextView.textManger.keyWords sortUsingComparator:^NSComparisonResult(KeyWordModel * obj1, KeyWordModel* obj2) {
        if (obj1.tempRange.location < obj2.tempRange.location) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    // 若关键字内有本地图片要上传，请先上传后将地址替换
    NSString *richText = [_richTextView.textManger.parser
                          replaceParserString:_richTextView.attributedText
                          withKeywords:_richTextView.textManger.keyWords];
    
    NSLog(@"%@",richText);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
