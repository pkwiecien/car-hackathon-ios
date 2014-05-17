//
//  AppDelegate.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/16/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Rdio/Rdio.h>
#import <FacebookSDK/FBAppCall.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
      Rdio *rdio;
}

@property (strong, nonatomic) UIWindow *window;

/**
 * For easy access to the Rdio object instance from the rest of our application.
 */
+ (Rdio*)rdioInstance;

@property (readonly) Rdio *rdio;
@end