//
//  RichToolView.h
//  HXRichText
//
//  Created by kanon on 2017/11/24.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichToolView : UIView
@property(nonatomic,copy)void(^clickBlock)(NSInteger index);
@end
