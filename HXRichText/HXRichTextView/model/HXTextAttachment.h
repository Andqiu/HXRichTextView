//
//  HXTextAttachment.h
//  HXRichText
//
//  Created by kanon on 2018/3/26.
//  Copyright © 2018年 hxjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTextAttachment : NSTextAttachment
@property(nonatomic,strong)NSString *url;
@property(nonatomic,assign)CGFloat maxWidth;
@end
