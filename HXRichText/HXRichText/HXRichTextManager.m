//
//  HXRichTextManager.m
//  HXRichText
//
//  Created by kanon on 2017/11/15.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "HXRichTextManager.h"
#import "RichTextStyle.h"

@implementation HXRichTextManager{
    
    NSMutableArray *_keyWords;
    
    NSString *_richString;

    NSString *_latestString;
    NSString *_replaceString;
    NSRange _replaceRange;
    NSRange _selectedRange;
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
    }
    return self;
}

-(NSAttributedString *)renderRichText:(NSString *)text{
    _richString = text;
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
    _latestString = str.string;
    return str;
}

-(NSAttributedString *)insertKeyWord:(KeyWordModel *)keyWord atRange:(NSRange)range{
    if (!_editor) {
        _editor = [[RichTextEidtor alloc]init];
    }
    _editor.imageMaxWidth = _imageMaxWidth;
    __block NSAttributedString *_attributed = nil;
    // 更新富文本
    [_editor insertKeyWord:keyWord
                   atRange:range
                  richText:_richString
                     block:^(NSString *newrichText, NSAttributedString *keywordAttributed,NSRange keywordRange) {
        _richString = newrichText;
        _attributed = keywordAttributed;
    }];
    // 返回用于渲染的富文本
    return _attributed;

}

-(NSString *)getRichText{
    return _richString;
}

#pragma mark - 插入
-(void)insertKeyword:(KeyWordModel *)keyword{

    if (keyword.props[@"type"] == nil) {
        return;
    }
    NSInteger keyword_type = [keyword.props[@"type"] integerValue];
    
    // 1、获取插入的位置
    NSRange range = self.textView.selectedRange;
    
    // 2、获取渲染关键字富文本
    NSAttributedString *atr = [self insertKeyWord:keyword atRange:range];
    
    // 3、将富文本插入到当前位置中
    NSMutableAttributedString *newstr = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    [newstr replaceCharactersInRange:range withAttributedString:atr];
    
    // 4、更新textView文本
    self.textView.attributedText = newstr;
    
    // 5、更新插入位置
    [self setReplaceString:(keyword_type != KeywordTypeImage)?keyword.content:@"" replaceRange:range];
    
    // 6、更新已经存在的关键字位置
    [self updateKeyRangsWithOffSet:(keyword_type != KeywordTypeImage)?keyword.content.length:1];
    
    // 7、将即将插入的关键放入关键字容器中
    [_keyWords addObject:keyword];
    
    // 8、重新刷新关键字样式
    [self updateTextViewStyle];
    
    // 9、更新光标位置
    self.textView.selectedRange = NSMakeRange(range.location + keyword.content.length, 0);
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
 
}

#pragma mark - 更新关键字位置
-(void)setReplaceString:(NSString *)text replaceRange:(NSRange)range{
    _replaceString = text;
    _replaceRange = range;
}
-(void)update{
    _selectedRange = self.textView.selectedRange;
    bool isChinese;//判断当前输入法是否是中文
    
    if ([[[self.textView textInputMode] primaryLanguage]  isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [ self.textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [ self.textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {            
            [self updateKeyRangsWithOffSet:self.textView.text.length - _latestString.length];
            [self updateTextViewStyle];
        }else{
            
        }
    }else{
        
        // 英文输入法下
        [self updateKeyRangsWithOffSet:self.textView.text.length - _latestString.length];
        [self updateTextViewStyle];
    }
    self.textView.selectedRange = _selectedRange;
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
}

-(void)updateKeyRangsWithOffSet:(NSInteger)offset{
    _latestString = self.textView.text;
    if (offset < 0 ) {
        // 删除
        NSLog(@"删除操作");
        for (int i =0;i<_keyWords.count;i++) {
            KeyWordModel * model = _keyWords[i];
            NSRange rang = model.tempRange;
            if (rang.location >= (_replaceRange.location - offset)) {
                // 插入位置的右边区域关键字
                rang.location = rang.location + offset;
                model.tempRange = rang;
                NSLog(@"right ****** %@",[NSValue valueWithRange:model.tempRange]);
            }else if((rang.location + rang.length) <= _replaceRange.location){
                // 插入位置的左边区域关键字
                NSLog(@"left -----> %@",[NSValue valueWithRange:model.tempRange]);
            }else{
                
                // 插入位置的在关键字上
                model.tempRange = NSMakeRange(0, 0);
                
            }
        }
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
            }
            
        }
    }
    
}

-(void)updateTextViewStyle{
    
    NSMutableAttributedString *mutable_attributed = self.textView.attributedText.mutableCopy;
    [mutable_attributed addAttributes:[RichTextStyle getNormalTextAttributed] range:NSMakeRange(0, mutable_attributed.length)];
//    self.textView.attributedText = mutable_attributed;
    for (KeyWordModel *keyword in _keyWords) {
        NSRange range = keyword.tempRange;
        NSLog(@"end -----> %@",[NSValue valueWithRange:range]);
        if (range.location == 0 && range.length == 0) {
            if ([keyword.props[@"type"] integerValue] != 3) {
                
            }else{
                
            }
        }else{
            if ([keyword.props[@"type"] integerValue] != 3) {
                [mutable_attributed addAttributes:[RichTextStyle getLinkTextAttributed] range:range];
            }
        }
    }
    self.textView.attributedText = mutable_attributed;

}

@end
