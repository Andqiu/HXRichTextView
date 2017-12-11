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

-(void)insertKeyWord:(KeyWordModel *)keyWord
             atRange:(NSRange)range
            richText:(NSString *)richText
               block:(void(^)(NSString *newrichText,NSAttributedString *keywordAttributed,NSRange keywordRange))block{
    NSInteger type = [keyWord.props[@"type"] integerValue];
    NSString *keywordDes =[self keyWordDescription:keyWord];
    if (type == KeywordTypeImage) {
        NSString *src = keyWord.props[@"src"];
        CGFloat width = [keyWord.props[@"width"] floatValue];
        CGFloat height = [keyWord.props[@"height"] floatValue];
        NSString *str = [richText stringByReplacingCharactersInRange:range withString:keywordDes];
        NSAttributedString *attributed = [self getImage:src width:width height:height maxWidth:_imageMaxWidth];

        keyWord.standardString = keywordDes;
        NSRange range1 = NSMakeRange(range.location, 1);
        keyWord.tempRange = range1;
        
        if (block) {
            block(str,attributed,range1);
        }

    }else{
        NSString *content = keyWord.content;
        // 1，在原始字符串位置插入相应关键字，生成新的富文本
        NSString *str = [richText stringByReplacingCharactersInRange:range withString:keywordDes];
        // 2，生成渲染的关键字富文本
        NSAttributedString *attributed = [[NSAttributedString alloc]initWithString:content attributes:[RichTextStyle getLinkTextAttributed]];
        keyWord.standardString = keywordDes;
        NSRange range1 = NSMakeRange(range.location, attributed.length);
        keyWord.tempRange = range1;
        if (block) {
            block(str,attributed,range1);
        }

    }
}

-(NSString *)keyWordDescription:(KeyWordModel *)keyword{
   
    NSString *propsDescription = @"";
    for (NSString *key in  keyword.props) {
        propsDescription = [NSString stringWithFormat:@"%@ %@='%@'",propsDescription,key,keyword.props[key]];
    }
    
    if ([keyword.props[@"type"] integerValue] == KeywordTypeImage) {
        NSString *str = [NSString stringWithFormat:@"<%@%@></%@>",IMG_TAG,propsDescription,IMG_TAG];
        return str;
    }else{
        NSString *content = keyword.content;
        NSString *str = [NSString stringWithFormat:@"<%@%@>%@</%@>",LINK_TAG,propsDescription,content,LINK_TAG];
        return str;
    }
}

@end
