//
//  KeyWordModel.h
//  HXRichText
//
//  Created by kanon on 2017/11/20.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LINK_TAG @"HX_LINK"
#define IMG_TAG @"HX_IMG"
#define RICH_SCHEME @"hx_rich_scheme"

// 标签属性
#define PROP_WIDTH @"width"
#define PROP_HEIGHT @"height"
#define PROP_SRC @"src"
#define PROP_EL_TYPE @"el_type"
#define PROP_TYPE @"type"
#define PROP_UID @"uid"
#define PROP_PID @"pid"
#define PROP_NAME @"name"
#define PROP_URL @"url"
#define PROP_IMAGE @"image"

typedef  NS_ENUM(NSInteger,KeywordType){
    KeywordTypeLink = 0,
    KeywordTypeUser = 1,
    KeywordTypeProduct = 2,
    KeywordTypeImage = 3,
};

/**
 关键字模型
 */
@interface KeyWordModel : NSObject

@property(nonatomic,assign)NSInteger kid;


/**
 临时range
 */
@property(nonatomic,assign)NSRange tempRange;

/**
 标签属性
 */
@property(nonatomic,strong)NSDictionary *props;

/**
 标签内容
 */
@property(nonatomic)NSString * content;

/**
 标签字符串，可能会很多的空格符
 */
@property(nonatomic)NSString * originString;


/**
 标准的模板字符串
 */
@property(nonatomic)NSString * standardString;

@end
