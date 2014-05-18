//
//  MainViewController.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "AppDelegate.h"
#import <Rdio/Rdio.h>
#import "Reachability.h"
#import "RDQConstants.h"
#import "RdioViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GracenoteMusicID/GNSearchResultReady.h>
#import <GracenoteMusicID/GNOperationStatusChanged.h>
#import "EAIntroView.h"

#import "Constants.h"
@protocol DeezerAudioPlayerDelegate;
@protocol DeezerSessionConnectionDelegate;
@protocol DeezerSessionRequestDelegate;
@protocol RDAuthDelegate;

@class Reachability;
@class GNConfig;

typedef enum
{
	SearchTypeRecognizeFromMic,
	SearchTypeRecognizeFromPCM,
    SearchTypeRecognizeStream,
	SearchTypeRecognizeFromFile,
	SearchTypeLyricFragment,
	SearchTypeFingerprint,
	SearchTypeFetchByTrackId,
	SearchTypeText,
	SearchTypeAlbumId,
	SearchTypeNone
} SearchType;


@interface MainViewController : UIViewController <RdioDelegate, UIAlertViewDelegate, FBLoginViewDelegate, GNSearchResultReady, GNOperationStatusChanged, EAIntroDelegate> {
    Reachability* netReachable;
    Reachability* hostReachable;
    BOOL hasConnection;
    NSString *userToken;
    
    IBOutlet UIActivityIndicatorView* activityIndicator;
    GNConfig *m_config;
}

@property (nonatomic, readonly) long trackDuration;
@property (nonatomic, assign)   float progress;
@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;
@property (nonatomic) FBLoginView *loginView;
@property (nonatomic, retain) GNConfig *config;
@property (nonatomic, readonly) SearchType searchType;
@property (weak, nonatomic) IBOutlet UIButton *iTunesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *musicTypesIndicator;
@property (weak, nonatomic) IBOutlet UITextView *fbLoggedLabel;
@property (weak, nonatomic) IBOutlet UITextView *selectExplanationTextView;
@property (weak, nonatomic) IBOutlet UIImageView *iTunesIcon;

- (void)presentLoginModal;
- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message;
- (void)checkNetworkStatus:(NSNotification*)notif;
- (void)updateUIAfterConnectivityCheck;
- (void)promptForRdioAuth;

- (IBAction)goToRdioButtonPressed:(id)sender;
- (IBAction)goToDasboardButtonPressed:(id)sender;

@end
