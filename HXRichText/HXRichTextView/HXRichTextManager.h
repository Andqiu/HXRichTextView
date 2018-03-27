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
#import "HXTextAttachment.h"
@interface HXRichTextManager : NSObject

@property(nonatomic,strong) RichTextParser *parser;
@property(nonatomic,strong) RichTextEidtor *editor;
@property(nonatomic,weak)UITextView * textView;

/**
 图片最大宽度
 */
@property(nonatomic,assign)CGFloat imageMaxWidth;

/**
 获取渲染字符串

 @param text 富文本
 @return 富文本
 */
-(NSAttributedString *)renderRichText:(NSString *)text;
-(void)startDownloadWebImage;
/**
 插入一个关键字

 @param keyword 关键字
 */
-(void)insertKeyword:(KeyWordModel *)keyword;


/**
 关键字转模板字符串

 @param keyword 关键字
 @return 模板字符串
 */
+(NSString *)keyWordDescription:(KeyWordModel *)keyword;

/**
 通过属性生成关键字（属性需符合关键字属性）

 @param props 属性
 @return 关键字
 */
+(KeyWordModel *)createKeyWordWithProps:(NSDictionary *)props;

/**
 通过关键字生成url_scheme

 @param keyword 关键字
 @return url
 */
+(NSURL *)getSchemeURLWithKeyWord:(KeyWordModel *)keyword;


/**
 通过scheme url 获取keyword的data数据

 @param schemeURL scheme url
 @return data
 */
+(NSDictionary *)getDataFromScheme:(NSURL *)schemeURL;

@end
