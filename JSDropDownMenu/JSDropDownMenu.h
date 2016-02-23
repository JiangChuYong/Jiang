//
//  JSDropDownMenu.h
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define SpaceAlert_Green_FontColor       RGBA(37,239,164,1)
#define SpaceAlert_Gray_BGColor       RGBA(216,221,222,1)

@interface JSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger leftOrRight;
@property (nonatomic, assign) NSInteger leftRow;
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end

#pragma mark - data source protocol
@class JSDropDownMenu;

@protocol JSDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath;
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column;

/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;

/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol JSDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath;
@end

#pragma mark - interface
@interface JSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) id <JSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <JSDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, strong) UIColor *highlightColor;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath;
- (void)confiMenuWithSelectRow:(NSInteger)row leftOrRight:(NSInteger)leftOrRight;
-(void)reloadAllTableView;

@end
