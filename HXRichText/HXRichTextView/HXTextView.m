//
//  HXTextView.m
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "HXTextView.h"
#import "KeyBoardComponent.h"
#import "RichToolView.h"
#import "RichTextStyle.h"

@interface HXTextView()<UITextViewDelegate,keyBoardComponentDelegate>
@end

@implementation HXTextView{
    
    
    NSString *_latestString;
    NSString *_replaceString;
    NSRange _replaceRange;
    NSRange _selectedRange;
    
    KeyBoardComponent *_keyboardComponent;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.clipsToBounds = YES;
        self.delegate = self;
        _textManger = [[HXRichTextManager alloc]init];
        _textManger.textView = self;
//        self.linkTextAttributes = [RichTextStyle getNormalTextAttributed];
        _textManger.imageMaxWidth = self.frame.size.width;
    }
    return self;
}

-(void)didAddSubview:(UIView *)view{
    _keyboardComponent = [[KeyBoardComponent alloc]init];
    _keyboardComponent.delegate = self;
    [_keyboardComponent registComponent];
}


-(void)setRichText:(NSString *)richText{

    self.attributedText = [_textManger renderRichText:richText];
    _latestString = self.text;
}

-(UIView *)KeyBoardComponentTopView{
    if (_keyboradToolView) {
      return  _keyboradToolView;
    }else{
        return  nil;
    }
}
-(UIView *)KeyBoardComponentRigsterView:(KeyBoardComponent *)keyBoardComponent{
    return self;
}

#pragma mark - public
-(NSString *)getCurrentRichText{
    return [_textManger getRichText];;
}
//-(void)insertImage:(NSString *)imageNamed{
//    
//    KeyWordModel *keyword = [[KeyWordModel alloc]init];
//    keyword.props = @{@"src":imageNamed,@"type":@(KeywordTypeImage),@"width":@(512),@"height":@(384)};
//    keyword.kid = _textManger.keyWords.count;
//    [_textManger insertKeyword:keyword];
//}
//-(void)insertUser:(NSString *)name {
//    KeyWordModel *keyword = [[KeyWordModel alloc]init];
//    keyword.kid = _textManger.keyWords.count;
//    keyword.content = [NSString stringWithFormat:@"@%@",name];
//    keyword.props = @{@"uid":@(123),@"type":@(KeywordTypeUser)};
//    [_textManger insertKeyword:keyword];
//}
//-(void)insertAct:(NSString *)name {
//    KeyWordModel *keyword = [[KeyWordModel alloc]init];
//    keyword.kid = _textManger.keyWords.count;
//    keyword.content = [NSString stringWithFormat:@"%@",name];
//    keyword.props = @{@"uid":@(123),@"type":@(KeywordTypeProduct)};
//    [_textManger insertKeyword:keyword];
//}
#pragma mark - delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [_textManger setReplaceString:text replaceRange:range];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    [_textManger update];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([URL.absoluteString hasPrefix:RICH_SCHEME]) {
        NSInteger index = [URL.lastPathComponent integerValue];
        if (index > _textManger.keyWords.count) {
            return NO;
        }
        KeyWordModel *keyword = _textManger.keyWords[index];
        if (_didClickKeywordBlock) {
            _didClickKeywordBlock(keyword);
        }
    }
    
    return NO;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    if ([URL.absoluteString hasPrefix:RICH_SCHEME]) {
        NSInteger index = [URL.lastPathComponent integerValue];
        if (index > _textManger.keyWords.count) {
            return NO;
        }
        KeyWordModel *keyword = _textManger.keyWords[index];
        if (_didClickKeywordBlock) {
            _didClickKeywordBlock(keyword);
        }
    }
    
    return NO;

}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange{
    return NO;
}
#pragma mark - ---------------------------------原始方案--已废弃---------------------------------------
#pragma mark - 文本样式
-(NSDictionary *)linkTextAttributed{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSKernAttributeName:@(0.5),
                                 NSForegroundColorAttributeName:[UIColor redColor]
                                 };
    
    return attributes;
}

-(NSDictionary *)normalTextAttributed{
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
#pragma mark - 更新关键字位置

-(void)updateTextViewAttributed{
    
    NSMutableAttributedString *mutable_attributed = self.attributedText.mutableCopy;
    [mutable_attributed addAttributes:[self normalTextAttributed] range:NSMakeRange(0, mutable_attributed.length)];
    self.attributedText = mutable_attributed;
    for (KeyWordModel *keyword in _textManger.parser.datas) {
        NSRange range = keyword.tempRange;
        if (range.location == 0 && range.length == 0) {
            if ([keyword.props[@"type"] integerValue] != 3) {
                
            }else{
                
            }
        }else{
            if ([keyword.props[@"type"] integerValue] != 3) {
                [mutable_attributed addAttributes:[self linkTextAttributed] range:range];
                self.attributedText = mutable_attributed;
                self.selectedRange = _selectedRange;
                [self scrollRangeToVisible: self.selectedRange];
            }
        }
    }
}
-(void)setReplaceString:(NSString *)text replaceRange:(NSRange)range{
    _replaceString = text;
    _replaceRange = range;
}
-(void)update{
    _selectedRange = self.selectedRange;
    bool isChinese;//判断当前输入法是否是中文
    
    if ([[[self textInputMode] primaryLanguage]  isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [ self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [ self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            [self updateKeyRangsWithOffSet:self.text.length - _latestString.length];
            _latestString = self.text;
            
            [self updateTextViewAttributed];
        }else{
            
        }
    }else{
        
        // 英文输入法下
        [self updateKeyRangsWithOffSet:self.text.length - _latestString.length];
        _latestString = self.text;
        
        [self updateTextViewAttributed];
    }
}

-(void)updateKeyRangsWithOffSet:(NSInteger)offset{
    
    if (offset < 0 ) {
        // 删除
        NSLog(@"删除操作");
        for (int i =0;i<_textManger.parser.datas.count;i++) {
            KeyWordModel * model = _textManger.parser.datas[i];
            NSRange rang = model.tempRange;
            if (rang.location >= (_replaceRange.location - offset)) {
                // 关键字右边区域
                rang.location = rang.location + offset;
                model.tempRange = rang;
                NSLog(@"right ****** %@",[NSValue valueWithRange:model.tempRange]);
            }else if((rang.location + rang.length) <= _replaceRange.location){
                // 关键字左边区域
                NSLog(@"left -----> %@",[NSValue valueWithRange:model.tempRange]);
            }else{
                
                model.tempRange = NSMakeRange(0, 0);
                
                // 关键字区域
            }
        }
    }else{
        NSLog(@"添加操作");
        for (int i =0;i<_textManger.parser.datas.count;i++) {
            KeyWordModel * model = _textManger.parser.datas[i];
            NSRange rang = model.tempRange;
            if (rang.location >= _replaceRange.location) {
                // 关键字右边区域
                rang.location = rang.location + offset;
                model.tempRange = rang;
                NSLog(@"right ****** %@",[NSValue valueWithRange:model.tempRange]);
            }else if((rang.location + rang.length) <= _replaceRange.location ){
                // 关键字左边区域
                NSLog(@"left -----> %@",[NSValue valueWithRange:model.tempRange]);
            }else{
                
                model.tempRange = NSMakeRange(0, 0);
                
                // 关键字区域
            }
            
        }
    }
    
}

@end
