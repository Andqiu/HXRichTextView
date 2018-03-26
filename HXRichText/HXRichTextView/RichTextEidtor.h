//
//  RichEidtor.h
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageKeyWord.h"
#import "LinkKeyWord.h"

@interface RichTextEidtor : NSObject


/**
 插入关键字对象

 @param keyWord 关键字对象
 @param block 回调
 */
-(void)insertKeyWord:(KeyWordModel *)keyWord
               block:(void(^)(NSString *newrichText,NSAttributedString *keywordAttributed,NSRange keywordRange))block;

-(NSAttributedString *)getImageAttributedStringWithKeyword:(KeyWordModel *)keyWord;
@end
