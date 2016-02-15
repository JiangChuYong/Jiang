//
//  UITextField+PlaceHolderSetting.m

//

#import "UITextField+PlaceHolderSetting.h"

@implementation UITextField (PlaceHolderSetting)
//设置PlaceHolder的字体大小
-(void)placeHolerFontSize:(CGFloat)fontSize{
 [self setValue:[UIFont boldSystemFontOfSize:fontSize] forKeyPath:@"_placeholderLabel.font"];
}
//设置PlaceHolder的字体颜色
-(void)placeHolerFontColor:(UIColor *)fontColor{
[self setValue:fontColor forKeyPath:@"_placeholderLabel.textColor"];
}


@end
