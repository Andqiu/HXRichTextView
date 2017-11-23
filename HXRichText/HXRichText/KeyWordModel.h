//
//  KeyWordModel.h
//  HXRichText
//
//  Created by kanon on 2017/11/20.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 关键字模型
 */
@interface KeyWordModel : NSObject

/**
 临时range
 */
@property(nonatomic,assign)NSRange tempRange;
//@property(nonatomic,assign)NSRange newrange;

@property(nonatomic,strong)NSDictionary *props;
@property(nonatomic)NSString * content;
@property(nonatomic)NSString * originString;

@end
