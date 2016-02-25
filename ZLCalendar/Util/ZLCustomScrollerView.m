//
//  CustomScrollerView.m
//  CitroenApplication
//
//  Created by adrew on 11-9-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ZLCustomScrollerView.h"

@implementation ZLCustomScrollerView

@synthesize flag;

- (void)dealloc
{
    [super dealloc];
}


//传递touch事件
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(flag)
    {
        [[self nextResponder]touchesBegan:touches withEvent:event];

    }

    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(flag)
    {
        [[self nextResponder]touchesMoved:touches withEvent:event];

    }

    [super touchesMoved:touches withEvent:event];
}



- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(flag)
    {
        [[self nextResponder]touchesEnded:touches withEvent:event];

    }

    [super touchesEnded:touches withEvent:event];
}


//父视图是否可以将消息传递给子视图，yes是将事件传递给子视图，则不滚动，no是不传递则继续滚动
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
//    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
    //返回yes 是不滚动 scroll 返回no 是滚动scroll
    if(flag)
    {
        return YES;

    }
    else {
        return NO;
    }
}

//Yes是子视图取消继续接受touch消息（可以滚动），NO是子视图可以继续接受touch事件（不滚动）
//默认的情况下当view不是一个UIControlo类的时候，值是yes,否则是no 
//调用情况是这样的一般是在发送tracking messages消息后会调用这个函数，来判断scroll是否滚动，还是接受子视图的touch 事件
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
//    NSLog(@"用户点击的视图 %@",view);
    return NO;
} 

@end
