//
//  UtilityMacro.h
//  Pods
//
//  Created by 李雪阳 on 2021/10/11.
//


#import "UtilityCategoryHeader.h"

#ifndef UtilityMacro_h
#define UtilityMacro_h


#pragma mark - 常用尺寸宏
/** 屏幕尺寸 */
#define SCREEN_WIDTH ([UIScreen scrnSize].width)
#define SCREEN_HEIGHT ([UIScreen scrnSize].height)

/**   从横屏切换到竖屏的时候会出现[UIScreen mainScreen].bounds的高宽颠倒问题
 #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
 #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
 */

/** 获取当前屏幕的高度 applicationFrame就是app显示的区域，不包含状态栏 */
#define APP_SCREEN_WIDTH  ([UIScreen mainScreen].applicationFrame.size.width)
#define APP_SCREEN_HEIGHT ([UIScreen mainScreen].applicationFrame.size.height)

/** Window使用  以APPWINDOW为主*/
#define  APP_WINDOW  [[UIApplication sharedApplication] delegate].window
#define  KEY_WINDOW  [UIApplication sharedApplication].keyWindow

/** 判断是否是iPhone X */
#define IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)
/** 判断是否是为根页面 导航页面第一层级  */
#define IS_ROOTPAGE (([[UIViewController currentViewController].navigationController.childViewControllers indexOfObject:[UIViewController currentViewController]] == 0)?YES:NO)
/** 导航栏高度 */
#define NAVI_HEIGHT 44
/** 状态栏高度 */
#define STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define STATUS_BAR_HEIGHT  (IS_IPHONEX?44:20)
/** 导航栏+状态栏总高 */
#define STATUS_NAVI_HEIGHT  (NAVI_HEIGHT+STATUS_HEIGHT)
#define STATUS_NAVI_BAR_HEIGHT  (NAVI_HEIGHT+STATUS_BAR_HEIGHT)
/** 页面除过导航栏高度 */
#define SCREEN_WINDOW_HEIGHT (SCREEN_HEIGHT-(STATUS_HEIGHT+NAVI_HEIGHT))
//#define SCREEN_WINDOW_HEIGHT (SCREEN_HEIGHT-CGRectGetMaxY(self.navigationController.navigationBar.frame))
/** iPhone X等异形屏下HOME按键高度 */
#define IPHONEX_BOTTOM ([[UIApplication sharedApplication] statusBarFrame].size.height > 20?34:0)
/** iphoneX等异形屏下tabbar高度 */
#define TABBAR_HEIGHT ([[UIApplication sharedApplication] statusBarFrame].size.height > 20?83:49)
/** 系统tabbar高度 */
#define SYSTEM_TABBAR_HEIGHT self.tabBarController.tabBar.bounds.size.height



#pragma mark - 字符串类型转换
/** 输出类型转换 */
#define FORMATEString(Method)    ([[NSString stringWithFormat:@"%@",Method] isKindOfClass:[NSNull class]] || [[NSString stringWithFormat:@"%@",Method] isEqualToString:@"<null>"] || [[NSString stringWithFormat:@"%@",Method] isEqualToString:@"(null)"]) ? @"" : [NSString stringWithFormat:@"%@",Method]
#define FORMATEPRICE(Method)   [NSString stringWithFormat:@"%.2f",Method]
#define FORMATEInt(Method)   [NSString stringWithFormat:@"%ld",Method]
#define FORMATEFloat(Method)   [NSString stringWithFormat:@"%.2f",Method]

/** 判断空对象 */
#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])
#define isEmptyString(x)      (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"<null>"])

/** 国际化语言 */
#define InterText(text)      NSLocalizedString(text, nil)

#pragma mark - 字体相关
/** 自定义颜色 */
#define UIColorWithRGBA(r,g,b,a)                         [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UIColorWithHex(a)                                [UIColor colorWithHexString:a]
#define UIColorWithDarkAdapt(darkColor,defaultColor)     [UIColor colorWithDarkColor:darkColor defaultColor:defaultColor]
#define UIColorWithDarkColorName(colorName,defaultColor) [UIColor colorWithDarkAdaptColorName:colorName defaultColor:defaultColor]


/** 字体设置 */
#define FontRegular(font) [UIFont fontWithName:@"PingFangSC-Regular" size:font]//常规字体
#define FontSemibold(font) [UIFont fontWithName:@"PingFangSC-Semibold" size:font]//中粗体
#define FontMedium(font) [UIFont fontWithName:@"PingFangSC-Medium" size:font]//中黑体
#define FontLight(font) [UIFont fontWithName:@"PingFangSC-Light" size:font]//细体


#define FontStableRegular(font) [UIFont monospacedDigitSystemFontOfSize:font weight:UIFontWeightRegular]//宽度稳定 常规字体
#define FontStableSemibold(font) [UIFont monospacedDigitSystemFontOfSize:font weight:UIFontWeightSemibold]//宽度稳定 中粗体
#define FontStableMedium(font) [UIFont monospacedDigitSystemFontOfSize:font weight:UIFontWeightMedium]//宽度稳定 中黑体
#define FontStableLight(font) [UIFont monospacedDigitSystemFontOfSize:font weight:UIFontWeightLight]//宽度稳定 细体


/** 随机色 */
#define RandomColor UIColorWithRGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1)

/** 字体常用颜色 */
#define FONT_COLOR333  [UIColor colorWithHexString:@"333333"]
#define FONT_COLOR666  [UIColor colorWithHexString:@"666666"]
#define FONT_COLOR999  [UIColor colorWithHexString:@"999999"]
#define FONT_COLORDDD  [UIColor colorWithHexString:@"dddddd"]

#define FONT_COLOR272829   [UIColor colorWithHexString:@"272829"]
#define FONT_COLOR575757   [UIColor colorWithHexString:@"575757"]
#define FONT_COLORababab   [UIColor colorWithHexString:@"ababab"]
#define FONT_COLORf2441c   [UIColor colorWithHexString:@"F2441C"]

#define FONT_COLOR_BGF7    [UIColor colorWithHexString:@"F7F7F7"]

/** 字体大小（常规/粗体） */
#define BOLDFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define FONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]



#pragma mark - view尺寸宏
/** View 坐标(x,y)和宽高(width,height) */
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y
#define WIDTH(v)           (v).frame.size.width
#define HEIGHT(v)          (v).frame.size.height

#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度

/** 以屏幕为比例的数值   比例基准由UI使用的机型宽度为准 */
#define SCREEN_RATIO      ([UIScreen scrnSize].width/375.0)
#define RATIO(NUM)        NUM*SCREEN_RATIO

#define APP_LINE_WIDTH    ([UIScreen scrnScale] >= 3 ? 0.75 : 0.5)


#pragma mark - 图片路径、加载
/** PNG JPG 图片路径 */
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
/** 路径 */
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

/** PNG JPG 加载图片 */
#define PNGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGkImg(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kImg(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

#define UIImageName(imageName)  [UIImage imageNamed:imageName]
#define NSURLString(urlString)  [NSURL URLWithString:urlString]


#pragma mark - 获取设备
//是否Retina屏
#define IS_RETINA ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :NO)
#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONEPLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/** 是否为iPad设备 */
#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


#pragma mark - 版本信息
/** 获取bundleID */
#define APP_BUNDLE_ID  [[NSBundle mainBundle] bundleIdentifier]
/** APP的Version版本号 */
#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** APP的Build号 */
#define APP_BUILD   [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/** iOS系统版本  NSString类型*/
#define IOS_SYSTEM_VERSION  [[UIDevice currentDevice] systemVersion]
/** 当前系统语言 */
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
/** app名字 （如果发现获取到的appName为空，查看plist下以前默认创建的Bundle display name是否存在 不存在需在info.plist文件下添加 【Bundle display name   ${PRODUCT_NAME} 】） */
#define APP_NAME [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"]
/** 设备类型  返回 iPhone或当前其他设备 */
#define DEVICE_TYPE  [[UIDevice currentDevice] model]
/** 设备名称   返回通用设置里的名称 */
#define DEVICE_NAME  [[UIDevice currentDevice] name]
/** 电池电量  float */
#define ELECTRIC_POWER  [[UIDevicecurrentDevice]batteryLevel]


#pragma mark - 功能宏
/** NSUSerDefault */
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
/** MMKV */
#define MMKV_DEFAULT [MMKV defaultMMKV]
/** NSNotificationCenter */
#define NOTIFY_CENTER [NSNotificationCenter defaultCenter]

/** 通知传递、获取、删除 */
#define NOTIFY_POST(notifyName)  [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:nil]
#define NOTIFY_POST_OBJC(notifyName, notifyObjc)  [[NSNotificationCenter defaultCenter] postNotificationName:notifyName object:notifyObjc]
#define NOTIFY_ADD(SEL, notifyName)  [[NSNotificationCenter defaultCenter] addObserver:self selector:SEL name:notifyName object:nil]
#define NOTIFY_REMOVE_SELF()  [[NSNotificationCenter defaultCenter] removeObserver:self]
#define NOTIFY_REMOVE(notifyName)  [[NSNotificationCenter defaultCenter] removeObserver:self name:notifyName object:nil]

/** weak self */
#define WS(weakSelf)  __weak typeof(self) weakSelf = self;

/** class与string的转变 */
#define stringFromClass(CLASS_NAME) NSStringFromClass([CLASS_NAME class])
#define classFromString(STRING_NAME) NSClassFromString(STRING_NAME)

/** 注册collectionViewCell */
#define RegisterCollectionViewCellWithClassName(CollectionView,ClassName)    [CollectionView registerClass:[ClassName class] forCellWithReuseIdentifier:NSStringFromClass([ClassName class])]
/** 注册collectionViewHeader */
#define RegisterCollectionViewHeaderWithClassName(CollectionView,ClassName)  [CollectionView registerClass:[ClassName class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ClassName class])]
/** 注册collectionViewFooter */
#define RegisterCollectionViewFooterWithClassName(CollectionView,ClassName)  [CollectionView registerClass:[ClassName class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([ClassName class])]

/** 注册tableViewCell */
#define RegisterTableViewCellWithClassName(TableView,ClassName)           [TableView registerClass:[ClassName class] forCellReuseIdentifier:NSStringFromClass([ClassName class])]
/** 注册tableViewHeaderFooter */
#define RegisterTableViewHeaderFooterWithClassName(TableView,ClassName)   [TableView registerClass:[ClassName class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ClassName class])];


/** View 圆角及边框 */
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/** 防止按钮重复点击  kPreventRepeatClickTime(0.5); */
#define kPreventRepeatClickTime(_seconds_) \
static BOOL shouldPrevent; \
if (shouldPrevent) return; \
shouldPrevent = YES; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((_seconds_) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
shouldPrevent = NO; \
}); \


/** DLog打印 */
//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"(函数 %s) [行数 %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif

#ifdef DEBUG //打印Jason unicode转中文
#define DLog( s, ... ) printf("class: <%p %s:(第%d行) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(s), ##__VA_ARGS__] UTF8String] );
#else
#define DLog( s, ... )
#endif


//判断设备室真机还是模拟器
#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif





#endif /* UtilityMacro_h */
