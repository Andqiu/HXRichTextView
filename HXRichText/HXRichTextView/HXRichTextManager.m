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
    _parser.imageMaxWidth = _imageMaxWidth;
   __block NSAttributedString *str = nil;
    // 解析是同步的
    [_parser parserString:text block:^(NSAttributedString *result) {
        str = result;
    }];
    [_keyWords addObjectsFromArray:_parser.datas];
    _latestString = str;
    
    for (KeyWordModel *keyword in _keyWords) {
        NSLog(@"%@-%@",keyword.props[PROP_EL_TYPE],keyword.props[PROP_SRC]);
        if ([keyword.props[PROP_EL_TYPE] integerValue] == 3 && [keyword.props[PROP_SRC] hasPrefix:@"http"]) {
            [_webImageKeywords addObject:keyword];
        }
    }
    
    // 下载网络图片
    for (KeyWordModel *imageKeyword in _webImageKeywords) {
        NSString *urlString = imageKeyword.props[PROP_SRC];
        NSURL *URL = [NSURL URLWithString:urlString];
        [[SDWebImageDownloader sharedDownloader]
         downloadImageWithURL:URL
         options:0
         progress:nil
         completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
             dispatch_async(dispatch_get_main_queue(), ^{
                [self replaceWebImage:image withKeyword:imageKeyword];
             });
         }];
    }
    
    return str;
}

-(void)insertKeyword:(KeyWordModel *)keyword{
    
    if (keyword.props[PROP_EL_TYPE] == nil) {
        return;
    }
    NSInteger keyword_type = [keyword.props[PROP_EL_TYPE] integerValue];
    
    // 1、获取插入的位置
    NSRange range = self.textView.selectedRange;
    
    // 2、更新插入位置
    NSString *content = @"";
    if (keyword_type != KeywordTypeImage) {
        // 将空白符插入
        content = [NSString stringWithFormat:@"%@%@",keyword.content,Link_c];
    }
    [self setReplaceString:content replaceRange:range];
    
    // 3、更新已经存在的关键字位置 并修改插入部分的样式
//    [self updateKeyRangsWithOffSet:(keyword_type != KeywordTypeImage)?content.length:2 textDidChange:NO];
    
    // 4、获取渲染关键字富文本
    NSAttributedString *keyword_ast = [self insertKeyWord:keyword atRange:range];
    
    // 5、将富文本插入到当前位置中
    [self.textView.textStorage replaceCharactersInRange:range withAttributedString:keyword_ast];
    
    // 6、将即将插入的关键放入关键字容器中
    [_keyWords addObject:keyword];
    
    // 7、 更新
//    _latestString = self.textView.attributedText;
    
    // 8、更新光标位置
    self.textView.selectedRange = NSMakeRange(keyword.tempRange.location+keyword.tempRange.length, 0);//NSMakeRange((range.location + (keyword.content.length<=0?(1+2):keyword.content.length + 2)), 0);
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
    
}

#pragma mark - private
-(NSAttributedString *)insertKeyWord:(KeyWordModel *)keyWord atRange:(NSRange)range{
    if (!_editor) {
        _editor = [[RichTextEidtor alloc]init];
    }
    _editor.imageMaxWidth = _imageMaxWidth;
    __block NSAttributedString *_attributed = nil;
    // 更新富文本
    [_editor insertKeyWord:keyWord
                   atRange:range
                     block:^(NSString *newrichText, NSAttributedString *keywordAttributed,NSRange keywordRange) {
        _attributed = keywordAttributed;
    }];
    // 返回用于渲染的富文本
    return _attributed;

}

-(void)replaceWebImage:(UIImage *)image withKeyword:(KeyWordModel *)keyword{
    NSLog(@"图片位置%@",[NSValue valueWithRange:keyword.tempRange]);
    RichTextEidtor *editor = [[RichTextEidtor alloc]init];
    editor.imageMaxWidth = _imageMaxWidth;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:keyword.props];
    dic[PROP_IMAGE] = image;
    keyword.props = dic;
    
    NSAttributedString *attr =  [editor getImageAttributedStringWithKeyword:keyword];
    [self.textView.textStorage replaceCharactersInRange:keyword.tempRange withAttributedString:attr];
}

#pragma mark - 更新关键字位置
-(void)setReplaceString:(NSString *)text replaceRange:(NSRange)range{
    _replaceString = text;
    _replaceRange = range;
}
-(void)update{

   NSRange _selectedRange = self.textView.selectedRange;
    bool isChinese;//判断当前输入法是否是中文
    if ([[[self.textView textInputMode] primaryLanguage]  isEqualToString: @"en-US"]) {
        isChinese = NO;
    }
    else
    {
        isChinese = YES;
    }
    //获取高亮部分
    UITextPosition *position = nil;
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [ self.textView markedTextRange];
        //获取高亮部分
        position = [ self.textView positionFromPosition:selectedRange.start offset:0];
    }
    if (!position) {
        [self updateKeyRangsWithOffSet:self.textView.textStorage.length - _latestString.length textDidChange:YES];
        _latestString = self.textView.attributedText;
    }
    self.textView.selectedRange = _selectedRange;
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
}

-(void)updateKeyRangsWithOffSet:(NSInteger)offset textDidChange:(BOOL)didChange{
    NSRange editRange = NSMakeRange(0, 0);
    KeyWordModel *editKeyword = nil;
    
    if (offset < 0 ) {
        // 删除≥
        NSLog(@"删除操作");
        for (int i =0;i<_keyWords.count;i++) {
            KeyWordModel * model = _keyWords[i];
            NSRange rang = model.tempRange;
            
            if (rang.location >= (_replaceRange.location + _replaceRange.length)) {
                // 删除位置的右边区域关键字
                rang.location = rang.location + offset;
                model.tempRange = rang;
                NSLog(@"right ****** %@",[NSValue valueWithRange:model.tempRange]);
                NSAttributedString *s = [self.textView.textStorage attributedSubstringFromRange:model.tempRange];
                NSLog(@"222: %@",s);
            }else if((rang.location + rang.length) <= _replaceRange.location){
                // 删除位置的左边区域关键字
                NSLog(@"left -----> %@",[NSValue valueWithRange:model.tempRange]);
            }else{
                // 删除区域与关键字区域有交集
                
                BOOL shouldRemoveAttr = NO;
                if (rang.location < _replaceRange.location && (rang.location + rang.length) <= (_replaceRange.location + _replaceRange.length)) {
                        // 左交集
                    model.tempRange = NSMakeRange(rang.location, _replaceRange.location - rang.location);
                    shouldRemoveAttr = true;
                }else if(_replaceRange.location <= rang.location &&(rang.location + rang.length) >= (_replaceRange.location + _replaceRange.length)){
                        // 右交集
                    model.tempRange = NSMakeRange(_replaceRange.location + _replaceRange.length, (rang.location + rang.length) - (_replaceRange.location + _replaceRange.length));
                    shouldRemoveAttr = true;

                }else if(rang.location <= _replaceRange.location && (rang.location + rang.length) >= (_replaceRange.location + _replaceRange.length)){
                    // 被关键字包含
                    shouldRemoveAttr = true;
                    model.tempRange = NSMakeRange(rang.location, rang.length - _replaceRange.length);
                }
                
                if (shouldRemoveAttr) {
                    [self.textView.textStorage addAttributes:[RichTextStyle getNormalTextAttributed] range:model.tempRange];
                    if ([model.props[PROP_EL_TYPE] integerValue] != 3) {
                        [self.textView.textStorage removeAttribute:NSLinkAttributeName range:model.tempRange];
                    }
                }
                
                [_invalidKeywords addObject:model];

            }
        
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_invalidKeywords enumerateObjectsUsingBlock:^(KeyWordModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.tempRange = NSMakeRange(0, 0);
                [_keyWords removeObject:obj];
            }];
            
        });
        
    }else{
        NSLog(@"添加操作");

        for (int i =0;i<_keyWords.count;i++) {
            KeyWordModel * model = _keyWords[i];
            NSRange rang = model.tempRange;
            if (rang.location >= _replaceRange.location) {
                //  插入位置的右边区域关键字
                rang.location = rang.location + offset;
                model.tempRange = rang;
                NSLog(@"right ****** %@",[NSValue valueWithRange:model.tempRange]);
            }else if((rang.location + rang.length) <= _replaceRange.location ){
                // 插入位置的左边区域关键字
                NSLog(@"left -----> %@",[NSValue valueWithRange:model.tempRange]);
            }else{
                // 插入位置的在关键字上
                model.tempRange = NSMakeRange(0, 0);
                if (didChange) {
                    editRange = NSMakeRange(rang.location, rang.length+offset);
                }else{
                    editRange = rang;
                }
                editKeyword = model;
            }
        }
        
        if (editKeyword) {
            [_invalidKeywords addObject:editKeyword];
            [_keyWords removeObject:editKeyword];
            
            // 更新已编辑的关键字样式
            [self.textView.textStorage addAttributes:[RichTextStyle getNormalTextAttributed] range:editRange];
            if ([editKeyword.props[PROP_EL_TYPE] integerValue] != 3) {
                [self.textView.textStorage removeAttribute:NSLinkAttributeName range:editRange];
            }
        }
    }

}
@end
