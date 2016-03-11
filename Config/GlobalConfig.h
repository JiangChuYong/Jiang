//
//  GlobalConfig.h
//  LincKia
//
//#define LincTest

#define USERNAME @"userName"
#define PASSWORD @"passWord"
#define USERTOKEN @"userToken"

//分割线的颜色
#define SeparateLineColor       RGBA(240,241,242,1)

//支付账号类型
typedef enum{
    //无
    PayAccountID_NO=0,
    //支付宝
    PayAccountID_AliPay=1,
    //微信支付
    PayAccountID_WeiXin=2,
    //银联支付
    PayAccountID_UnionPay=3,
}PayAccountIDStyle;


//空间类型
typedef enum{
    //独立办公室
    SpaceType_Office=1,
    //开放办公桌
    SpaceType_ActivityRoom=2,
    //半开放办公桌
    SpaceType_Desk=3,
    //独立会议室
    SpaceType_MeetingRoom=4,
    //混合
    SpaceType_Mix=99,
}SpaceType;

typedef enum {
	//从我的订单进入，入参为OrderId
	OrderSubmitFlag_FromMyOrder = 1,
	//点击立即预定进入，入参为CartModel(AddToCartModels)
	OrderSubmitFlag_OrdersAdd = 2,
    //会议室订单进入
    OrderSubmitFlag_OrdersAddMeetingRoom = 3,
    
    FromActivitySpaceListPage = 4,
    FromOfficeListPage = 5,
    FromUnpayPage = 6,
    ModifyNickName,
    ModifyName

}OrderSubmitFlag;


//pt 和 px 的转换系数
#define PxToPtScale  2.0
// pt 和 px 转换方法
#define Px_To_Pt(x)  (x/PxToPtScale)


#define Px30_ToPt  Px_To_Pt(30)
#define Px24_ToPt  Px_To_Pt(24)
#define Px20_ToPt  Px_To_Pt(20)

//常用字号大小
#define CommonFontSize_Large   Px30_ToPt
#define CommonFontSize_Middle  Px24_ToPt
#define CommonFontSize_Small   Px20_ToPt

//常用橘色背景
#define CommonBackgroundColor_Orange  RGBA(245,182,51,1)
//常用灰色背景
#define CommonBackgroundColor_gray  RGBA(182,182,182,1)
//常用淡灰色背景
#define CommonBackgroundColor_lightGray  RGBA(214,214,214,1)
//分割线的颜色
#define SparaLineColor  RGBA(235,235,235,1)

//首页中办工作类型、我的收藏、我的支付、提交订单中的输入框中的字体颜色
#define CommonColor_Blue   RGBA(21,98,175,1)
//常见的黑色字体
#define CommonColor_Black  RGBA(1,12,23,1)
//常见的灰色字体
#define CommonColor_Gray  RGBA(122,123,124,1)
//橘红色字体
#define CommonColor_Orange  RGBA(247,187,3,1)
//红色字体
#define CommonColor_Red RGBA(199,20,27,1)
//白色字体
#define CommonColor_White [UIColor whiteColor]
//绿色字体
#define CommonColor_Green RGBA(57,181,74,1)


//优质
#define ExcellentColor  RGBA(34,193,80,1)
//良好
#define GoodColor  RGBA(246,178,0,1)
//轻度污染
#define MildConcentrationColor  RGBA(251,142,24,1)
//中度污染
#define MiddleLevelPollutionColor RGBA(199,40,35,1)
//重度污染
#define SeverePollutionColor RGBA(145,41,75,1)
//严重污染
#define SevereContaminationColor RGBA(73,19,36,1)

//登录页面字体颜色
#define Login_PlaceHolder_FontColor       RGBA(186,216,237,1)

#define Login_Btn_FontColor       RGBA(29,112,202,1)

#define Login_RegisterBtn_FontColor       RGBA(78,252,242,1)


//登录页面字体大小
#define Login_PlaceHolder_FontSize       CommonFontSize_Middle

#define Login_Btn_FontSize               CommonFontSize_Large

#define Login_RegisterBtn_FontSize       CommonFontSize_Middle

//空间类型
#define SpaceType_FontColor       RGBA(74,188,174,1)
#define SpaceAlert_Green_FontColor       RGBA(37,239,164,1)
#define SpaceAlert_Gray_BGColor       RGBA(216,221,222,1)

//支付
//未支付按钮字体颜色
#define Unpay_Btn_FontColor       RGBA(190,127,6,1)
//已支付按钮字体颜色
#define Pay_Btn_FontColor         CommonColor_Gray




//订单状态
typedef enum{
    /// 未支付
    UnPayed = 0,
    /// 已支付
    Payed = 1,
    /// 已取消
    Canceled=2,
    /// 已失效
    Invalid=3,
    /// 草稿 草稿状态不影响加入到订单
    Draft=4,
	///全部订单
	StatusAll = 5
}OrderStatus;

//支付类型
typedef enum{
    /// 上线
    Online = 0,
    /// 线下
    OffLine = 1,
    /// 未知
    Unknow = 2
}PayType;




#define SERVER_SUCCESS              0

//开始加载
#define LOAD_Start_TEXT          @"加载中..."

//无数据
#define LOAD_NoData_TEXT          @"无返回数据"

//网络异常
#define LOAD_NetError_TEXT        @"网络异常，请检查网络"

//通知
#define Login_Succeed       @"Login_Succeed"
#define PhotoUpload_Succeed       @"PhotoUpload_Succeed"
#define CartDelete_Succeed       @"CartDelete_Succeed"
#define Comment_Succeed       @"Comment_Succeed"
#define DidSelectedRow       @"DidSelectedRow"
#define EnterCommonView       @"EnterCommonView"

//key
#define kUserName       @"kUserName"
#define kPwd      @"kPwd"

//首页广告默认图片byCDL
#define Index_Ad_Default_Image       @"banner_logo.png"
//首页推荐默认图片
#define Index_Recommond_Default_Image        @"banner_logo.png"

//最热空间的默认图片
#define Space_Hot_Default_Image        @"banner_logo.png"

//最热空间的默认图片
#define Space_List_Default_Image        @"banner_logo.png"

//空间评价的默认图片
#define Space_Comment_Default_Image        @"banner_logo.png"

//空间详情Banner的默认图片
#define Space_DetailBanner_Default_Image        @"banner_logo.png"

//空间详情Facilities的默认图片
#define Space_DetailFacilities_Default_Image        @"headphoto_defaluted@3x.png"

//我的账号信息默认图片
#define Users_HeadPhoto_Default_Image        @"headphoto_defaluted@3x.png"

//空间位置图的默认图片
#define Space_Position_Default_Image        @"postion.png"

//自适应屏幕尺寸设置
#define Main_Screen_Width [[UIScreen mainScreen]applicationFrame].size.width
#define Main_Screen_Height [[UIScreen mainScreen]applicationFrame].size.height
#define ADVIEW_HEIGHT (Main_Screen_Height+20)*0.3f
