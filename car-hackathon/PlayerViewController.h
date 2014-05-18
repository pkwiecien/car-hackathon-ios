//
//  PlayerViewController.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Rdio/Rdio.h>

@interface PlayerViewController : UIViewController <RDAPIRequestDelegate, RDPlayerDelegate> {
    SystemSoundID correctSoundID;
    SystemSoundID incorrectSoundID;
}

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *albumCoverImage;
- (IBAction)dislikeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonPressed;
- (IBAction)toggleLikeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)testButtonToggled:(id)sender;

@end
