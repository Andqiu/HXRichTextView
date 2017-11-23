//
//  HXTextView.h
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTextView : UITextView


-(NSString *)getCurrentRichText;

/**
 设置富文本

 @param richText 富文本字符串 并渲染到textview
 */
-(void)setRichText:(NSString *)richText;

-(void)insertImage:(NSString *)imageNamed;
-(void)insertUser:(NSString *)name;
@end
