//
//  NSObject+LabelLineString.h
//  TestTutuHunPai
//
//  Created by FQL on 2018/6/19.
//  Copyright © 2018年 FQL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (LabelLineString)


- (NSDictionary *)settingAttributesWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)headIndent LabelFont:(UIFont *)font LabelTextColor:(UIColor *)textColor;

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

@end
