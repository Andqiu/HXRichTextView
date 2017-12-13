//
//  RichToolView.m
//  HXRichText
//
//  Created by kanon on 2017/11/24.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "RichToolView.h"

@implementation RichToolView{
    
    __weak IBOutlet UIButton *_userBtn;
    __weak IBOutlet UIButton *_productBtn;
    __weak IBOutlet UIButton *_imgBtn;
}
- (IBAction)addImgClick:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(1);
    }
}
- (IBAction)addProClick:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(2);
    }
}
- (IBAction)addUserClick:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(0);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
