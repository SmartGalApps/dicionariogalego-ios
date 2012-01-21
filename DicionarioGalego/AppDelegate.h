//
//  AppDelegate.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DefineViewController.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    DefineViewController *defineViewController;
    ViewController *viewController;
}

@property (strong, nonatomic) DefineViewController *defineViewController;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIWindow *window;

@end
