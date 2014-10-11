//
//  AppDelegate.h
//  AdUnityToolbox
//
//  Created by APPLE on 9/5/14.
//  Copyright (c) 2014 GankoTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"

#import <Chartboost/Chartboost.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,ChartboostDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property(nonatomic, strong) id<GAITracker> tracker;
@end
