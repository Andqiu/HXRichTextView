//
//  HXTextView.h
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXRichTextManager.h"

@interface HXTextView : UITextView

@property(nonatomic,strong) HXRichTextManager *textManger;
@property (nonatomic, copy) void(^didClickKeywordBlock)(KeyWordModel *keyword);

/**
 键盘辅助工具栏
 */
@property (nonatomic, strong) UIView *keyboradToolView;


/**
 设置富文本

 @param richText 富文本字符串 并渲染到textview
 */
-(void)setRichText:(NSString *)richText;

@end
