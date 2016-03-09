//
//  JCYCollectionCell.m
//  LincKia
//
//  Created by JiangChuyong on 16/1/11.
//  Copyright (c) 2016年 ZZ. All rights reserved.
//

#import "JCYCollectionCell.h"

@implementation JCYCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"JCYCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

@end
