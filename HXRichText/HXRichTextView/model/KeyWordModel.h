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
#define PROP_WIDTH @"width"   // 图片宽度
#define PROP_HEIGHT @"height"   // 图片高度
#define PROP_SRC @"src" // 链接地址
#define PROP_EL_TYPE @"el_type" // 标签类型
#define PROP_TYPE @"type"  // 用户类型
#define PROP_UID @"uid"  // 用户id
#define PROP_PID @"pid"  // 产品id
#define PROP_NAME @"name"  // 用户/产品名称
#define PROP_URL @"url" // 图片地址
#define PROP_IMAGE @"image" // 图片UIImage实例

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
