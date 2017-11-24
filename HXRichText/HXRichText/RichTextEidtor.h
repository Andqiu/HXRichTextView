//
//  RichEidtor.h
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyWordModel.h"

@interface RichTextEidtor : NSObject

/**
 获取textview编排的富文本字符串
 
 @return 富文本
 */
-(NSString *)getRichText;

@property(nonatomic,assign)CGFloat imageMaxWidth;

/**
 插入关键字对象

 @param keyWord 关键字对象
 @param range 位置
 @param richText 富文本
 @param block 回调
 */
-(void)insertKeyWord:(KeyWordModel *)keyWord
             atRange:(NSRange)range
            richText:(NSString *)richText
               block:(void(^)(NSString *newrichText,NSAttributedString *attributed))block;
@end
