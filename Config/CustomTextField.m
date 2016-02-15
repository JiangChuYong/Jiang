//
//  CustomTextField.m
//  LincKia
//
//  Created by 陈栋梁 on 15/6/27.
//  Copyright (c) 2015年 ZZ. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

//重写placeholder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

//重写光标的位置
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 10 , 0 );
}

//控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}
@end
