//
//  RdioViewController.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Rdio/Rdio.h>


@interface RdioViewController : UIViewController <RDAPIRequestDelegate, RDPlayerDelegate> {
    SystemSoundID correctSoundID;
    SystemSoundID incorrectSoundID;
}

- (IBAction)albumListButtonPressed:(id)sender;

@end
