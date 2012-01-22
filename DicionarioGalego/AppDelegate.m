//
//  AppDelegate.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "AppDelegate.h"
#import "DefineViewController.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize defineViewController;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

/*
 * Para integración
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // O termo a buscar
    NSString *term = [[url absoluteString] substringFromIndex:9];
    
    // Primeira vez que se arranca a integración
    if (self.defineViewController == nil)
    {
        // Creo o ViewController do storyboard
        DefineViewController *theDefineViewController = [[[[self window] rootViewController] storyboard] instantiateViewControllerWithIdentifier:@"DefineViewController"];

        // Gárdoo para futuros usos e asigno o termo a buscar
        self.defineViewController = theDefineViewController;
        self.defineViewController.termFromIntegration = term;
    }
    else
    {
        // Asigno o termo a buscar e busco (non se vai chamar a viewDidLoad, que é onde se conecta ao servidor a primeira vez)
        self.defineViewController.termFromIntegration = term;
        [self.defineViewController grabURLInBackground:self];
    }

    // Creo a pantalla principal para metela no UINavigationController
    if (self.viewController == nil)
    {
        ViewController *theViewController = [[[[self window] rootViewController] storyboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        
        // Gárdoo para futuros usos
        self.viewController = theViewController;
    } 

    // Creo o UINavigationController
    UINavigationController *mainViewNavController = [[UINavigationController alloc] init];
    
    // Engado os ViewControllers ao navigator
    if (viewController != nil)
    {
        [mainViewNavController pushViewController:viewController animated:FALSE];
    }
    
    if (self.defineViewController != nil)
    {
        [mainViewNavController pushViewController:self.defineViewController animated:FALSE];
    }

    // Amosar
    [self.window setRootViewController:mainViewNavController];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
