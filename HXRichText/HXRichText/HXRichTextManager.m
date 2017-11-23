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
    [_editor insertKeyWord:keyWord atRange:range richText:_richString block:^(NSString *newrichText, NSAttributedString *attributed) {
        _richString = newrichText;
        _attributed = attributed;
    }];
    // 返回用于渲染的富文本
    return _attributed;

}

-(NSString *)getRichText{
    return _richString;
}

#pragma mark - 插入
-(void)insertImage:(NSString *)imageNamed{
    UIImage *image = [UIImage imageNamed:imageNamed];
    NSRange range = self.textView.selectedRange;
    KeyWordModel *keyword = [[KeyWordModel alloc]init];
    NSString *width = [NSString stringWithFormat:@"%f",image.size.width];
    NSString *height = [NSString stringWithFormat:@"%f",image.size.height];
    keyword.props = @{@"type":@"3",@"src":@"分享_u589.png",@"width":width,@"height":height};
    NSAttributedString *atr = [self insertKeyWord:keyword atRange:range];
    NSMutableAttributedString *newstr = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    [newstr replaceCharactersInRange:range withAttributedString:atr];
    self.textView.attributedText = newstr;
    // 6、更新插入位置
    [self setReplaceString:@"" replaceRange:range];
    
    // 7、更新已经存在的关键字位置
    [self updateKeyRangsWithOffSet:1];
    
    // 8、将即将插入的关键放入关键字容器中
    [_keyWords addObject:keyword];
    
    // 9、重新刷新关键字样式
    [self updateTextViewStyle];
    
    // 10、更新光标位置
    self.textView.selectedRange = NSMakeRange(range.location + keyword.content.length, 0);
    [self.textView scrollRangeToVisible:self.textView.selectedRange];
}

-(void)insertUser:(NSString *)userNamed{
    
    // 1、获取插入的位置
    NSRange range = self.textView.selectedRange;
    
    // 2、构造插入关键字对象
    KeyWordModel *keyword = [[KeyWordModel alloc]init];
    keyword.props = @{@"type":@"1",@"href":@"www.baidu.com"};
    keyword.content = [NSString stringWithFormat:@"@%@",userNamed];
    
    // 3、获取渲染关键字富文本
    NSAttributedString *atr = [self insertKeyWord:keyword atRange:range];
    
    // 4、将富文本插入到当前位置中
    NSMutableAttributedString *newstr = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    [newstr replaceCharactersInRange:range withAttributedString:atr];
    
    // 5、更新textView文本
    self.textView.attributedText = newstr;

    // 6、更新插入位置
    [self setReplaceString:keyword.content replaceRange:range];
    
    // 7、更新已经存在的关键字位置
    [self updateKeyRangsWithOffSet:keyword.content.length];
    
    // 8、将即将插入的关键放入关键字容器中
    [_keyWords addObject:keyword];
    
    // 9、重新刷新关键字样式
    [self updateTextViewStyle];
    
    // 10、更新光标位置
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
        _latestString = self.textView.text;
        
        [self updateTextViewStyle];
    }
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
    self.textView.attributedText = mutable_attributed;
    for (KeyWordModel *keyword in _keyWords) {
        NSRange range = keyword.tempRange;
        if (range.location == 0 && range.length == 0) {
            if ([keyword.props[@"type"] integerValue] != 3) {
                
            }else{
                
            }
        }else{
            if ([keyword.props[@"type"] integerValue] != 3) {
                [mutable_attributed addAttributes:[RichTextStyle getLinkTextAttributed] range:range];
                self.textView.attributedText = mutable_attributed;
                self.textView.selectedRange = _selectedRange;
                [self.textView scrollRangeToVisible: self.textView.selectedRange];
            }
        }
    }
}

@end
