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
@interface RichTextParser()<NSXMLParserDelegate>
@end

@implementation RichTextParser
{
    NSInteger _keyCount;
    
    // 源字符串
    NSString *_originString;
    
    // 回调
    void(^_resultBlock)(NSAttributedString *result);
    
    // xml解析器
    NSMutableArray *_xmlParsers;
  
}
-(instancetype)init{
    self = [super init];
    if (self) {
        _xmlParsers =[NSMutableArray array];
        _datas = [NSMutableArray array];
    }
    return self;
}

-(void)parserString:(NSString *)str block:(void(^)(NSAttributedString *result))block{
    
    _originString = str;
    _resultBlock = block;
    NSString *exp = [NSString stringWithFormat:@"<%@\\s*\\w*>*.*?<\\/%@>|<%@\\s*\\w*>*.*?<\\/%@>",LINK_TAG,LINK_TAG,IMG_TAG,IMG_TAG];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:exp options:0 error:nil];
    NSArray *arr = [expression matchesInString:_originString options:0 range:NSMakeRange(0, _originString.length)];
    _keyCount = arr.count;
    
    // 开始解析
    for (NSInteger i =0 ;i<arr.count;i++) {
        NSTextCheckingResult* result =  arr[i];
        KeyWordModel *keyword = [[KeyWordModel alloc]init];
        //从NSTextCheckingResult类中取出range属性
        NSRange range = result.range;
        keyword.tempRange = range;
        keyword.originString = [_originString substringWithRange:range];
        keyword.kid = i;
        [_datas addObject:keyword];

        
        NSXMLParser *xmlparser = [[NSXMLParser alloc]initWithData:[keyword.originString dataUsingEncoding:NSUTF8StringEncoding]];
        [_xmlParsers addObject:xmlparser];
        xmlparser.delegate = self;
        [xmlparser parse];
    }
    
#ifdef DEBUG
    for (int i =0;i<_datas.count;i++) {
        KeyWordModel * model = _datas[i];
        NSRange rang = model.tempRange;
        NSLog(@"原始：%@",[NSValue valueWithRange:rang]);
    }
#endif
    
    [_xmlParsers removeAllObjects];
    
    // 转换关键字
    [self replaceText];
    
#ifdef DEBUG
    for (int i =0;i<_datas.count;i++) {
        KeyWordModel * model = _datas[i];
        NSRange rang = model.tempRange;
        NSLog(@"替换后：%@",[NSValue valueWithRange:rang]);
    }
#endif

}

//注意* NSXMLParser 解析是同步的，所以可以不用block回调（待修正）

-(void)replaceText{
    // 替换关键字
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_originString attributes:[RichTextStyle getNormalTextAttributed]];
    for (NSInteger i=_datas.count - 1;i>=0;i--) {
        KeyWordModel *model = _datas[i];
        NSRange rang = model.tempRange;
        NSDictionary *obj = model.props;
        if ([obj[PROP_EL_TYPE] integerValue] == 3) {
            // 图片类型
            RichTextEidtor *eidtor = [[RichTextEidtor alloc]init];
            eidtor.imageMaxWidth = _imageMaxWidth;
            [eidtor insertKeyWord:model
                          atRange:rang
                            block:^(NSString *newrichText, NSAttributedString *attributed,NSRange keywordRange) {
                [str replaceCharactersInRange:rang withAttributedString:attributed];
                // 更新此处关键字之后所有的关键字的Range
                for (NSInteger k = i + 1;k<_datas.count; k++) {
                    KeyWordModel *o_model = _datas[k];
                    NSRange o_range = o_model.tempRange;
                    o_range.location = o_range.location - model.originString.length + 2;
                    o_model.tempRange = o_range;
                }
            }];
            
        }else{
            // 链接类型
            
            RichTextEidtor *eidtor = [[RichTextEidtor alloc]init];
            eidtor.imageMaxWidth = _imageMaxWidth;
            [eidtor insertKeyWord:model
                          atRange:rang
                            block:^(NSString *newrichText, NSAttributedString *attributed,NSRange keywordRange) {
                                [str replaceCharactersInRange:rang withAttributedString:attributed];
                                // 更新此处关键字之后所有的关键字的Range
                                for (NSInteger k = i + 1;k<_datas.count; k++) {
                                    KeyWordModel *o_model = _datas[k];
                                    NSRange o_range = o_model.tempRange;
                                    o_range.location = o_range.location - model.originString.length + attributed.length;
                                    o_model.tempRange = o_range;
                                }
                            }];
        }
    }
    if (_resultBlock) {
        _resultBlock(str);
    }
}

-(NSString *)replaceParserString:(NSAttributedString *)str withKeywords:(NSArray *)keywords{
    NSMutableAttributedString *mu_str = [[NSMutableAttributedString alloc]initWithAttributedString:str];
    for (NSInteger i = keywords.count-1;i>=0;i--) {
        KeyWordModel *keyword = keywords[i];
        NSString *el_string = [RichTextParser keyWordDescription:keyword];
        NSAttributedString *el_ats = [[NSAttributedString alloc]initWithString:el_string attributes:nil];
        [mu_str replaceCharactersInRange:keyword.tempRange withAttributedString:el_ats];
    }
    
    return mu_str.string;
}

+(NSString *)keyWordDescription:(KeyWordModel *)keyword{
    
    NSString *propsDescription = @"";
    for (NSString *key in  keyword.props) {
        if (![key isEqual: PROP_IMAGE]) {
            propsDescription = [NSString stringWithFormat:@"%@ %@='%@'",propsDescription,key,keyword.props[key]];
        }
    }
    
    if ([keyword.props[PROP_EL_TYPE] integerValue] == KeywordTypeImage) {
        NSString *str = [NSString stringWithFormat:@"<%@%@></%@>",IMG_TAG,propsDescription,IMG_TAG];
        return str;
    }else{
        NSString *content = keyword.content;
        NSString *str = [NSString stringWithFormat:@"<%@%@>%@</%@>",LINK_TAG,propsDescription,content,LINK_TAG];
        return str;
    }
}


#pragma mark - XMLParser delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    NSInteger index = [_xmlParsers indexOfObject:parser];
    KeyWordModel *model = [_datas objectAtIndex:index];
    model.content = foundCharacters.copy;
    foundCharacters = @"";
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    
    NSInteger index = [_xmlParsers indexOfObject:parser];
    KeyWordModel *model = [_datas objectAtIndex:index];
    model.props = attributeDict;
}

static NSString *foundCharacters = @"";
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    foundCharacters = [NSString stringWithFormat:@"%@%@",foundCharacters,string];
}

@end
