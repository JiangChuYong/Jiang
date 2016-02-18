//
//  LincKia
//
//  Created by Phoebe on 16/2/15.
//  Copyright © 2016年 Phoebe. All rights reserved.
//

#import "MemberPageViewController.h"
#import "LoginViewController.h"

@interface MemberPageViewController ()

@end

@implementation MemberPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self performSegueWithIdentifier:@"MemberToLogin" sender:self];
    
}



@end
