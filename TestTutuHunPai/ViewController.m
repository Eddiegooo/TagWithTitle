//
//  ViewController.m
//  TestTutuHunPai
//
//  Created by FQL on 2018/6/19.
//  Copyright © 2018年 FQL. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "NSObject+LabelLineString.h"

@interface ViewController ()

/*!
 *  @brief 最底下容器Label
 */
@property (nonatomic, strong) UILabel *backGorundLabel;
/*!
 *  @brief 标签
 */
@property (nonatomic, strong) UILabel *preLabel;
/*!
 *  @brief 标签一起的标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/*!
 *  @brief 标签下面的标题
 */
@property (nonatomic, strong) UILabel *subLabel;
/*!
 *  @brief 标签内筒
 */
@property (nonatomic, strong) NSString *preString;
/*!
 *  @brief 标题
 */
@property (nonatomic, strong) NSString *titleString;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.preString = @"Clearance";
    self.titleString = @"this is title , but the title is very xian在我又在改了哈， 就是改改改改 等级考试的富家大室jkfdskfjdskfjjjkfh jfdskfjds fjsdkf ";
    
    
    [self.view addSubview:self.backGorundLabel];
    [self.backGorundLabel addSubview:self.preLabel];
    [self.backGorundLabel addSubview:self.titleLabel];
    
    [self fillTheContents];
    
}


- (void)fillTheContents {
    self.preLabel.text = self.preString;
    
    /*!
     *  @brief 方法一： 使用首行缩进方法 这个方法比较简单也更优
     */
//    开始
    self.titleLabel.text = self.titleString;
    
    //标签宽度，即缩进距离。 这里为了更好的展示，加了10的偏移量
    CGFloat headIndent = [self.preLabel sizeThatFits:CGSizeMake(self.preLabel.intrinsicContentSize.width, 200)].width + 10;

    //缩进富文本
    NSDictionary *attDict = [self settingAttributesWithLineSpace:5.0f FirstLineHeadIndent:headIndent LabelFont:[UIFont systemFontOfSize:14.0] LabelTextColor:self.titleLabel.textColor];

    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.titleString attributes:attDict];
    //设置标题
    self.titleLabel.attributedText = string;
//    结束
    
    /*!
     *  @brief 方法二： 使用计算每行字符串多少，自定义布局
     */
    [self resetViewsConstraints];
}

- (void)resetViewsConstraints {
    //1.计算标签label的大小
    self.preLabel.frame = CGRectMake(0, 0, self.preLabel.intrinsicContentSize.width + 5, self.preLabel.intrinsicContentSize.height);
    
    //2.计算标题
    self.titleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width - CGRectGetMaxX(self.preLabel.frame), self.titleLabel.intrinsicContentSize.height);
    
    //3. 看标题到底有多少 ==== 1>.一行， 就这样布局  2>.多行， 添加subLabel， 计算subLabel的第一个字符是什么
//     CGFloat count = self.titleLabel.intrinsicContentSize.height / self.titleLabel.font.lineHeight;
//    if (count > 1) {
//        [self.backGorundLabel addSubview:self.subLabel];
//    }
    //标题行数 字符串数组
    NSArray *lineStrArray = [self getSeparatedLinesFromLabel:self.titleLabel];
    
    if (lineStrArray.count > 2) {
        [self.backGorundLabel addSubview:self.subLabel];
        self.titleLabel.text = lineStrArray[0];
        NSMutableString *lineStr = [NSMutableString string];
        [lineStrArray enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > 0) {
                [lineStr appendString:text];
            }
        }];
        self.subLabel.text = lineStr;
        self.subLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.view.frame.size.width, 30);
        self.backGorundLabel.frame = CGRectMake(0, 100, self.view.frame.size.width, CGRectGetMaxY(self.subLabel.frame));
    }else {
        self.backGorundLabel.frame = CGRectMake(0, 100, self.view.frame.size.width, CGRectGetMaxY(self.titleLabel.frame));
    }
}


#pragma mark 计算每行的label
- (UILabel *)backGorundLabel {
    if (!_backGorundLabel) {
        _backGorundLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
        _backGorundLabel.backgroundColor = [UIColor cyanColor];
    }
    return _backGorundLabel;
}

- (UILabel *)preLabel {
    if (!_preLabel) {
        _preLabel = [[UILabel alloc] init];
        _preLabel.textColor = [UIColor redColor];
        _preLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _preLabel;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _titleLabel;
}


- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.textColor = [UIColor lightGrayColor];
        _subLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _subLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}










































@end
