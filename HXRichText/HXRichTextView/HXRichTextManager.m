//
//  HXRichTextManager.m
//  HXRichText
//
//  Created by kanon on 2017/11/15.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "HXRichTextManager.h"
#import "RichTextStyle.h"
#import "SDWebImageDownloader.h"
@interface HXRichTextManager()<NSTextStorageDelegate>
@end
@implementation HXRichTextManager{
    
    //    无效的关键字（被编辑过）
    NSMutableArray *_invalidKeywords;
    
    // 网络图片
    NSMutableArray *_webImageKeywords;
    
    //    渲染的富文本，关键字已经被替换
    NSAttributedString *_latestString;
    
    NSString *_replaceString;
    NSRange _replaceRange;
}
+(instancetype)share{
    static HXRichTextManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HXRichTextManager alloc]init];
    
    });
    return instance;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _keyWords = [NSMutableArray array];
        _invalidKeywords = [NSMutableArray array];
        _webImageKeywords = [NSMutableArray array];
    }
    return self;
}
#pragma mark - public
-(NSAttributedString *)renderRichText:(NSString *)text{
//    self.textView.textStorage.delegate = self;
    if (!_parser) {
        _parser = [[RichTextParser alloc]init];
    }
   __block NSAttributedString *str = nil;
    // 解析是同步的
    [_parser parserString:text block:^(NSAttributedString *result) {
        str = result;
    }];
    [_keyWords addObjectsFromArray:_parser.datas];
    _latestString = str;
    
    for (KeyWordModel *keyword in _keyWords) {
        if (keyword.el_type == KeywordTypeImage) {
            [_webImageKeywords addObject:keyword];
        }
    }
    return str;
}

-(void)startDownloadWebImage{
    // 下载网络图片
//    NSArray *textAttchments = [_parser getTextAttachments];
    for (int i = 0 ; i <_webImageKeywords.count; i++ ) {
        ImageKeyWord *imageKeyword = _webImageKeywords[i];
        
        NSString *urlString = imageKeyword.url;
        NSURL *URL = [NSURL URLWithString:urlString];
//        HXTextAttachment *textAttchment = textAttchments[i];
        
        [[SDWebImageDownloader sharedDownloader]
         downloadImageWithURL:URL
         options:0
         progress:nil
         completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"1-----> %@",URL);
                 if (error) {
                     return;
                 }
                 __block NSAttributedString *atrf = nil;
                 __block NSRange rangef = NSMakeRange(0, 0);

                 [self.textView.textStorage  enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textView.textStorage.length) options:NSAttributedStringEnumerationReverse usingBlock:^(HXTextAttachment *value, NSRange range, BOOL * _Nonnull stop) {
                     if (value) {
                         NSLog(@"2-----> %@ -- %@",value.url,[NSValue valueWithRange:range]);
                         if ([value.url isEqualToString:URL.absoluteString]) {
                             value.image = image;
                             atrf = [NSAttributedString attributedStringWithAttachment:value];
                             rangef = range;
                         }
                     }

                 }];
                 [self.textView.textStorage replaceCharactersInRange:rangef withAttributedString:atrf];
             });
         }];
    }
    
//    [self.textView.textStorage  enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textView.textStorage.length) options:0 usingBlock:^(HXTextAttachment *value, NSRange range, BOOL * _Nonnull stop) {
//        if (value) {
//            NSLog(@"2----- %@",value);
//        }
//    }];
}

-(void)insertKeyword:(KeyWordModel *)keyword{
    
    if (keyword.el_type < 0) {
        return;
    }
    NSInteger keyword_type = keyword.el_type;
    
    // 1、获取插入的位置
    NSRange range = self.textView.selectedRange;
    
    NSString *content = @"";
    if (keyword_type != KeywordTypeImage) {
        // 将空白符插入
        content = [NSString stringWithFormat:@"%@%@",keyword.content,Link_c];
    }

    // 4、获取渲染关键字富文本
    NSAttributedString *keyword_ast = [self insertKeyWord:keyword atRange:range];
    
    // 5、将富文本插入到当前位置中
    [self.textView.textStorage replaceCharactersInRange:range withAttributedString:keyword_ast];
    
    // 6、将即将插入的关键放入关键字容器中
    [_keyWords addObject:keyword];
    
    // 8、更新光标位置
    self.textView.selectedRange = NSMakeRange(range.location + ((keyword.el_type == KeywordTypeImage)?2:keyword.content.length), 0);
    //NSMakeRange(keyword.tempRange.location+keyword.tempRange.length, 0);
    //NSMakeRange((range.location + (keyword.content.length<=0?(1+2):keyword.content.length + 2)), 0);
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
    
}

+(NSURL *)getSchemeURLWithKeyWord:(KeyWordModel *)keyword{
    NSURL *link = [NSURL URLWithString:[NSString stringWithFormat:@"%@://",RICH_SCHEME]];
    NSURLComponents *compontents = [[NSURLComponents alloc]initWithURL:link resolvingAgainstBaseURL:YES];
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *key in keyword.data) {
        NSString * value = [keyword.data[key] description];
        NSURLQueryItem *item = [[NSURLQueryItem alloc]initWithName:key value:value];
        [items addObject:item];
    }
    compontents.queryItems = items;
    return compontents.URL;
}

+(NSDictionary *)getDataFromScheme:(NSURL *)schemeURL{
    NSMutableDictionary *data = nil;
    if (schemeURL) {
        NSURLComponents *compontents = [[NSURLComponents alloc]initWithURL:schemeURL resolvingAgainstBaseURL:YES];
        if (compontents.queryItems.count > 0) {
            data = [NSMutableDictionary dictionary];
        }
        for (NSURLQueryItem *item in compontents.queryItems) {
            [data setObject:item.value forKey:item.name];
        }
    }
    return data;
}

+(NSString *)keyWordDescription:(KeyWordModel *)keyword{
    
    NSString *propsDescription = @"";
    
    KeywordType ele_type = keyword.el_type;
    if (ele_type == KeywordTypeImage) {
        ImageKeyWord *imgKyw = (ImageKeyWord *)keyword;
        NSString *propsStr = [NSString stringWithFormat:@"ele_type='%ld' url='%@' width='%.2f' height='%.2f' maxWidth='%.2f'",
                              (long)imgKyw.el_type,
                              imgKyw.url,
                              imgKyw.width,
                              imgKyw.height,
                              imgKyw.maxWidth];
        propsDescription = [NSString stringWithFormat:@"<%@ %@>%@</%@>",IMG_TAG,propsStr,imgKyw.content,IMG_TAG];
    }else{
        LinkKeyWord *linkKyw = (LinkKeyWord *)keyword;
        NSError *error = nil;
        NSString *dataStr = @"";
        if (linkKyw.data) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:linkKyw.data options:NSJSONWritingSortedKeys error:&error];
            if (!error) {
                dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            }
        }
        NSString *propsStr = [NSString stringWithFormat:@"ele_type='%ld' data='%@' ",
                              (long)linkKyw.el_type,
                              dataStr
                              ];
        propsDescription = [NSString stringWithFormat:@"<%@ %@>%@</%@>",LINK_TAG,propsStr,linkKyw.content,LINK_TAG];
        
    }
    
    return propsDescription;
}

+(KeyWordModel *)createKeyWordWithProps:(NSDictionary *)props{
    
    KeywordType ele_type = [props[@"el_type"] integerValue];
    
    if (ele_type == KeywordTypeImage) {
        ImageKeyWord *keyword = [[ImageKeyWord alloc]init];
        keyword.el_type = ele_type;
        keyword.width =  [props[@"width"] floatValue];
        keyword.height =  [props[@"height"] floatValue];
        keyword.maxWidth =  [props[@"maxWidth"] floatValue];
        keyword.url =  props[@"url"];
        
        NSString *dataStr = props[@"data"];
        NSError *error = nil;
        if (dataStr) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                keyword.data = data;
            }
        }
        
        return keyword;
        
    }else{
        LinkKeyWord *keyword = [[LinkKeyWord alloc]init];
        keyword.el_type = [props[@"ele_type"] integerValue];
        keyword.content = props[@"content"];
        
        NSString *dataStr = props[@"data"];
        NSError *error = nil;
        if (dataStr) {
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                keyword.data = data;
            }
        }
        return keyword;
    }
}

#pragma mark - private
-(NSAttributedString *)insertKeyWord:(KeyWordModel *)keyWord atRange:(NSRange)range{
    if (!_editor) {
        _editor = [[RichTextEidtor alloc]init];
    }
    __block NSAttributedString *_attributed = nil;
    // 更新富文本
    [_editor insertKeyWord:keyWord
                     block:^(NSString *newrichText, NSAttributedString *keywordAttributed,NSRange keywordRange) {
        _attributed = keywordAttributed;
    }];
    // 返回用于渲染的富文本
    return _attributed;

}

-(void)replaceWebImage:(UIImage *)image withKeyword:(KeyWordModel *)keyword{
//    NSLog(@"图片位置%@",[NSValue valueWithRange:keyword.tempRange]);
//    RichTextEidtor *editor = [[RichTextEidtor alloc]init];
//    editor.imageMaxWidth = _imageMaxWidth;
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:keyword.props];
//    dic[PROP_IMAGE] = image;
//    keyword.props = dic;
//    
//    NSAttributedString *attr =  [editor getImageAttributedStringWithKeyword:keyword];
//    [self.textView.textStorage replaceCharactersInRange:keyword.tempRange withAttributedString:attr];
}

#pragma mark - 更新关键字位置
@end
