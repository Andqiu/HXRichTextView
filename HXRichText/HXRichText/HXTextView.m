//
//  HXTextView.m
//  HXRichText
//
//  Created by kanon on 2017/11/21.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import "HXTextView.h"
#import "HXRichTextManager.h"

@interface HXTextView()<UITextViewDelegate>
@end

@implementation HXTextView{
    
    HXRichTextManager *_textManger;
    
    NSString *_latestString;
    NSString *_replaceString;
    NSRange _replaceRange;
    NSRange _selectedRange;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        self.clipsToBounds = YES;
        self.delegate = self;
    }
    return self;
}

-(void)setRichText:(NSString *)richText{
    _textManger = [[HXRichTextManager alloc]init];
    _textManger.textView = self;
    _textManger.imageMaxWidth = self.frame.size.width;
    self.attributedText = [_textManger renderRichText:richText];
    _latestString = self.text;
}



#pragma mark - public
-(NSString *)getCurrentRichText{
    return [_textManger getRichText];;
}
-(void)insertImage:(UIImage *)image{
    
    [_textManger insertImage:@"分享_u589.png"];
}
-(void)insertUser:(NSString *)name{
    [_textManger insertUser:@"厚行投资"];
}
#pragma mark - delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    [self setReplaceString:text replaceRange:range];
    [_textManger setReplaceString:text replaceRange:range];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    [_textManger update];
//    [self update];
    
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
