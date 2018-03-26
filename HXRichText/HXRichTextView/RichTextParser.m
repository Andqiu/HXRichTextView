//
//  RichTextParser.m
//  HXRichText
//
//  Created by kanon on 2017/11/17.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "RichTextParser.h"
#import "RichTextEidtor.h"
#import "RichTextStyle.h"
#import "HXRichTextManager.h"

@interface RichTextParser()<NSXMLParserDelegate>
@end

@implementation RichTextParser
{
    
    // 源字符串
    NSString *_originString;
    
    // 回调
    void(^_resultBlock)(NSAttributedString *result);
    
    // xml解析器
    NSMutableArray *_xmlParsers;
    
    // 记录初始解析时关键字的位置
    NSMutableArray *_keywordRanges;
    
    // 图片附件
    NSMutableArray <HXTextAttachment *>* _textAttachments;
  
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _xmlParsers =[NSMutableArray array];
        _datas = [NSMutableArray array];
        _textAttachments = [NSMutableArray array];
        
    }
    return self;
}

-(void)parserString:(NSString *)str block:(void(^)(NSAttributedString *result))block{
    
    _originString = str;
    _resultBlock = block;
    NSString *exp = [NSString stringWithFormat:@"<%@\\s*\\w*>*.*?<\\/%@>|<%@\\s*\\w*>*.*?<\\/%@>",LINK_TAG,LINK_TAG,IMG_TAG,IMG_TAG];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:exp options:0 error:nil];
    NSArray *arr = [expression matchesInString:_originString options:0 range:NSMakeRange(0, _originString.length)];
    
    _keywordRanges = [NSMutableArray array];
    // 开始解析
    for (NSInteger i =0 ;i<arr.count;i++) {
        NSTextCheckingResult* result =  arr[i];
        //从NSTextCheckingResult类中取出range属性
        
        NSRange range = result.range;
        NSString * originString = [_originString substringWithRange:range];
        [_keywordRanges addObject:[NSValue valueWithRange:range]];
        
        NSXMLParser *xmlparser = [[NSXMLParser alloc]initWithData:[originString dataUsingEncoding:NSUTF8StringEncoding]];
        [_xmlParsers addObject:xmlparser];
        xmlparser.delegate = self;
        [xmlparser parse];
    
    }
    
    [_xmlParsers removeAllObjects];
    
    // 转换关键字
    [self replaceText];

}

//注意* NSXMLParser 解析是同步的，所以可以不用block回调（待修正）

-(void)replaceText{
    // 替换关键字
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_originString attributes:[RichTextStyle getNormalTextAttributed]];
    for (NSInteger i=_datas.count - 1;i>=0;i--) {
        KeyWordModel *model = _datas[i];
        NSRange range = [_keywordRanges[i] rangeValue];
        RichTextEidtor *eidtor = [[RichTextEidtor alloc]init];
        [eidtor insertKeyWord:model
                        block:^(NSString *newrichText, NSAttributedString *attributed,NSRange keywordRange) {
                            [str replaceCharactersInRange:range withAttributedString:attributed];
                            if (model.el_type == KeywordTypeImage) {
                                NSRange r_range = NSMakeRange(0, attributed.length);
                                HXTextAttachment *tam = [attributed attribute:NSAttachmentAttributeName atIndex:0 effectiveRange:&r_range];
                                [_textAttachments addObject:tam];
                            }
                        }];
    }
    if (_resultBlock) {
        _resultBlock(str);
    }
}

-(NSArray <NSTextAttachment *>*)getTextAttachments{
    return _textAttachments;
}

-(NSString *)replaceParserString:(NSAttributedString *)str withKeywords:(NSArray *)keywords{
    NSMutableAttributedString *mu_str = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    for (NSInteger i = keywords.count-1;i>=0;i--) {
        KeyWordModel *keyword = keywords[i];
        NSString *el_string = [HXRichTextManager keyWordDescription:keyword];
        NSAttributedString *el_ats = [[NSAttributedString alloc]initWithString:el_string attributes:nil];
//        [mu_str replaceCharactersInRange:keyword.tempRange withAttributedString:el_ats];
    }
    
    return mu_str.string;
}

#pragma mark - XMLParser delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
//    NSInteger index = [_xmlParsers indexOfObject:parser];
//    KeyWordModel *model = [_datas objectAtIndex:index];
//    model.props = attributeDict;
    KeyWordModel *model = [HXRichTextManager createKeyWordWithProps:attributeDict];
    [_datas addObject:model];
}

static NSString *foundCharacters = @"";
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    foundCharacters = [NSString stringWithFormat:@"%@%@",foundCharacters,string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    NSInteger index = [_xmlParsers indexOfObject:parser];
    KeyWordModel *model = [_datas objectAtIndex:index];
    model.content = foundCharacters.copy;
    foundCharacters = @"";
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"解析失败 %@",parseError);
}
@end
