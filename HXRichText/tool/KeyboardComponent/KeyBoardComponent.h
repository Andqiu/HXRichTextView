//
//  KeyBoardComponent.h
//  hxpay
//
//  Created by kanon on 15/11/17.
//  Copyright © 2015年 kanon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyBoardComponent;
@protocol keyBoardComponentDelegate <NSObject>

@optional

/*****    单个 ********/
/**
 * 为一个输入框加入键盘组件
 */
-(UIView *)KeyBoardComponentRigsterView:(KeyBoardComponent *)keyBoardComponent;

/*****    多个 ********/
/**
 * 为多个输入框加入键盘组件
 */
-(NSArray *)KeyBoardComponentRigsterViews:(KeyBoardComponent *)keyBoardComponent;
/**
 * 返回 所有输入框默认的头部标题
 */
-(NSArray *)keyBoardComponentTopTitles:(KeyBoardComponent *)keyBoardComponent;



/*****     ********/

-(UIViewController *)keyBoardComponentInViewController:(KeyBoardComponent *)keyBoardComponent;

/**
 * 返回自定义头部样式
 */
-(UIView *)KeyBoardComponentTopView;


/***** 键盘通知********/
-(void)keyBoardComponentWillShow:(NSNotification *)noti;
-(void)keyBoardComponentDidShow:(NSNotification *)noti;
-(void)keyBoardComponentWillHide:(NSNotification *)noti;
-(void)keyBoardComponentDidHide:(NSNotification *)noti;

@end


typedef void(^DoneBlock)(void);
@interface KeyBoardComponent : NSObject

@property(nonatomic,assign)id<keyBoardComponentDelegate>delegate;
@property(nonatomic,strong)NSString *defaultTitle;

@property(nonatomic,copy)DoneBlock doneBlock;

-(void)registerComponent;
-(void)registComponent;

@end
