//
//  RichTextParser.h
//  HXRichText
//
//  Created by kanon on 2017/11/17.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyWordModel.h"

@interface RichTextParser : NSObject

/**
 图片最大宽度
 */
@property(nonatomic,assign)CGFloat imageMaxWidth;

/**
 关键字数组
 */
@property(nonatomic,strong,readonly)NSMutableArray <KeyWordModel *>*datas;

+(NSString *)keyWordDescription:(KeyWordModel *)keyword;

/**
 解析字符串

 @param str 字符串
 @param block 回调
 */
-(void)parserString:(NSString *)str block:(void(^)(NSAttributedString *result))block;


/**
 替换富文本中的关键字

 @param str 渲染的富文本
 @param imageKeywords 关键字数组
 @return 关键字文本
 */
-(NSString *)replaceParserString:(NSAttributedString *)str withKeywords:(NSArray *)keywords;

@end
