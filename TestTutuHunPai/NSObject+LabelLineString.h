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


//这里有两种不通方法实现这个需求

/**
 根据显示Label，计算出富文本字典

 @param lineSpace 行间距
 @param headIndent 首行缩进距离
 @param font 字号
 @param textColor 字体颜色
 @return 富文本字典
 */
- (NSDictionary *)settingAttributesWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)headIndent LabelFont:(UIFont *)font LabelTextColor:(UIColor *)textColor;


/**
 根据传入Label 求取每行的字符串

 @param label 显是的label
 @return 返回每行的字符串数组
 */
- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label;

@end
