//
//  CustomTools.h
//  moneyhll
//
//  Created by 李雪阳 on 16/11/7.
//  Copyright © 2016年 浙江龙之游旅游开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomTools : NSObject



/**
 自定义文字属性大小及颜色 label.attributedText
 
 @param lableText 要定义的文字内容
 @param sectionRange 改变属性的文字范围 例NSMakeRange(5, lableText.length-7)
 @param textFont 改变的字体属性及大小 常规字体 粗体等
 @param textColor 改变的字体颜色 不更改传nil
 */
+ (NSMutableAttributedString *_Nullable)labelDifferentAttributedWithText:(NSString *_Nullable)lableText Section:(NSRange)sectionRange Font:(UIFont *_Nonnull)textFont TextColor:(UIColor *_Nullable)textColor;


/// 自定义多条文字属性大小及颜色 label.attributedText
/// @param lableText lableText 要定义的文字内容
/// @param attributeStrings 需要更改自定义内容的文字数组
/// @param fonts 需要更改自定义内容的文字字体数组
/// @param colors 需要更改自定义内容的文字颜色数组
+ (NSMutableAttributedString *_Nullable)labelDifferentAttributedStringsWithText:(NSString *_Nonnull)lableText attributeStrings:(NSArray <NSString *>*_Nonnull)attributeStrings fonts:(NSArray <UIFont *>*_Nonnull)fonts textColors:(NSArray <UIColor *>*_Nullable)colors;


/// 自定义文字添加图片及位置
/// @param lableText 要定义的文字内容
/// @param image 添加的图片
/// @param imgX 图片x
/// @param imgY 图片y
/// @param insertIndex 插入文字的位置
+ (NSMutableAttributedString *_Nullable)labelAttachAttributedImageWithText:(NSString *_Nonnull)lableText image:(UIImage *_Nonnull)image imgX:(CGFloat)imgX imgY:(CGFloat)imgY insertIndex:(NSInteger)insertIndex;


/// 查找字符串中所有子串的位置
/// @param substring 子串
/// @param string 总字符串
+ (NSArray *)rangeOfAllSubstring:(NSString *)substring withString:(NSString *)string;


/**
 判断座机号
 */
+ (BOOL)isTelephoneNumber:(NSString *_Nullable)telephone;


/**
 判断手机号
 */
+ (BOOL)isMobileNumber:(NSString *_Nullable)mobileNum;


 /** 判断邮箱是否合法 */
+ (BOOL)checkEmail:(NSString *_Nullable)email;


/** 判断是否为整形 */
+ (BOOL)isPureInt:(NSString *_Nullable)string;

/** 判断是否为浮点形 */
+ (BOOL)isPureFloat:(NSString *_Nullable)string;

/** 判断是否包含汉字 */
+ (BOOL)isChineseCharacters:(NSString *_Nullable)string;

/**
 判断是否是纯数字
 */
+(BOOL)isFidureNumber:(NSString*_Nullable)numer;



/**
 匹配中文，英文字母和数字及_
 */
+ (BOOL)isCNLetterNumberSymbol:(NSString *_Nullable)string;


/**
 匹配英文字母和数字
 */
+ (BOOL)isLetterNumber:(NSString *_Nullable)string;


/**
 判断身份证
 */
+ (BOOL)checkUserIdCard:(NSString *_Nullable)idCard;


/// 身份证号码性别判断 0未知，1男，2女
/// @param IDNumber 0未知，1男，2女
+ (NSInteger)genderOfIDNumber:(NSString *_Nullable)IDNumber;



/**
 判断是否有表情 (yes有表情)
 */
+ (BOOL)isContainsToEmoji:(NSString *_Nullable)string;


/**
 禁止输入表情（输入表情就为空）
 */
+ (NSString *_Nullable)disable_emoji:(NSString *_Nullable)text;

/**
 解码URLDecodedString
 */
+ (NSString *_Nullable)URLDecodedString:(NSString *_Nullable)str;


/**
 汉字转 Unicode   张三 →  \u5f20\u4e09
 */
+ (NSString *_Nullable)ChineseToUnicode:(NSString *_Nullable)chinese;


/** Unicode转中文 */
+ (NSString *_Nullable) replaceUnicode:(NSString *_Nullable)TransformUnicodeString;


/**
 编码URLEncodedString
 */
+ (NSString *_Nullable)URLEncodedString:(NSString *_Nullable)str;



/**
 头像图片base64加密
 */
+ (NSString *_Nullable)base64EncodingWithImage:(UIImage *_Nullable)image;



/**
 base64加密data数据
 */
+ (NSString *_Nullable)base64EncodingWithSourceData:(NSData *_Nullable)sourceData;



/**
 base64解密
 */
+ (NSString *_Nullable)base64DecodingWithString:(NSString *_Nullable)base64String;



/**
 从字符串(string)分割位置(segmentStr)开始取到后面的内容

 @param string 需要分割的字符串
 @param segmentStr 分割开始的位置字符串
 @return 取到的内容
 */
+ (NSString *_Nullable)getElementFromString:(NSString *_Nullable)string WithRangeSegmentString:(NSString *_Nullable)segmentStr;



/**
 给字符串第index处插入一个字符串

 @param originStr 需要更改的字符串
 @param index 插入的位置
 @param string 插入的字符串
 */
+ (NSString *_Nullable)insertElementFromString:(NSString *_Nullable)originStr insertIndex:(NSInteger)index insertString:(NSString *_Nullable)string;



/**
 添加webview加载动画
 */
+(UIActivityIndicatorView *_Nullable)addWebViewLoadingViewWithTarget:(UIViewController*_Nonnull)VC;



/**
 从字典中元素排序
 */
+ (NSArray *_Nullable)rankArrayFromDictionary:(NSDictionary *_Nullable)infoDict;



/**
 字典字母排序拼接返回字符串
 */
+ (NSString *_Nullable)orderSignStringWithDictionary:(NSDictionary *_Nullable)dict;



/**
 拨打电话
 */
+ (void)callUpWithPhoneNumber:(NSString *_Nullable)phoneNum;



/**
 复制文字并提示
 */
+ (void)copyStringToPasteBoard:(NSString *_Nonnull)string;



/**
 计算文字范围

 @param size CGSizeMake(width, CGFLOAT_MAX)
 @param string 文字内容
 @param font 文字大小
 */
+ (CGSize)boundingRectWithSize:(CGSize)size String:(NSString *_Nullable)string Font:(UIFont *_Nonnull)font;



/**
 获取文字高度

 @param string 文字内容
 @param font 大小
 @param textWidth 文字宽度（控件总宽-文字外部分）
 */
+ (CGFloat)rectTextHeightWithString:(NSString *_Nullable)string Font:(UIFont *_Nonnull)font TextWidth:(CGFloat)textWidth;



/**
 获取文字宽度

 @param string 文字内容
 @param font 大小
 @param textHeight 文字高度（控件总高-文字外部分）
 */
+ (CGFloat)rectTextWidthWithString:(NSString *_Nullable)string Font:(UIFont *_Nonnull)font TextHeight:(CGFloat)textHeight;



/**
 遍历文件夹获得文件夹大小，返回多少M

 @param folderPath 文件路径
 */
+ (float)folderSizeAtPath:(NSString *_Nullable)folderPath;



/**
 获取单个文件的大小

 @param filePath 文件路径
 */
+ (float)fileSizeAtPath:(NSString *_Nullable)filePath;




/**
 读取本地JSON文件

 @param name 文件名
 @return 返回Dictionary结果
 */
+ (id _Nullable )readLocalJsonFileWithFileName:(NSString *_Nonnull)name;



/**
 检测APP版本号

 @param appId APP在store中的id
 @param appUrl APP在store的下载地址
 */
+ (void)checkAppVersionWithAppID:(NSString *_Nullable)appId AppUrl:(NSString *_Nullable)appUrl Target:(UIViewController *_Nonnull)VC;



/**
 判断当前app版本和AppStore最新app版本大小  新版版本号比旧版版本号大返回yes

 @param newVersion 线上新版本
 @param oldVersion 老版本
 */
+ (BOOL)judgeNewVersion:(NSString *_Nullable)newVersion withOldVersion:(NSString *_Nullable)oldVersion;



/**
 价格有小数且不为0则显示几位小数 没有则显示整数
 
 @param price 价格
 */
+ (NSString *_Nonnull)formatPriceWithFloat:(float)price;



/**
 数字每三位用逗号分隔

 @param number 需改变的数字
 @param prefix 前缀 如@“￥” 没有传nil
 @param suffix 后缀 如@“元” 没有传nil
 */
+ (NSString *_Nullable)separateNumberUseCommaWithNumber:(NSString *_Nullable)number Prefix:(NSString *_Nullable)prefix Suffix:(NSString *_Nullable)suffix;




/**
 去除字符串前后空格及回车符
 
 @param string 需要修剪的字符串
 */
+ (NSString *_Nonnull)trimWhiteSpaceAndNewLine:(NSString *_Nonnull)string;



/**
 大图片缩放、压缩

 @param image 原图
 @param newSize 新尺寸清晰度
 */
+ (UIImage *_Nullable)scaleImage:(UIImage *_Nullable)image newSize:(CGSize)newSize;



/**
 大分辨率图片缩放
 */
+ (UIImage *_Nullable)scaleImageWithData:(NSData *_Nonnull)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation;



/**
 数组转成json字符串
 */
+ (NSString *_Nullable)transformToJsonStrWithArray:(NSArray *_Nullable)array;




/**
 获取颜色的rgb
 
 @return 返回数组 r g b a
 */
+ (NSArray *_Nonnull)getRGBWithColor:(UIColor *_Nonnull)color;




/**
 根据偏移量或进度获取梯度过渡颜色 在scrollViewDidScroll中调用

 @param beginColor 过渡起始颜色
 @param endColor 过渡结束颜色
 @param progress 偏移比例 0-1
 */
+ (UIColor *_Nonnull)colorGradientWithBeginColor:(UIColor *_Nonnull)beginColor EndColor:(UIColor *_Nonnull)endColor Progress:(CGFloat)progress;




/**
 给视图添加渐变色
 
 @param view 要添加渐变色的视图
 @param startColor 起始颜色
 @param endColor 结束颜色
 @param startPoint 渐变起始点
 @param endPoint 渐变结束点
 */
+ (void)colorGradientWithView:(UIView *_Nonnull)view StartColor:(UIColor *_Nonnull)startColor EndColor:(UIColor *_Nonnull)endColor StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;




/**
 给视图添加阴影
 @param view 添加阴影的视图
 @param shadowColor 阴影颜色
 */
+ (void)addShadowWithView:(UIView *_Nonnull)view shadowColor:(UIColor *_Nonnull)shadowColor;




/**
 App Store评分
 */
+ (void)AppStoreScore;


@end
