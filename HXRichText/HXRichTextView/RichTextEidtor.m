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
#import "HXRichTextManager.h"

@implementation RichTextEidtor

-(void)insertKeyWord:(KeyWordModel *)keyWord
               block:(void(^)(NSString *newrichText,NSAttributedString *keywordAttributed,NSRange keywordRange))block{
    NSInteger type = keyWord.el_type;
    NSString *keywordDes =[HXRichTextManager keyWordDescription:keyWord];
    
    if (type == KeywordTypeImage) {
        keyWord.standardString = keywordDes;

        NSAttributedString *attributed = [self getImageAttributedStringWithKeyword:keyWord];
        if (block) {
            block(nil,attributed,NSMakeRange(0, 0));
        }

    }else{
        NSString *content = keyWord.content;
        // 1，在原始字符串位置插入相应关键字，生成新的富文本
        keyWord.standardString = keywordDes;
        
        // 2，生成渲染的关键字富文本
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[RichTextStyle getLinkTextAttributed]];
        
        NSURL *url = [HXRichTextManager getSchemeURLWithKeyWord:keyWord];
        [attributes setObject:url forKey:NSLinkAttributeName];
        
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:content attributes:attributes];
        NSAttributedString *spaceString = [[NSAttributedString alloc]initWithString:Link_c attributes:[RichTextStyle getNormalTextAttributed]];
        [attributed appendAttributedString:spaceString];
        if (block) {
            block(nil,attributed,NSMakeRange(0, 0));
        }
        
    }
}

-(NSAttributedString *)getImageAttributedStringWithKeyword:(ImageKeyWord *)keyWord{
    
    NSString *src = keyWord.url;
    UIImage *image = keyWord.image?keyWord.image:[UIImage imageNamed:@"test"];
    CGFloat width = keyWord.width;
    CGFloat height = keyWord.height;
    NSAttributedString *imgattributed = [self getImage:image src:src width:width height:height maxWidth:keyWord.maxWidth];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithAttributedString:imgattributed];
    NSURL *url = [HXRichTextManager getSchemeURLWithKeyWord:keyWord];
    [attributed addAttribute:NSLinkAttributeName value:url range:NSMakeRange(0, attributed.length)];
    NSAttributedString *spaceString = [[NSAttributedString alloc]initWithString:Img_c attributes:[RichTextStyle getNormalTextAttributed]];
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
    
    HXTextAttachment *attachment = [[HXTextAttachment alloc]initWithData:nil ofType:nil];
    attachment.image = newimage;
    attachment.url = src;
    attachment.maxWidth = maxWidth;
    attachment.bounds = CGRectMake(0, 0, newimage.size.width, newimage.size.height);
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    return textAttachmentString;
}
@end
