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
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+GIF.h>


@interface ViewController ()<NSTextStorageDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController{
  
    HXTextView *_richTextView;

}
///< el_type='3' src='test' width='375' height='50'></HX_IMG>
//
static NSString *richString = @"不同领域<HX_LINK el_type='0' >@我们</HX_LINK>\
<HX_IMG el_type='3' width='512' height='200' maxWidth='365' url='https://upload-images.jianshu.io/upload_images/272307-8c345ded94da76c9..JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/700'></HX_IMG>\
<HX_IMG el_type='3' width='512' height='200' maxWidth='365' url='sfas'></HX_IMG>\
<HX_IMG el_type='3' width='512' height='200' maxWidth='365' url='sfas'></HX_IMG>\
<HX_IMG el_type='3' width='512' height='200' maxWidth='365' url='sfas'></HX_IMG>\
<HX_IMG el_type='3' width='512' height='200' maxWidth='365' url='https://upload-images.jianshu.io/upload_images/272307-8c345ded94da76c9..JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/700'></HX_IMG>";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    RichToolView *v = [[NSBundle mainBundle] loadNibNamed:@"RichToolView" owner:self options:nil].firstObject;
    [v setClickBlock:^(NSInteger index) {
        switch (index) {
            case 0:{
                LinkKeyWord *keyword = [[LinkKeyWord alloc]init];
                keyword.content = [NSString stringWithFormat:@"@用户小明"];
                keyword.el_type = KeywordTypeLink;
                keyword.data = @{
                                 @"abc":@(1),
                                 @"ced":@"123",
                                 @"bo":@(false),
                                 };
                [_richTextView.textManger insertKeyword:keyword];

            }
                break;
            case 1:{
                ImageKeyWord *keyword = [[ImageKeyWord alloc]init];
                keyword.el_type = KeywordTypeImage;
                keyword.url = @"www.baidu.com";
                keyword.image = [UIImage imageNamed:@"test"];
                keyword.width = 512;
                keyword.height = 200;
                keyword.maxWidth = _richTextView.frame.size.width - 10;

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
    
    _richTextView = [[HXTextView alloc]initWithFrame:CGRectMake(0, 64, 375, 400)];
    _richTextView.keyboradToolView = v;
    [self.view addSubview:_richTextView];
    [_richTextView setRichText:richString];
    _richTextView.didClickKeywordBlock = ^(KeyWordModel *keyword) {
    };

}

-(void)export{
    
//    // 将关键字位置排序
//    [_richTextView.textManger.keyWords sortUsingComparator:^NSComparisonResult(KeyWordModel * obj1, KeyWordModel* obj2) {
//        if (obj1.tempRange.location < obj2.tempRange.location) {
//            return NSOrderedAscending;
//        }else{
//            return NSOrderedDescending;
//        }
//    }];
//    // 若关键字内有本地图片要上传，请先上传后将地址替换
//    NSString *richText = [_richTextView.textManger.parser
//                          replaceParserString:_richTextView.attributedText
//                          withKeywords:_richTextView.textManger.keyWords];
//
//
//    NSLog(@"%@",_richTextView.textStorage);
    [_richTextView exported];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
