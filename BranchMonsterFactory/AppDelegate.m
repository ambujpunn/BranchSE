//
//  AppDelegate.m
//  BranchMonsterFactory
//
//  Created by Alex Austin on 9/6/14.
//  Copyright (c) 2014 Branch, Inc All rights reserved.
//

@import Branch;
#import "AppDelegate.h"
#import "MonsterPreferences.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    __block UIViewController *nextVC;
    
    // Set up Branch
    
    // enable pasteboard check for iOS 15+ only
    if (@available(iOS 15.0, *)) {
        [[Branch getInstance] checkPasteboardOnInstall];
    }
    
    [[Branch getInstance] initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary * _Nullable params, NSError * _Nullable error) {
        // do stuff with deep link data (nav to page, display content, etc)
        
        // If the key 'monster' is present in the deep link dictionary
        // then load the monster viewer with the appropriate monster parameters
        if ([params objectForKey:@"monster"]) {
            [MonsterPreferences setMonsterName:[params objectForKey:@"monster_name"]];
            [MonsterPreferences setFaceIndex:[[params objectForKey:@"face_index"] intValue]];
            [MonsterPreferences setBodyIndex:[[params objectForKey:@"body_index"] intValue]];
            [MonsterPreferences setColorIndex:[[params objectForKey:@"color_index"] intValue]];
            
            // Choose the monster viewer as the next view controller
            nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];
            
            
        // Else, the app is being opened up from the home screen or from the app store
        // Load the next logical view controller
        } else {
            
            // If a name has been saved in preferences, then this user has already created a monster
            // Load the viewer
            if (![MonsterPreferences getMonsterName]) {
                [MonsterPreferences setMonsterName:@""];
                
                // Choose the monster viewer as the next view controller
                nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterCreatorViewController"];
                
            // If no name has been saved, this user is new, so load the monster maker screen
            } else {
                nextVC = [storyboard instantiateViewControllerWithIdentifier:@"MonsterViewerViewController"];
            }
        }
        
        
        // launch the next view controller
        [navController setViewControllers:@[nextVC] animated:YES];
    }];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[Branch getInstance] application:app openURL:url options:options];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    [[Branch getInstance] continueUserActivity:userActivity];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
