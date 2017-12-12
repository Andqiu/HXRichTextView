//
//  ViewController.m
//  HXRichText
//
//  Created by kanon on 2017/11/15.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "ViewController.h"
#import "HXTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ViewController{
  
    HXTextView *_richTextView;

}

static NSString *richString = @"不同领域、不同层次的人，<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>对需求的描述方式都是不同的。仅仅是通过别人对需求的描述实际上很<HX_IMG type='3' src='test.jpg' height='384' width='512'></HX_IMG>难了解对<HX_IMG type='3' src='test.jpg' height='384' width='512'></HX_IMG>方真正的意图比<HX_LINK type='2' pro_id='24' src='http://www.baidu.com'> ➞这个是链接 </HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>如上面加链接的需求，实际提出这个需求的人想要<HX_LINK type='1' src='www.baidu.com'>@我们</HX_LINK>的可能是：<HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK><HX_LINK type='1' src='www.baidu.com' >@我们</HX_LINK>我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每\n24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张\n完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中\n\n\n并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关\n\n键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下我们平时所看到的视频，理论上就是一帧帧的图片连续的播放，形成动画效果。那么完整的保存所有图片，一部电影可能就要上百G的空间。视频编码就是为了压缩这些图片，以节省空间。我先讲一下简单的理论，比如一秒钟的视频通常有24帧，这24张图画大部分区域可能都比较相近，那么我们是不是可以找到一种方法，只保存一张完整图片（我们称为关键帧），不保存其他图片，只保存和这个完整图片的不同（通过某种数学建模表达），这样就会节省很多空间，在播放的时候，通过和关键帧与每一帧的不同逆向恢复成一张完整的图片，这样就得到了24张完整的图片。（这里只是举例，实际应用中并不一定是每24帧图像被设定一个关键帧）。OK，那么所谓编码格式就指的一种压缩视频图像的算法。主流的视频编码格式一览表如下\
";
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    _richTextView = [[HXTextView alloc]initWithFrame:CGRectMake(0, 64, 375, 500)];
    [self.view addSubview:_richTextView];
    [_richTextView setRichText:richString];
    _richTextView.didClickKeywordBlock = ^(KeyWordModel *keyword) {
        NSLog(@"-----> %ld-,%@",keyword.kid,keyword.standardString);
    };
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
