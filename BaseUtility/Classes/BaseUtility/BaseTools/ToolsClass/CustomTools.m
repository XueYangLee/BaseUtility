//
//  CustomTools.m
//  moneyhll
//
//  Created by 李雪阳 on 16/11/7.
//  Copyright © 2016年 浙江龙之游旅游开发有限公司. All rights reserved.
//


#import "CustomTools.h"
#import "MD5.h"
#import <StoreKit/SKStoreReviewController.h>
#import "UtilityMacro.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UtilityCategoryHeader.h"

@interface CustomTools ()

@end

@implementation CustomTools


#pragma mark 自定义文字大小及颜色
+ (NSMutableAttributedString *)labelDifferentAttributedWithText:(NSString *)lableText Section:(NSRange)sectionRange Font:(UIFont *)textFont TextColor:(UIColor *)textColor
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lableText];
    
    [attributedStr addAttribute:NSFontAttributeName value:textFont range:sectionRange];//NSMakeRange(5, lableText.length-7)
    
    if (textColor != nil)
    {
        [attributedStr addAttribute:NSForegroundColorAttributeName value:textColor range:sectionRange];
    }
    return attributedStr;
}


#pragma mark 自定义多条文字大小及颜色
+ (NSMutableAttributedString *)labelDifferentAttributedStringsWithText:(NSString *)lableText attributeStrings:(NSArray <NSString *>*)attributeStrings fonts:(NSArray <UIFont *>*)fonts textColors:(NSArray <UIColor *>*)colors{
    if (attributeStrings.count != fonts.count) {
        return nil;
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lableText];
    
    for (NSInteger i = 0; i<attributeStrings.count; i++) {
        NSArray *rangeArray=[self rangeOfAllSubstring:attributeStrings[i] withString:lableText];
        for (NSValue *value in rangeArray) {
            NSRange range=[value rangeValue];
//            NSRange range=[lableText rangeOfString:attributeStrings[i]];
            [attributedStr addAttribute:NSFontAttributeName value:fonts[i] range:NSMakeRange(range.location, range.length)];
            if (colors.count) {
                [attributedStr addAttribute:NSForegroundColorAttributeName value:colors[i] range:NSMakeRange(range.location, range.length)];
            }
        }
    }
    return attributedStr;
}


#pragma mark 自定义文字添加图片及位置
+ (NSMutableAttributedString *)labelAttachAttributedImageWithText:(NSString *)lableText image:(UIImage *)image imgX:(CGFloat)imgX imgY:(CGFloat)imgY insertIndex:(NSInteger)insertIndex{
    
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = CGRectMake(imgX, imgY, attach.image.size.width, attach.image.size.height);
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",lableText]];
    NSAttributedString *attribute = [NSAttributedString attributedStringWithAttachment:attach];
    [attributeString insertAttributedString:attribute atIndex:insertIndex];
    return attributeString;
}


#pragma mark 查找字符串中所有子串的位置
+ (NSArray *)rangeOfAllSubstring:(NSString *)substring withString:(NSString *)string {
    NSMutableArray *rangeArr = [[NSMutableArray alloc]init];
    NSString *tempString = string;
    NSInteger count = 0;
    while ([tempString containsString:substring]) {
        NSRange range = [tempString rangeOfString:substring];
        tempString = [tempString stringByReplacingCharactersInRange:range withString:@""];
        
        range = NSMakeRange(range.location + substring.length * count, range.length);
        [rangeArr addObject:[NSValue valueWithRange:range]];
        
        count++;
    }
    return [rangeArr copy];
}


#pragma mark  判断座机号
+(BOOL)isTelephoneNumber:(NSString *)telephone{

    NSString *tel = @"^(0[0-9]{2,3}/-)?([2-9][0-9]{6,7})+(/-[0-9]{1,4})?$";
    NSPredicate *regextestTel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",tel];
    return [regextestTel evaluateWithObject:telephone];
}

#pragma mark 判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
/**
     * 手机号码
     * 移动：134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、172、178、182、183、184、187、188、198
     *
     * 联通：130、131、132、145、155、156、166、175、176、185、186
     *
     * 电信：133、149、153、173、177、180、181、189、191、199
     *
        虚拟运营商
        电信：1700、1701、1702
        移动：1703、1705、1706
        联通：1704、1707、1708、1709、171
        卫星通信：1349
     */
    /**
                * 中国移动：China Mobile
                * 134(0-8)、135、136、137、138、139、147、150、151、152、157、158、159、172、178、182、183、184、187、188、198
     
     */
//    NSString * CM = @"^1(34[0-8]|3[5-9]|47|5[0127-9]|8[23478]|98)\\d{8}$";
    /**
                * 中国联通：China Unicom
                * 130、131、132、145、155、156、166、175、176、185、186
     */
//    NSString * CU = @"^1((3[0-2]|45|5[56]|166|7[56]|8[56]))\\d{8}$";
    /**
                * 中国电信：China Telecom
                * 133、149、153、173、177、180、181、189、191、199
     */
//    NSString * CT = @"^1((33|49|53|7[37]|8[019]|9[19]))\\d{8}$";
    
    NSString *MOBILE = @"^1(3[0-9]|4[56789]|5[0-9]|6[6]|7[0-9]|8[0-9]|9[189])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

#pragma mark 身份证号码性别判断 0未知，1男，2女
+ (NSInteger)genderOfIDNumber:(NSString *)IDNumber
{
      //  记录校验结果：0未知，1男，2女
    NSInteger result = 0;
    NSString *fontNumer = nil;
    
    if (IDNumber.length == 15){ // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
 
    }else if (IDNumber.length == 18){ // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    }else{ //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1){
        result = 1;
    }
    
    else if (genderNumber % 2 == 0){
        result = 2;
    }
        
    return result;
}


#pragma mark 判断邮箱是否合法
+ (BOOL)checkEmail:(NSString *)email{
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 匹配中文，英文字母和数字及_
+ (BOOL)isCNLetterNumberSymbol:(NSString *)string{
    NSString *account = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", account];
    return [pred evaluateWithObject:string];
}

#pragma mark 匹配英文字母和数字
+ (BOOL)isLetterNumber:(NSString *)string{
    NSString * regex = @"^[a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}


#pragma mark 判断是否包含汉字
+ (BOOL)isChineseCharacters:(NSString *)string {
    if (!string.length) {
        return NO;
    }
    NSString *pattern = @"[\u4e00-\u9fa5]";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (error) {
        return NO;
    }
    
    NSRange range = NSMakeRange(0, string.length);
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:range];
    
    return matches.count > 0;
}


#pragma mark 判断是否为纯数字
//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}


//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}


//判断是否是纯数字
+(BOOL)isFidureNumber:(NSString*)numer{
    
    if(![self isPureFloat:numer])
        
    {
        return NO;
    }
    return YES;
}

#pragma mark 判断身份证
+ (BOOL)checkUserIdCard:(NSString *)idCard
{
    NSString *pattern = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
    
    /* 详细判断
    //判断是否为空
    if (idCard==nil||idCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *idCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![idCardPredicate evaluateWithObject:idCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [idCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(idCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[idCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[idCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
     */
}

#pragma mark 判断是否有表情
+ (BOOL)isContainsToEmoji:(NSString *)string
{
    __block BOOL isEomji =NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring,NSRange substringRange,NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         DLog(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <=0xdbff) {
             if (substring.length >1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs -0xd800) *0x400) + (ls -0xdc00) +0x10000;
                 if (0x1d000 <= uc && uc <=0x1f77f)
                 {
                     isEomji =YES;
                 }
             }
         } else if (substring.length >1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls ==0x20e3|| ls ==0xfe0f) {
                 isEomji =YES;
             }
         } else {
             if (0x2100 <= hs && hs <=0x27ff && hs != 0x263b) {
                 isEomji =YES;
             } else if (0x2B05 <= hs && hs <=0x2b07) {
                 isEomji =YES;
             } else if (0x2934 <= hs && hs <=0x2935) {
                 isEomji =YES;
             } else if (0x3297 <= hs && hs <=0x3299) {
                 isEomji =YES;
             } else if (hs ==0xa9 || hs ==0xae || hs ==0x303d || hs ==0x3030 || hs ==0x2b55 || hs ==0x2b1c || hs ==0x2b1b || hs ==0x2b50|| hs ==0x231a ) {
                 isEomji =YES;
             }
         }
         
     }];
    return isEomji;
}

#pragma mark 禁止输入表情（输入表情就为空）//乱输字母会出错 择情而用
+ (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    return modifiedString;
}



#pragma mark 解码URLDecodedString
+ (NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

#pragma mark 汉字转 Unicode   张三 →  \u5f20\u4e09
+ (NSString *)ChineseToUnicode:(NSString *)chinese
{
    NSUInteger length = [chinese length];
    NSMutableString *unStr = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++){
        unichar _char = [chinese characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >='0'){
            [unStr appendFormat:@"%@",[chinese substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='a' && _char <= 'z'){
            [unStr appendFormat:@"%@",[chinese substringWithRange:NSMakeRange(i,1)]];
        }else if(_char >='A' && _char <= 'Z')
        {
            [unStr appendFormat:@"%@",[chinese substringWithRange:NSMakeRange(i,1)]];
        }else{
            [unStr appendFormat:@"\\u%x",[chinese characterAtIndex:i]];
        }
    }
    return unStr;
}

#pragma mark Unicode转中文
+ (NSString*) replaceUnicode:(NSString*)TransformUnicodeString{
    
    NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString*tepStr3 = [[@"\""  stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
    NSData*tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
    NSString*axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:nil];
    NSString *textStr = [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    return textStr;
}



#pragma mark 编码URLEncodedString
+ (NSString *)URLEncodedString:(NSString *)str
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)str,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}


#pragma mark 头像图片base64加密
+ (NSString *)base64EncodingWithImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

#pragma mark base64加密data数据
+ (NSString *)base64EncodingWithSourceData:(NSData *)sourceData
{
    NSString *base64ResultStr = [sourceData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64ResultStr;
}

#pragma mark base64解密
+ (NSString *)base64DecodingWithString:(NSString *)base64String// 参数为base64 加密之后的字符串
{
    // data  的 *具体数据类型看数据 eg. 视频数据，音频数据，图片数据
    NSData *base64ResultData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // eg.图片类型
    //    UIImage *image = [UIImage imageWithData:base64ResultData];
    //    DLog(@"image-------- %@", image);
    NSString *decodeStr=[[NSString alloc]initWithData:base64ResultData encoding:NSUTF8StringEncoding];
    return decodeStr;
}

#pragma mark 从字符串(string)分割位置(segmentStr)开始取到后面的内容
+ (NSString *)getElementFromString:(NSString *)string WithRangeSegmentString:(NSString *)segmentStr
{
    NSRange range=[string rangeOfString:segmentStr];
    NSString *str=[string substringFromIndex:range.length+range.location];
    return str;
}

#pragma mark 给字符串第index处插入一个字符串
+ (NSString *)insertElementFromString:(NSString *)originStr insertIndex:(NSInteger)index insertString:(NSString *)string
{
    NSMutableString *str=[[NSMutableString alloc]initWithString:originStr];
    [str insertString:string atIndex:index];
    return str;
}


#pragma mark 添加webview加载动画
+ (UIActivityIndicatorView *)addWebViewLoadingViewWithTarget:(UIViewController*)VC
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.backgroundColor = UIColorWithRGBA(232, 232, 232, 1);
    activityView.hidesWhenStopped = YES;
    activityView.bounds = CGRectMake(0, 0, VC.view.frame.size.width, VC.view.frame.size.height);
    activityView.center = CGPointMake(VC.view.frame.size.width/2, VC.view.frame.size.height/2);
    return activityView;
}


#pragma mark 从字典中元素排序(a-z)
+ (NSArray *)rankArrayFromDictionary:(NSDictionary *)infoDict
{
    NSArray *keyArray = [infoDict allKeys];
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray=[keyArray sortedArrayUsingComparator:sort];
    return resultArray;
}


#pragma mark 字典字母排序拼接返回字符串
+ (NSString *)orderSignStringWithDictionary:(NSDictionary *)dict
{
    NSArray *rankArray=[CustomTools rankArrayFromDictionary:dict];
    NSMutableString *string=[NSMutableString string];
    for (NSString *str in rankArray)
    {
        if ([dict[str] isKindOfClass:[NSString class]] || [dict[str] isKindOfClass:[NSNumber class]]) {
            [string appendString:[NSString stringWithFormat:@"%@=%@&",str,dict[str]]];
        }
    }
    NSMutableString *signStr=[NSMutableString stringWithString:[string substringWithRange:NSMakeRange(0, string.length-1)]];//截取到最后一位
    return signStr;
}


#pragma mark 打电话
+ (void)callUpWithPhoneNumber:(NSString *)phoneNum
{
    NSString *telNum=[NSString stringWithFormat:@"telprompt://%@",phoneNum];
//    CGFloat version = [[[UIDevice currentDevice]systemVersion]floatValue];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNum]];
    }
}


#pragma mark 复制文字并提示
+ (void)copyStringToPasteBoard:(NSString *)string{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
}


#pragma mark 计算文字范围
+ (CGSize)boundingRectWithSize:(CGSize)size String:(NSString *)string Font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize retSize = [string boundingRectWithSize:size
                                          options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return retSize;
}

#pragma mark 获取文字高度
+ (CGFloat)rectTextHeightWithString:(NSString *)string Font:(UIFont *)font TextWidth:(CGFloat)textWidth
{
    NSDictionary *attributes=@{NSFontAttributeName:font};
    CGSize size=[string boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return size.height;
}

#pragma mark 获取文字宽度
+ (CGFloat)rectTextWidthWithString:(NSString *)string Font:(UIFont *)font TextHeight:(CGFloat)textHeight
{
    NSDictionary *attributes=@{NSFontAttributeName:font};
    CGSize size=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, textHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    return size.width;
}


#pragma mark 遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark 单个文件的大小
+ (float)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/(1024.0*1024);
    }
    return 0;
}

#pragma mark 读取本地JSON文件
+ (id)readLocalJsonFileWithFileName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    // 对数据进行JSON格式化并返回字典形式
    id jsonData=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!jsonData || error) {
        return nil;
    }else{
        return jsonData;
    }
}

#pragma mark 检测app版本号（函数放到ViewDidAppear中）
+ (void)checkAppVersionWithAppID:(NSString *)appId AppUrl:(NSString *)appUrl Target:(UIViewController *)VC
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appId]];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//    DLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    //    解析json数据
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = json[@"results"];
    for (NSDictionary *dic in array)
    {
        newVersion = [dic valueForKey:@"version"];
    }
//    DLog(@"通过appStore获取的版本号是：%@",newVersion);
    //获取本地软件的版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *message = [NSString stringWithFormat:@"您当前的版本是V%@，发现新版本V%@，是否下载新版本？",localVersion,newVersion];
    //对比发现的新版本和本地的版本
    if ([self judgeNewVersion:newVersion withOldVersion:localVersion])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [VC presentViewController:alert animated:YES completion:nil];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];//这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。例：https://itunes.apple.com/cn/app/%E5%BF%AB%E5%87%86%E5%BA%97%E7%AE%A1%E5%AE%B6/id1257607200?l=zh&ls=1&mt=8
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:nil]];
    }
}

#pragma mark 判断当前app版本和AppStore最新app版本大小
+ (BOOL)judgeNewVersion:(NSString *)newVersion withOldVersion:(NSString *)oldVersion {
    /*
    NSArray *newArray = [newVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    NSArray *oldArray = [oldVersion componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    for (NSInteger i = 0; i < newArray.count; i ++) {
        if ([newArray[i] integerValue] > [oldArray[i] integerValue]) {
            return YES;
        } else if ([newArray[i] integerValue] < [oldArray[i] integerValue]) {
            return NO;
        } else {
            
        }
    }
    return NO;*/
    NSComparisonResult result = [newVersion compare:oldVersion options:NSNumericSearch];
    if (result==NSOrderedDescending) {//newVersion>oldVersion
        return YES;
    }else{
        return NO;
    }
}

#pragma mark 价格有小数且不为0显示几位小数 没有则显示整数
+ (NSString *)formatPriceWithFloat:(float)price {
    if (fmodf(price, 1)==0) {
        return [NSString stringWithFormat:@"%.0f",price];
    } else if (fmodf(price*10, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",price];
    } else {//如果有两位小数点
        return [NSString stringWithFormat:@"%.2f",price];
    }
}

#pragma mark 数字每三位用逗号分隔
+ (NSString *)separateNumberUseCommaWithNumber:(NSString *)number Prefix:(NSString *)prefix Suffix:(NSString *)suffix{
//    // 前缀
//    NSString *prefix = @"￥";
//    // 后缀
//    NSString *suffix = @"元";
    // 分隔符
    NSString *divide = @",";
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    if (prefix) {
        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
    }
    if (suffix) {
        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
    }
    return newNumber;
}


#pragma mark 去除字符串前后空格及回车符
+ (NSString *)trimWhiteSpaceAndNewLine:(NSString *)string{
    /*whitespaceCharacterSet 前后空格
     newlineCharacterSet 前后回车符
     whitespaceAndNewlineCharacterSet 前后空格及回车符*/
    NSString *trimStr=[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimStr;
}


#pragma mark 大图片缩放
+ (UIImage *)scaleImage:(UIImage *)image newSize:(CGSize)newSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}


#pragma mark 大分辨率图片缩放
+ (UIImage *)scaleImageWithData:(NSData *)data withSize:(CGSize)size scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    //处理大分辨率图片时，往往容易出现OOM，原因是-[UIImage drawInRect:]在绘制时，先解码图片，再生成原始分辨率大小的bitmap，这是很耗内存的。解决方法是使用更低层的ImageIO接口，避免中间bitmap产生
    CGFloat maxPixelSize=MAX(size.width, size.height);
    CGImageSourceRef sourceRef=CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    NSDictionary *options=@{(__bridge id)kCGImageSourceCreateThumbnailFromImageAlways:(__bridge id)kCFBooleanTrue,
                           (__bridge id)kCGImageSourceThumbnailMaxPixelSize:[NSNumber numberWithFloat:maxPixelSize]
                           };
    CGImageRef imageRef=CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
    UIImage *resultImage=[UIImage imageWithCGImage:imageRef scale:scale orientation:orientation];
    CGImageRelease(imageRef);
    CFRelease(sourceRef);
    
    return resultImage;
}


#pragma mark 数组转成json字符串
+ (NSString *)transformToJsonStrWithArray:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}



#pragma mark 获取颜色的rgb
+ (NSArray *)getRGBWithColor:(UIColor *)color{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    return @[@(red*255),@(green*255),@(blue*255),@(alpha)];
}

#pragma mark 根据偏移量或进度获取梯度过渡颜色
+ (UIColor *)colorGradientWithBeginColor:(UIColor *)beginColor EndColor:(UIColor *)endColor Progress:(CGFloat)progress{
    NSArray *beginColorArr=[self getRGBWithColor:beginColor];
    NSArray *endColorArr=[self getRGBWithColor:endColor];
    CGFloat red=[beginColorArr[0] floatValue] + ([endColorArr[0] floatValue] - [beginColorArr[0] floatValue]) * progress;
    CGFloat green=[beginColorArr[1] floatValue] + ([endColorArr[1] floatValue] - [beginColorArr[1] floatValue]) * progress;
    CGFloat blue=[beginColorArr[2] floatValue] + ([endColorArr[2] floatValue] - [beginColorArr[2] floatValue]) * progress;
    
    UIColor *color=[UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];

    return color;
}

#pragma mark 给视图添加渐变色
+ (void)colorGradientWithView:(UIView *)view StartColor:(UIColor *)startColor EndColor:(UIColor *)endColor StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
//    gradientLayer.frame = view.bounds;
    gradientLayer.size = view.size;
    [view.layer addSublayer:gradientLayer];
}

#pragma mark 视图添加阴影
+ (void)addShadowWithView:(UIView *)view shadowColor:(UIColor *)shadowColor{
    // shadowColor阴影颜色
    view.layer.shadowColor = shadowColor.CGColor;
    // shadowOffset阴影偏移,x向右偏移1，y向下偏移1，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOffset = CGSizeMake(1,1);
    // 阴影半径，默认3
    view.layer.shadowRadius = 4;
    // 阴影透明度，默认0
    view.layer.shadowOpacity = 0.5;
}

#pragma mark App Store评分
+ (void)AppStoreScore{
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]){
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    } else {
        NSString * scoreURL = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"AppID"];//替换为对应的APPID
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scoreURL] options:@{} completionHandler:nil];
    }
}


@end
