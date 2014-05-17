//
//  MainViewController.m
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "MainViewController.h"
#import <FacebookSDK/FBGraphUser.h>
#import <GracenoteMusicID/GNConfig.h>
#import <GracenoteMusicID/GNConfig.h>
#import <GracenoteMusicID/GNUtil.h>
#import <GracenoteMusicID/GNSearchResult.h>
#import <GracenoteMusicID/GNSearchResponse.h>
#import <GracenoteMusicID/GNOperations.h>
#import <GracenoteMusicID/GNStatus.h>
#import <GracenoteMusicID/GNCoverArt.h>
#import <GracenoteMusicID/GNDescriptor.h>


@interface MainViewController ()

@property(nonatomic, retain) NSString *MUSIC_LIKE;
@property(nonatomic, retain) NSMutableArray *bands;
@property(nonatomic, retain) NSMutableDictionary *likedGenres;
@property(nonatomic, assign) int artistsTotal;
@property(nonatomic, assign) int artistsAnalyzed;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
               
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Home";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    netReachable = [Reachability reachabilityForInternetConnection];
    [netReachable startNotifier];
    hostReachable = [Reachability reachabilityWithHostName:RDIO_WEB_HOST];
    [hostReachable startNotifier];
    
    NSString* savedToken = [[Settings settings] accessToken];
    if(savedToken != nil) {
        
        /**
         * We've got an access token so let's authorize with it so we can make API requests that require user authentication.
         */
        [[AppDelegate rdioInstance] authorizeUsingAccessToken:savedToken fromController:self];
    }

    self.loginView = [[FBLoginView alloc] initWithFrame:CGRectMake(0, 200, 300, 100)];
    self.loginView.readPermissions = @[@"user_likes", @"user_about_me", @"user_actions.music", @"user_activities"];
    self.loginView.delegate = self;
    [self.view addSubview:self.loginView];
    
    self.MUSIC_LIKE = @"Musician/band";
    self.bands = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
    
    //the GN stuff
    self.config = [GNConfig init:@"11493376-2587743DFEA005B0AC22F8C40DB8A4AB"];
    
    //TODO : either like this or from NSUser defaults
    self.likedGenres = [[NSMutableDictionary alloc] init];
    self.artistsTotal = 0;
    self.artistsAnalyzed = 0;
    
}

- (void)NetworkStatus:(NSNotification *)notif {
    [netReachable stopNotifier];
    [hostReachable stopNotifier];
    
    hasConnection = YES;
    
    NetworkStatus netStatus = [netReachable currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            hasConnection = NO;
            break;
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus) {
        case NotReachable:
            hasConnection = NO;
            break;
    }
    [self updateUIAfterConnectivityCheck];
}


- (void)checkNetworkStatus:(NSNotification *)notif {
    [netReachable stopNotifier];
    [hostReachable stopNotifier];
    
    hasConnection = YES;
    
    NetworkStatus netStatus = [netReachable currentReachabilityStatus];
    switch (netStatus) {
        case NotReachable:
            hasConnection = NO;
            break;
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus) {
        case NotReachable:
            hasConnection = NO;
            break;
    }
    [self updateUIAfterConnectivityCheck];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressed:(id)sender {
    
 }


- (void)deezerDidLogin {
    }

- (void)searchArtist:(NSString*)artistName {
}

- (void)bufferProgressChanged:(float)bufferProgress {
    
}

- (void)bufferDidFailWithError:(NSError*)error {
    //    NSLog(@"[Debug][DeezerAudioPlayer] bufferDidFailWithError -> error %@", error);
}

- (void)trackDurationDidChange:(long)trackDuration {
    
}



- (void) presentLoginModal {
    /**
     * Display the login modal so the user can log in.
     */
    [[AppDelegate rdioInstance] authorizeFromController:self];
}

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [av show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /**
     * Make sure we are sent delegate messages.
     */
    [[AppDelegate rdioInstance] setDelegate:self];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /**
     * Don't send us any delegate messages.
     */
    [[AppDelegate rdioInstance] setDelegate:nil];
}

#pragma mark -
#pragma mark RdioDelegate methods
/**
 * The user has successfully authorized the application, so we should store the access token
 * and any other information we might want access to later.
 */

/**
 * Authentication failed so we should alert the user.
 */
- (void)rdioAuthorizationFailed:(NSString *)message {
    NSLog(@"Rdio authorization failed: %@", message);
}

- (void)promptForRdioAuth {
    if ([[Settings settings] user] == nil) {
        UIAlertView* av = [[UIAlertView alloc] initWithTitle:RDIO_CONNECT_ALERT_TITLE
                                                     message:RDIO_CONNECT_ALERT_MSG
                                                    delegate:self
                                           cancelButtonTitle:RDIO_CONNECT_NEG_BUTTON
                                           otherButtonTitles:RDIO_CONNECT_POS_BUTTON, nil];
        [av show];
    }
}

- (void)updateUIAfterConnectivityCheck {
    [activityIndicator stopAnimating];
    if (hasConnection) {
        [self promptForRdioAuth];
    }
    else {
        [self showAlertWithTitle:@"Connection Required" message:@"In order to play Guess the Artist you must have a WiFi or 3G connection."];
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void) alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        [self presentLoginModal];
    }
}

#pragma mark -
#pragma mark RdioDelegate
- (void)rdioDidAuthorizeUser:(NSDictionary *)user withAccessToken:(NSString *)accessToken {
    [[Settings settings] setUser:[NSString stringWithFormat:@"%@ %@", [user valueForKey:@"firstName"], [user valueForKey:@"lastName"]]];
    [[Settings settings] setAccessToken:accessToken];
    [[Settings settings] setUserKey:[user objectForKey:@"key"]];
    [[Settings settings] setIcon:[user objectForKey:@"icon"]];
    [[Settings settings] save];
    [activityIndicator stopAnimating];
}

- (IBAction)goToRdioButtonPressed:(id)sender {
    RdioViewController *rdioVC = [[RdioViewController alloc] init];
    [self.navigationController pushViewController:rdioVC animated:YES];
}

#pragma mark -
#pragma mark RDAPIRequestDelegate
/**
 * Our API call has returned successfully.
 * the data parameter can be an NSDictionary, NSArray, or NSData
 * depending on the call we made.
 *
 * Here we will inspect the parameters property of the returned RDAPIRequest
 * to see what method has returned.
 */
- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
    NSString *song = dict[@"results"][0][@"topSongsKey"];
    
    [[[AppDelegate rdioInstance] player] playSource:song];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    RDPlayer *player = [[AppDelegate rdioInstance] player];
    if([keyPath isEqualToString:@"position"]) {
        if(player.position > 0) {
            [activityIndicator stopAnimating];
        }
        if(player.position >= 29.8) {
            // don't let the player go beyond 30 seconds
        }
    }
}



// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [[NSUserDefaults standardUserDefaults] setObject:user.objectID forKey:@"facebookID"];
    //TODO : with nsuserdefaults
    //    if (self.artistsAnalyzed !=0 ) {
    //            [self getMusicLikes];
    //    }
    [self getMusicLikes];
    
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookID"];
}

- (void) getMusicLikes{
    [FBRequestConnection startWithGraphPath:@"me/music"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  //// Sucess! Include your code to handle the results here
                                  //NSLog(@"user likes: %@", result);
                                  NSArray *myLikes = (NSArray*)[result data];
                                  //NSLog(@"user likes: %@", myLikes);
                                  [self saveMusicLikes:myLikes];
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                              }
                          }];
    
}
- (void) saveMusicLikes: (NSArray *)likes {
    //initialize search by text operation and make the references between classes
    self.artistsTotal = [likes count];
    for (NSDictionary *musicLike in likes){
        if ([[musicLike objectForKey:@"category"] isEqualToString:self.MUSIC_LIKE]) {
            NSLog(@"%@", [musicLike objectForKey:@"name"]);
            NSString *likedArtist = [musicLike objectForKey:@"name"];
            [self.bands addObject:likedArtist];
            
            [GNOperations searchByText:self
                                config:self.config
                                artist:likedArtist
                            albumTitle:nil
                            trackTitle:nil];
        }
    }
    NSLog(@"%bands : @", self.bands);
    
    //after getting music likes go one by one and get genres
}

// Invoked when results from a search operation are ready, or before an operation begins
- (void) reportSearchResults:(NSString*)message result:(GNSearchResponse*)result
{
    NSArray *albumGenres = result.albumGenre;
    for (GNDescriptor *genreDescriptor in albumGenres) {
        NSString *genreName = genreDescriptor.itemData;
        NSString *genreID = genreDescriptor.itemId;
        NSMutableArray *genreValue;
        genreValue = [self.likedGenres objectForKey:genreName];
        if (genreValue == nil) {
            genreValue = [[NSMutableArray alloc] init];
            [genreValue addObject:genreID];
            [genreValue addObject:[NSNumber numberWithInt:1]];
        } else {
            int previousLikes = [[genreValue objectAtIndex:1] intValue];
            previousLikes++;
            [genreValue removeObjectAtIndex:1];
            [genreValue addObject:[NSNumber numberWithInt:previousLikes]];
        }
        [self.likedGenres setObject:genreValue forKey:genreName];
        NSLog(@"Genre name: %@", genreName);
    }
    
    self.artistsAnalyzed++;
    if (self.artistsAnalyzed == self.artistsTotal) {
        [self genresEvaluationCompleted];
    }
}

- (void ) genresEvaluationCompleted {
    
    NSArray *orderedKeysArray;
    
    orderedKeysArray = [self.likedGenres keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        NSMutableArray *arr1 = (NSMutableArray *)obj1;
        NSMutableArray *arr2 = (NSMutableArray *)obj2;
        
        if ([[arr1 objectAtIndex:1] integerValue] < [[arr2 objectAtIndex:1] integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([[arr1 objectAtIndex:1] integerValue] > [[arr2 objectAtIndex:1] integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSLog(@"Genres analyze completed %@", self.likedGenres);
    
}
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void) GNResultReady:(GNSearchResult*)result
{
	NSString *statusString = nil;
	NSArray *responses = nil;
	
	if ([result isFailure]) {
		statusString = [NSString stringWithFormat:@"[%d] %@", result.errCode, result.errMessage];
	} else {
		if ([result isAnySearchNoMatchStatus]) {
			statusString = [NSString stringWithFormat:@"%NO_MATCH"];
		} else {
			// A search might return 1 best match, or 1 to N responses
			responses = [result responses];
			statusString = [NSString stringWithFormat:@"Found %lu", (unsigned long)[responses count]];
		}
	}
    
    
	//TODO : notify the view controller
    [self reportSearchResults:statusString result:[result bestResponse] ];
	return;
}

// Invoked by GNSDK in the main thread when an incremental status update is ready.
// An operation that records from the microphone will generate a "recording" status
// message that indicate the percentage done WRT the amount of audio needed to
// generate an MIDStream fingerprint.

- (void) GNStatusChanged:(GNStatus*)status
{
	NSString *msg;
    
	//if (status.status == /*GNStatusEnum*/ LISTENING) {
	//msg = [NSString stringWithFormat:@"%@ %d%@", status.message, status.percentDone, @"%"];
	//} else {
	msg = status.message;
	//}
    
	//[self.viewController setStatus:msg showStatusPrefix:TRUE];
}

// This method will be defined in the subclass

- (NSString*) operationName
{
    return nil;
}

// This method will be defined in the subclass

-(SearchType)searchType
{
	return SearchTypeNone;
}

- (IBAction)facebookButtonPressed:(id)sender {
}




@end