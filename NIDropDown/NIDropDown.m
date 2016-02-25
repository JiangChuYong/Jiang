//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
{
    int width_;
    int frmae_x;
}
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) UIView *supView;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;

- (id)initShowDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(UIView *)supView_{
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        self.supView = supView_;
        CGRect btn = b.frame;
        btn = [b.superview convertRect:b.frame toView:self.supView];
        
        
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        NSInteger a=0,length_=0;
        for (int i =0; i<self.list.count; i++)
        {
            a=[self calculationWithStringLenght:[self.list objectAtIndex:i]];
            if (a>length_)
            {
                length_=a;
            }
        }
        width_= 250;
        frmae_x =(Main_Screen_Width-width_)/2;
        self.frame = CGRectMake(frmae_x, btn.origin.y+btn.size.height, width_, 0);
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width_, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        float height_=*height;
        if (arr.count*40<*height)
        {
            height_ = arr.count*40;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        self.frame = CGRectMake(frmae_x, btn.origin.y+btn.size.height, width_, height_);
        table.frame = CGRectMake(0, 0, width_, height_);
        [UIView commitAnimations];
        
        [self.supView addSubview:self];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown{
    CGRect btn = [self.btnSender.superview convertRect:self.btnSender.frame toView:self.supView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(frmae_x, btn.origin.y+btn.size.height, width_, 0);
    table.frame = CGRectMake(0, 0, width_, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}   


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version>=7.0)
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    
    
//    [btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    [self myDelegate:c.textLabel.text];
}

- (void) myDelegate:(NSString *)text{
    [self.delegate niDropDownDelegateMethod:self text:text];
}

//计算字符串长度 by nwk
-(NSUInteger) calculationWithStringLenght:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";		//（一个汉字相当于两个字符）
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
    
}
@end
