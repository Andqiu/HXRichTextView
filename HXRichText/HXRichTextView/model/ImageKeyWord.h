//
//  ImageKeyWord.h
//  HXRichText
//
//  Created by kanon on 2018/3/26.
//  Copyright © 2018年 hxjr. All rights reserved.
//

#import "KeyWordModel.h"

@interface ImageKeyWord : KeyWordModel
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat maxWidth;
@property(nonatomic,strong)NSString * url;
@property(nonatomic,strong)UIImage * image;

@end
