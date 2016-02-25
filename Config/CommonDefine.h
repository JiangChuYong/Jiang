//
//  CommonConfig.h
//  LincKia
//

//

#ifndef ZL_CommonDefine_h
#define ZL_CommonDefine_h


//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44

//StatusBar高度
#define StatusBar_HEIGHT 20

//获取屏幕宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//获取屏幕高度(除去StatusBar)
#define SCREEN_HEIGHT_NO_STATUSBAR ([UIScreen mainScreen].bounds.size.height-StatusBar_HEIGHT)

//获取屏幕宽度、高度(除去StatusBar、StatusBar)
#define SCREEN_HEIGHT_NO_STATUSBAR_NAVBAR ([UIScreen mainScreen].bounds.size.height-NavigationBar_HEIGHT-StatusBar_HEIGHT)

#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height





#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y


#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height


#define RectX(rect)                            rect.origin.x
#define RectY(rect)                            rect.origin.y
#define RectWidth(rect)                        rect.size.width
#define RectHeight(rect)                       rect.size.height


#define RectSetWidth(rect, w)                  CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)                 CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)                      CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)                      CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))


#define RectSetSize(rect, w, h)                CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)              CGRectMake(x, y, RectWidth(rect), RectHeight(rect))


//-------------------获取设备大小-------------------------

//  Application delegate
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])


//  主要单例
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define NotificationCenter                  [NSNotificationCenter defaultCenter]
#define SharedApplication                   [UIApplication sharedApplication]


#define Bundle                              [NSBundle mainBundle]

#define MainScreen                          [UIScreen mainScreen]


//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//----------------------系统----------------------------


//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

///半透明黑色
#define HalfClearColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8]

//----------------------颜色类--------------------------



//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont fontWithName:@"FZHTJW--GB1-0" size:F]


//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


#endif