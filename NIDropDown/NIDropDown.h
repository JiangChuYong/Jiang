//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDown;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender text:(NSString *)text_;
@end 

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id <NIDropDownDelegate> delegate;

-(void)hideDropDown;
- (id)initShowDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(UIView *)supView;
@end
