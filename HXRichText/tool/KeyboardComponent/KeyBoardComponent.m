//
//  KeyBoardComponent.m
//  hxpay
//
//  Created by kanon on 15/11/17.
//  Copyright © 2015年 kanon. All rights reserved.
//

#import "KeyBoardComponent.h"

@interface KeyBoardComponent()


@property(nonatomic,strong)UITextField *registerTT;
@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *doneBtn;

@end

@implementation KeyBoardComponent{
    
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self addKeyBoradNotification];
    }
    
    return self;
}
-(void)registerComponent{
    [self registComponent];
}

-(void)registComponent{
    
    if ([_delegate respondsToSelector:@selector(KeyBoardComponentRigsterViews:)]) {
        
        NSArray *views = [_delegate KeyBoardComponentRigsterViews:self];
        NSArray *titles = [_delegate keyBoardComponentTopTitles:self];
        NSAssert(views.count == titles.count, @"键盘组件头部视图与标题数量不相等");
        
        for (int i = 0; i<views.count; i++) {
            
            UIView *view = views[i];
            if([view isKindOfClass:[UITextField class]]){
                
                UITextField *tex = (UITextField *)view;
                tex.inputAccessoryView = [self getDefaultView:titles[i]];
            }
            
            if([view isKindOfClass:[UITextView class]]){
                
                UITextView *tex = (UITextView *)view;
                tex.inputAccessoryView = [self getDefaultView:titles[i]];
            }
        }
    }
    
    if ([_delegate respondsToSelector:@selector(KeyBoardComponentRigsterView:)]) {
        
        UIView *view = [_delegate KeyBoardComponentRigsterView:self];
        
        if([view isKindOfClass:[UITextField class]]){
            
            _registerTT = (UITextField *)view;
            
            _registerTT.inputAccessoryView = [self topView];
            
        }
        if([view isKindOfClass:[UITextView class]]){
            
            UITextView *tex = (UITextView *)view;
            tex.inputAccessoryView =  [self topView];
        }
        
        return;
    }
}


-(void)addKeyBoradNotification{
    
    //添加观察者
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyBoardComponentWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardComponentWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardComponentDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(keyBoardComponentDidHide:) name:UIKeyboardDidHideNotification object:nil];

}

-(void)keyBoardComponentWillShow:(NSNotification *)notification{
    
    if ([_delegate respondsToSelector:@selector(keyBoardComponentWillShow:)]) {
        [_delegate keyBoardComponentWillShow:notification];
    }
}

-(void)keyBoardComponentWillHide:(NSNotification *)notification{
    
    if ([_delegate respondsToSelector:@selector(keyBoardComponentWillHide:)]) {
        [_delegate keyBoardComponentWillHide:notification];
    }
}

-(void)keyBoardComponentDidHide:(NSNotification *)notification{
    
    if ([_delegate respondsToSelector:@selector(keyBoardComponentDidHide:)]) {
        [_delegate keyBoardComponentDidHide:notification];
    }
}

-(void)keyBoardComponentDidShow:(NSNotification *)notification{
    
    if ([_delegate respondsToSelector:@selector(keyBoardComponentDidShow:)]) {
        [_delegate keyBoardComponentDidShow:notification];
    }
    
//    UIView *_doneBtnView = [self topView];
//    _topView.hidden = NO;
//
//    if ([_delegate respondsToSelector:@selector(KeyBoardComponentRigsterView)]) {
//        
//        UIView *view = [_delegate KeyBoardComponentRigsterView];
//        
//        if([view isKindOfClass:[UITextField class]]){
//            
//            UITextField *tx = (UITextField *)view;
//            tx.inputAccessoryView = _topView;
//
//        }
//        
//        return;
//    }
//    
//    UIViewController *vc = [_delegate keyBoardComponentInViewController];
//    [vc.view addSubview:_doneBtnView];
//
//    // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
//    NSDictionary *userInfo = [notification userInfo];
//    // UIKeyboardAnimationDurationUserInfoKey 对应键盘弹出的动画时间
//    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    // UIKeyboardAnimationCurveUserInfoKey 对应键盘弹出的动画类型
//    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    
//    CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//
//    _doneBtnView.top = SCREEN_HEIGHT - keyboardHeight - _doneBtnView.height;
//    _doneBtnView.alpha = 0;
//    if (_doneBtnView){
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:animationDuration];//设置添加按钮的动画时间
//        [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
//        _doneBtnView.alpha = 1;
//        [UIView commitAnimations];
//    }
}


#pragma mark - topview

-(UIView *)topView{
    
    if (!_topView) {
        
        UIView *view  = nil;
        
        if ([_delegate respondsToSelector:@selector(KeyBoardComponentTopView)]) {
            view  =  [_delegate KeyBoardComponentTopView];
            
        }
        if (!view) {
            
            view = [self getDefaultView:_defaultTitle];
        }
        
        _topView = view;
    }
    
    return _topView;
    
}


-(UIView *)getDefaultView:(NSString *)title{
    
    UIView*  _doneBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 0, 70,_doneBtnView.frame.size.height);
    [_doneBtnView addSubview:btn];
    _doneBtnView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [btn addTarget:self action:@selector(registerView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    titleLab.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = title;
    [titleLab sizeToFit];
    titleLab.center = CGPointMake(_doneBtnView.center.x, _doneBtnView.frame.size.height/2);
    [_doneBtnView addSubview:titleLab];
    
    return _doneBtnView;
}

-(void)registerView{
    
    if (_doneBlock) {
        _doneBlock();
    }
    
    if ([_delegate respondsToSelector:@selector(keyBoardComponentInViewController:)]) {
        UIViewController *vc = [_delegate keyBoardComponentInViewController:self];
        [vc.view endEditing:YES];
    }
    [_registerTT resignFirstResponder];

    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}


/*
 
 +(void)addKeyBoardComponentInViewController:(UIViewController *)vc{
 
 [KeyBoardComponent addKeyBoradNotification];
 
 }
 
 -(void)keyboardWillHide:(NSNotification *)notification{
 
 _hudView.hidden = YES;
 [_hudView removeFromSuperview];
 
 _doneBtnView.hidden = YES;
 [_doneBtnView removeFromSuperview];
 
 }
 
 -(void)keyboardWillShown:(NSNotification *)notification{
 
 
 }
 
 -(void)keyboardDidShow:(NSNotification *)notification{
 
 _hudView.hidden = NO;
 
 _doneBtnView.hidden = NO;
 [self.parentViewController.navigationController.view addSubview:_doneBtnView];
 
 // NSNotification中的 userInfo字典中包含键盘的位置和大小等信息
 NSDictionary *userInfo = [notification userInfo];
 // UIKeyboardAnimationDurationUserInfoKey 对应键盘弹出的动画时间
 CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
 // UIKeyboardAnimationCurveUserInfoKey 对应键盘弹出的动画类型
 NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
 
 CGFloat keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
 
 NSLog(@"%f",keyboardHeight);
 _doneBtnView.top = ScreenHeight - keyboardHeight - _doneBtnView.height;
 _doneBtnView.alpha = 0;
 if (_doneBtnView){
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:animationDuration];//设置添加按钮的动画时间
 [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];//设置添加按钮的动画类型
 _doneBtnView.alpha = 1;
 [UIView commitAnimations];
 }
 }
 
 +(void)addKeyBoradNotification{
 //添加观察者
 NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
 [center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
 [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
 [center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
 }
 

 
 */


@end
