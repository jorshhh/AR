//
//  AppDelegate.m
//  Mario
//
//  Created by Jorge Rangel on 10/24/18.
//  Copyright © 2018 IDQR. All rights reserved.
//

#import "AppDelegate.h"
#import "ARViewController.h"
#import "SVProgressHUD.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIViewController *vc = [[ARViewController alloc] initWithNibName:@"ARViewController" bundle:nil];
    //self.navController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
    [SVProgressHUD setMaximumDismissTimeInterval:2.0];

    return YES;
}

@end
