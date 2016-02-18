//
//  PBIndustryViewController.h
//  LincKia
//
//  Created by 董玲 on 11/16/15.
//  Copyright © 2015 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBIndustryViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
