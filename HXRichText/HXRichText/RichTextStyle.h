//
//  RichTextStyle.h
//  HXRichText
//
//  Created by kanon on 2017/11/23.
//  Copyright © 2017年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextStyle : NSObject
+(NSDictionary *)getNormalTextAttributed;
+(NSDictionary *)getLinkTextAttributed;
@end
