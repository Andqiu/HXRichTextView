//
//  RichTextStyle.m
//  HXRichText
//
//  Created by kanon on 2017/11/23.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "RichTextStyle.h"

@implementation RichTextStyle
+(NSDictionary *)getNormalTextAttributed{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSKernAttributeName:@(0.5),
                                 NSForegroundColorAttributeName:[UIColor blackColor]
                                 };
    
    return attributes;
}

+(NSDictionary *)getLinkTextAttributed{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSKernAttributeName:@(0.5),
                                 NSForegroundColorAttributeName:[UIColor blueColor]
                                 };
    
    return attributes;
}

@end
