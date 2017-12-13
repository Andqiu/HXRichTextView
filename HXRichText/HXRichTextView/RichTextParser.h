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

/**
 解析字符串

 @param str 字符串
 @param block 回调
 */
-(void)parserString:(NSString *)str block:(void(^)(NSAttributedString *result))block;
@end
