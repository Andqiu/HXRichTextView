//
//  RichEidtor.m
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "RichTextEidtor.h"
#import "RichTextStyle.h"
#import "RichTextParser.h"

@implementation RichTextEidtor

-(void)insertKeyWord:(KeyWordModel *)keyWord
             atRange:(NSRange)range
               block:(void(^)(NSString *newrichText,NSAttributedString *keywordAttributed,NSRange keywordRange))block{
    NSInteger type = [keyWord.props[PROP_EL_TYPE] integerValue];
    NSString *keywordDes =[RichTextParser keyWordDescription:keyWord];
    if (type == KeywordTypeImage) {
//        NSString *str = [richText stringByReplacingCharactersInRange:range withString:keywordDes];

        keyWord.standardString = keywordDes;
        NSRange range1 = NSMakeRange(range.location, 2);
        keyWord.tempRange = range1;
        
        NSAttributedString *attributed = [self getImageAttributedStringWithKeyword:keyWord];
        
        if (block) {
            block(nil,attributed,range1);
        }

    }else{
        NSString *content = keyWord.content;
        // 1，在原始字符串位置插入相应关键字，生成新的富文本
//        NSString *str = [richText stringByReplacingCharactersInRange:range withString:keywordDes];
        keyWord.standardString = keywordDes;
        NSRange range1 = NSMakeRange(range.location, content.length + 1);
        keyWord.tempRange = range1;
        
        // 2，生成渲染的关键字富文本
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[RichTextStyle getLinkTextAttributed]];
        
        NSURL *link = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%ld",RICH_SCHEME,keyWord.kid]];
        [attributes setObject:link forKey:NSLinkAttributeName];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:content attributes:attributes];
        NSAttributedString *spaceString = [[NSAttributedString alloc]initWithString:@" " attributes:[RichTextStyle getNormalTextAttributed]];
//        [attributed insertAttributedString:spaceString atIndex:0];
        [attributed appendAttributedString:spaceString];
        if (block) {
            block(nil,attributed,range1);
        }
        
    }
}

-(NSAttributedString *)getImageAttributedStringWithKeyword:(KeyWordModel *)keyWord{
    
    NSString *src = keyWord.props[PROP_SRC];
    UIImage *image = keyWord.props[PROP_IMAGE];
    CGFloat width = [keyWord.props[PROP_WIDTH] floatValue];
    CGFloat height = [keyWord.props[PROP_HEIGHT] floatValue];
    NSAttributedString *imgattributed = [self getImage:image src:src width:width height:height maxWidth:_imageMaxWidth];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithAttributedString:imgattributed];
    [attributed addAttribute:NSLinkAttributeName value:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%ld",RICH_SCHEME,keyWord.kid]] range:NSMakeRange(0, attributed.length)];
    NSAttributedString *spaceString = [[NSAttributedString alloc]initWithString:@" " attributes:[RichTextStyle getNormalTextAttributed]];
    [attributed appendAttributedString:spaceString];
    return attributed;
}

-(NSAttributedString *)getImage:(UIImage *)image
                            src:(NSString *)src
                          width:(CGFloat)width
                         height:(CGFloat)height
                       maxWidth:(CGFloat)maxWidth{
    if (image == nil) {
        
        CGRect rect = CGRectMake(0, 0, 1, 1);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
        
        CGContextFillRect(context, rect);
        UIImage *imager = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = imager;
    }
    CGSize size = CGSizeMake(width, height);
    CGFloat factor = size.width/size.height;
    CGSize newsize = size;
    if (size.width > maxWidth) {
        newsize.width = maxWidth;
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
@end
