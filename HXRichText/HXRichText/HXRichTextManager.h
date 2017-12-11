//
//  HXRichTextManager.h
//  HXRichText
//
//  Created by kanon on 2017/11/15.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextParser.h"
#import "RichTextEidtor.h"
@interface HXRichTextManager : NSObject

@property(nonatomic,strong) RichTextParser *parser;
@property(nonatomic,strong) RichTextEidtor *editor;
@property(nonatomic,weak)UITextView * textView;
/**
 图片最大宽度
 */
@property(nonatomic,assign)CGFloat imageMaxWidth;

-(NSString *)getRichText;

/**
 获取渲染字符串

 @param text 富文本
 @return 富文本
 */
-(NSAttributedString *)renderRichText:(NSString *)text;

/**
 插入一个关键字

 @param keyword 关键字
 */
-(void)insertKeyword:(KeyWordModel *)keyword;

-(void)setReplaceString:(NSString *)text replaceRange:(NSRange)range;
-(void)update;
@end
