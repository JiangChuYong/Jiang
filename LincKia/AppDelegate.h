//
//  AppDelegate.h
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AFHTTPRequestOperationManager * manager;

@end

