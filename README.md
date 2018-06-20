
#### 需求背景：
年中促销活动，需要添加一个标签让用户知道这个是促销商品。

#### 我的想法
这很简单的， 根据接口返回信息，是否显示标签图片就好了嘛。 后来证实我还是太年轻。。。

#### 标签样式
经过UI设计师给出几个版本，最后给了一个在标题前面插入一个标签的样式。 **注意： 这个标签不是一个图片，不是图片。** 是一个文本外加虚线边框。样式如图：
![UI样式图.png](https://upload-images.jianshu.io/upload_images/2286585-4bf85e62edae02ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
乍一看这很简单啊，两个控件而已嘛， 最多在第一个控件那里画一个虚线边框。。 **但是：** 实际情况不是这样的， 后面的标题可能有两行！！！ 下一行开始要和标签对齐。。。

第一反应我是拒绝的，找设计师修改原型图。我给出几个方案：
>方案1：模仿淘宝，将标签用中括号包起来凸显。
![天猫标签.png](https://upload-images.jianshu.io/upload_images/2286585-a51536ba94adf31d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这个字体、样式、颜色都可以随便改， 你想怎么凸显都行。。但是产品不同意， 特么的换。

>方案2：将标签做成图片，直接嵌套在前面。
设计师不给做， 说是有多语言，太多了。。 还特么不行。

>方案N。。 都特么不行。。
产品说了，我不管你们怎么做，反正样式就这样了定了。 我反馈说不好实现等等， 人家回一句， 京东是可以的啊！！！ 心里一万只曹尼玛奔腾跑过啊。

既然定下来这样了， 只能硬着头皮试试。

#### 实现方法
###### 方法一：
最笨的方法： 计算标签字符串占据的位置， 将标题前面用空格补上相应的字符串占据位置，再讲标签控件放到最前面覆盖。
这个不到万不得已我是不用的哈。。

##### 方法二： 自定义封装控件
1.设置三个控件。 
控件一：标签； 
控件二：右侧标题； 
控件三：下面从标签开始的标题Label。(但是这个可能没有。)
效果图如下：
![模拟图.png](https://upload-images.jianshu.io/upload_images/2286585-518ea5b7a724db72.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

>这里面有几个困难点：
1.控件二显示文本多少，最后一个字符是哪个。
2.怎么确定有没有第二行标题控件。
3.第二个控件的起始字符怎么计算。

##### 实现方案
写了一个分类，算出具体每行显示的字符，将其保存在一个数组中，当数组个数大于1的时候，就有第二个控件。也即可以确定第二个控件的其实字符。
写了一个分类，传入第一行标题的Label计算。代码如下：
**注意：这个方法计算很多英文文本的时候，可能不太准确**

```
- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return (NSArray *)linesArray;
}
```

具体项目布局实现， 这个是demo，项目本身用Masonry布局，简单一些。 下面代码共参考：
```
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

```
以上就是我自己想到实现的方法。可能有点挫，但是能满足产品需求了。。


##### 更优方案
###### 方法三：首行缩进方法
对接上面代码过程中， 想到了一个更好的办法。也是基于方法一的改进。
既然能计算出标签控件的大小， 那我使用首行缩进方法不就完美解决了嘛。。 O(∩_∩)O哈哈~ 哈哈哈哈  容我笑一会哈。 实现demo：
![首行缩进.png](https://upload-images.jianshu.io/upload_images/2286585-c836c97286c716b4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

首先计算控件的大小来确定首行缩进距离， 多语言也没有问题。
其次计算缩进用的富文本字典。
最后直接将标题设置为富文本，将标签控件放在最前面即可。
```
    //标签宽度，即缩进距离。 这里为了更好的展示，加了10的偏移量
    CGFloat headIndent = [self.preLabel sizeThatFits:CGSizeMake(self.preLabel.intrinsicContentSize.width, 200)].width + 10;

    //缩进富文本
    NSDictionary *attDict = [self settingAttributesWithLineSpace:5.0f FirstLineHeadIndent:headIndent LabelFont:[UIFont systemFontOfSize:14.0] LabelTextColor:self.titleLabel.textColor];

    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.titleString attributes:attDict];
    //设置标题
    self.titleLabel.attributedText = string;
```
这里面有一个缩进富文本分类方法：
```
- (NSDictionary *)settingAttributesWithLineSpace:(CGFloat)lineSpace FirstLineHeadIndent:(CGFloat)headIndent LabelFont:(UIFont *)font LabelTextColor:(UIColor *)textColor; {
    //分段样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraphStyle.lineSpacing = lineSpace;
    //首行缩进
    paragraphStyle.firstLineHeadIndent = headIndent;
    //富文本样式
    NSDictionary *attributeDic = @{
                                   NSFontAttributeName : font,
                                   NSParagraphStyleAttributeName : paragraphStyle,
                                   NSForegroundColorAttributeName : textColor
                                   };
    return attributeDic;
}
```


#### 结束
至此，这个看似很简单的需求完成了。这个功能应该很多平台都会用，可以借鉴参考， 有更好的方案，也希望告知，感谢。

[参考文章：标题前面嵌入非图片标签](https://www.jianshu.com/p/5495e13dfc87)


