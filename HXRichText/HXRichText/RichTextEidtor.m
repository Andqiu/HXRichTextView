//
//  RichEidtor.m
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "RichTextEidtor.h"
#import "RichTextStyle.h"

@implementation RichTextEidtor

-(NSString *)getRichText{
    
    return @"";
}

-(NSString *)insertImageNamed:(NSString *)imageNamed size:(CGSize)size atRange:(NSRange)range richText:(NSString *)richText{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString *imgStr = HXRICH_IMG_TEXT(imageNamed, width, height);
    NSString *str = [richText stringByReplacingCharactersInRange:range withString:imgStr];
    return str;
}

-(NSAttributedString *)getImage:(NSString *)imageNamed
                          width:(CGFloat)width
                         height:(CGFloat)height
                       maxWidth:(CGFloat)maxWidth{
    UIImage *image = [UIImage imageNamed:imageNamed];
    CGSize size = CGSizeMake(width, height);
    CGFloat factor = size.width/size.height;
    CGSize newsize = CGSizeZero;
    if (size.width > maxWidth) {
        newsize.width = maxWidth - 20;
        newsize.height = newsize.width/factor;
    }
    UIGraphicsBeginImageContextWithOptions(newsize, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *newimage = returnImage;
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
    attachment.image = newimage;
    attachment.bounds = CGRectMake(0, 0, newimage.size.width, newimage.size.height);
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    return textAttachmentString;
}

-(void)insertImageNamed:(NSString *)imageNamed
                   size:(CGSize)size
               maxWidth:(CGFloat)maxWidth
                atRange:(NSRange)range
               richText:(NSString *)richText
                  block:(void(^)(NSString *newrichText,NSAttributedString *imgAttributed))block{
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString *imgKey = HXRICH_IMG_TEXT(imageNamed, width, height);
    NSString *str = [richText stringByReplacingCharactersInRange:range withString:imgKey];
    NSAttributedString *attributed = [self getImage:imageNamed width:width height:height maxWidth:maxWidth];
    if (block) {
        block(str,attributed);
    }
}

-(void)insetLinkWithContent:(NSString *)content
                       href:(NSString *)href
                    atRange:(NSRange)range
                   richText:(NSString *)richText
                      block:(void(^)(NSString *newrichText,NSAttributedString *linkAttributed))block{
    NSString *linkKey = HXRICH_LINK_TEXT(href, content);
    NSString *str = [richText stringByReplacingCharactersInRange:range withString:linkKey];
    NSAttributedString *attributed = [self getLinkTextAttributedStringWithString:content];
    if (block) {
        block(str,attributed);
    }
}

-(NSAttributedString *)getLinkTextAttributedStringWithString:(NSString *)str{
    
    NSAttributedString *attributes = [[NSAttributedString alloc]initWithString:str attributes:[RichTextStyle getLinkTextAttributed]];
    return attributes;
}

-(void)insertKeyWord:(KeyWordModel *)keyWord
             atRange:(NSRange)range
            richText:(NSString *)richText
               block:(void(^)(NSString *newrichText,NSAttributedString *attributed))block{
    NSInteger type = [keyWord.props[@"type"] integerValue];
    NSString *keywordDes =[self keyWordDescription:keyWord];
    if (type == 3) {
        NSString *src = keyWord.props[@"src"];
        CGFloat width = [keyWord.props[@"width"] floatValue];
        CGFloat height = [keyWord.props[@"height"] floatValue];
        NSString *str = [richText stringByReplacingCharactersInRange:range withString:keywordDes];
        NSAttributedString *attributed = [self getImage:src width:width height:height maxWidth:_imageMaxWidth];

        if (block) {
            block(str,attributed);
        }
        keyWord.originString = keywordDes;
        NSRange range1 = NSMakeRange(range.location, 1);
        keyWord.tempRange = range1;
    }else{
        NSString *content = keyWord.content;
        // 1，在原始字符串位置插入相应关键字，生成新的富文本
        NSString *str = [richText stringByReplacingCharactersInRange:range withString:keywordDes];
        // 2，生成渲染的关键字富文本
        NSAttributedString *attributed = [self getLinkTextAttributedStringWithString:content];
 
        if (block) {
            block(str,attributed);
        }
        keyWord.originString = keywordDes;
        NSRange range1 = NSMakeRange(range.location, attributed.length);
        keyWord.tempRange = range1;
    }
}

-(NSString *)keyWordDescription:(KeyWordModel *)keyword{
   
    if ([keyword.props[@"type"] integerValue] == 3) {
        NSString *src = keyword.props[@"src"];
        CGFloat width = [keyword.props[@"width"] integerValue];
        CGFloat height = [keyword.props[@"height"] integerValue];
        return HXRICH_IMG_TEXT(src, width,  height);
    }else{
        NSString *href = keyword.props[@"href"];
        NSString *content = keyword.content;
        return HXRICH_LINK_TEXT(href, content);
    }
}

@end
