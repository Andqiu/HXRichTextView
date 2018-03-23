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
        self.clipsToBounds = YES;
        self.delegate = self;
        _textManger = [[HXRichTextManager alloc]init];
        _textManger.textView = self;
        _textManger.imageMaxWidth = self.frame.size.width - 10;
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
@end
