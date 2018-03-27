//
//  RichTextParser.h
//  HXRichText
//
//  Created by kanon on 2017/11/17.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageKeyWord.h"
#import "LinkKeyWord.h"

/**
 解析原始文本，不负责编辑部分解析
 */
@interface RichTextParser : NSObject

/**
 关键字数组
 */
@property(nonatomic,strong,readonly)NSMutableArray <KeyWordModel *>*datas;


/**
 获取图片附件

 @return 图片附件
 */
//-(NSArray <NSTextAttachment *>*)getTextAttachments;

/**
 解析字符串

 @param str 字符串
 @param block 回调
 */
-(void)parserString:(NSString *)str block:(void(^)(NSAttributedString *result))block;


/**
 替换富文本中的关键字

 @param str 渲染的富文本
 @param keywords 关键字数组
 @return 关键字文本
 */
-(NSString *)replaceParserString:(NSAttributedString *)str withKeywords:(NSArray *)keywords;

@end
