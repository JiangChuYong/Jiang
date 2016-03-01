//
//  LinckiaSpace.h
//  LincKia
//
//  Created by JiangChuyong on 16/2/29.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinckiaSpace : NSObject
/** 当前页数*/
@property (nonatomic, assign)int Page ;
/** 每页显示记录数*/
@property (nonatomic, assign)int Rows ;
/** 排序字段*/
@property (nonatomic, strong) NSString *SortProperty;
/**排序方式 */
@property (nonatomic, strong) NSString *SortDirection;
/** 搜索内容 查询条件 包含地址或空间名称的关键字*/
@property (nonatomic, strong) NSString *Tag;
/** 位置（例：上海，上海.浦东，上海.浦东.张江）*/
@property (nonatomic, strong) NSString *District;
/** 空间单元类型*/
@property (nonatomic, strong) NSString *SpaceCellType;
/**地铁（例：9号线） */
@property (nonatomic, strong) NSString *Metro;
/** 地铁（例：人民广场）*/
@property (nonatomic, strong) NSString *Zone;
/** 单元价格区间开始 */
@property (nonatomic, assign)float SpaceCellPriceStart;
/** 单元价格区间结束 */
@property (nonatomic, assign)float SpaceCellPriceEnd;
/**距离当前（米) */
@property (nonatomic, assign) float Metre;
/** 经度*/
@property (nonatomic, assign) float Longitude ;
/** 纬度*/
@property (nonatomic, assign) float  Latitude ;
/** 是否推荐*/
@property (nonatomic, assign) BOOL IsRecommend ;
/** 是否海星客空间*/
@property (nonatomic, strong) NSString *IsLinckia;
/** 语言（cn,en）*/
@property (nonatomic, strong) NSString *language;
@end
