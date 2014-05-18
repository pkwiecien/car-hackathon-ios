//
//  PlayerViewController.m
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PlayerViewController.h"
#import "UtilityManager.h"
#import "PlayerDetailsViewController.h"
#import "Track.h"

@interface PlayerViewController ()

@property (nonatomic, strong) NSMutableArray *trackHistory;
@property (nonatomic, strong) NSMutableArray *tracks;

@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *song;
@property (strong, nonatomic) NSString *genre;

@end

@implementation PlayerViewController

static BOOL toggled;
static BOOL isPlayed;
static BOOL isPlaying;
static BOOL dontStopPlayer;
static BOOL detailsViewVisible;
static int currentTrack;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.trackNames = [[NSMutableArray alloc] initWithObjects:@"Sail", @"Starlight", @"Madness", nil];
        self.trackHistory = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.playButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"PlayIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    toggled = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tracks = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated {
    self.title = @"Driving";
    if(!detailsViewVisible) {
        RDPlayer *player = [[AppDelegate rdioInstance] player];
        [player addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
        player.delegate = self;
        // load sound fx
        CFURLRef urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("correct"), CFSTR("wav"), NULL);

        self.navigationController.navigationBar.barTintColor = [UIColor customGray];

        AudioServicesCreateSystemSoundID(urlRef, &correctSoundID);
        urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("incorrect"), CFSTR("wav"), NULL);
        AudioServicesCreateSystemSoundID(urlRef, &incorrectSoundID);
        self.navigationController.navigationBarHidden = NO;
        // [self fetchSong];
        self.playButton.layer.cornerRadius = 60;
        [self.dislikeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"DislikeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"LikeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        toggled = NO;
        isPlayed = NO;
        isPlaying = NO;
        
        [self.albumCoverImage setUserInteractionEnabled:YES];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        
        // Setting the swipe direction.
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        swipeLeft.delegate = self;
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        swipeRight.delegate = self;
        
        // Adding the swipe gesture on image view
        [self.albumCoverImage addGestureRecognizer:swipeLeft];
        [self.albumCoverImage addGestureRecognizer:swipeRight];
        
        [self fetchSongs];
        currentTrack = 0;
    } else {
        detailsViewVisible = NO;
        dontStopPlayer = NO;
    }
}

-(void)fetchSongs {
    for (NSString *trackName in self.trackNames) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:trackName forKey:@"query"];
        [params setObject:@"Track" forKey:@"types"];
        [params setObject:[[Settings settings] userKey] forKey:@"user"];
        [[AppDelegate rdioInstance] callAPIMethod:@"search" withParameters:params delegate:self];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        [self playNextTrack];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
//        if ([self.trackHistory count] > 0) {
//            [self.trackHistory removeLastObject];
//            NSString *lastTrackId = [self.trackHistory lastObject];
//            //[self playTrackWithId:lastTrackId];
//        }
    }
}

#pragma mark - RDPlayerDelegate
- (void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    NSLog(@"*** Player changed from state: %d toState: %d", oldState, newState);
    //[self playTrackWithId:[[self.tracks objectAtIndex:(currentTrack-1)] trackId]];
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    
}

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    if (data != nil && [data objectForKey:@"results"]) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
        if (dict ==  nil || [dict[@"results"] count] == 0) {
            return;
        }
        
        Track *newTrack = [[Track alloc] init];
        if ([dict[@"results"][0] objectForKey:@"icon400"]) {
            newTrack.albumUrl = dict[@"results"][0][@"icon400"];
        }
        if ([dict[@"results"][0] objectForKey:@"key"]) {
            newTrack.trackId = dict[@"results"][0][@"key"];
        }
        if ([dict[@"results"][0] objectForKey:@"artist"]) {
            newTrack.artist = dict[@"results"][0][@"artist"];
        }
        if ([dict[@"results"][0] objectForKey:@"album"]) {
            newTrack.album = dict[@"results"][0][@"album"];
        }

        [self.tracks addObject:newTrack];
    }
}

-(void)requestSongWithId:(NSString *)trackId {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:trackId forKey:@"keys"];
    [params setObject:[[Settings settings] userKey] forKey:@"user"];
    [[AppDelegate rdioInstance] callAPIMethod:@"get" withParameters:params delegate:self];
}

- (BOOL)rdioIsPlayingElsewhere {
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    RDPlayer *player = [[AppDelegate rdioInstance] player];
    if([keyPath isEqualToString:@"position"]) {
        if(player.position > 0 ) {
        }
        if(player.position >= 29.8) {
            // don't let the player go beyond 30 seconds
        }
    }
}

- (IBAction)dislikeButtonPressed:(id)sender {
    [self playNextTrack];
    [self untoggleLikeButton];
}

-(void)fetchSong {
    
    NSInteger randomNumber = arc4random() % [self.trackNames count];
    NSString *artist = [self.trackNames objectAtIndex:randomNumber];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:artist forKey:@"query"];
    [params setObject:@"Track" forKey:@"types"];
    [params setObject:[[Settings settings] userKey] forKey:@"user"];
    
    [[AppDelegate rdioInstance] callAPIMethod:@"search" withParameters:params delegate:self];
    
}
- (IBAction)toggleLikeButton:(id)sender {
    if (toggled) {
        [self.likeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"LikeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    } else {
        [self.likeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"LikeIcon"] withColor:[UIColor greenColor]] forState:UIControlStateNormal];
    }
    toggled = !toggled;
}

-(void)playCurrentTrack {
    if (self.tracks == nil || [self.tracks count] == 0) {
        return;
    }
    Track *newTrack = [self.tracks objectAtIndex:currentTrack];
    [[[AppDelegate rdioInstance] player] playSource:newTrack.trackId];
    NSURL *url = [NSURL URLWithString:newTrack.albumUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.albumCoverImage.image = [[UIImage alloc] initWithData:data];
}

-(void)playNextTrack {
    currentTrack++;
    if ([self.tracks count] == 0) {
        return;
    }
    if (currentTrack >= [self.tracks count]) {
        currentTrack = 0;
    }
    Track *newTrack = [self.tracks objectAtIndex:currentTrack];
    [[[AppDelegate rdioInstance] player] playSource:newTrack.trackId];
    NSURL *url = [NSURL URLWithString:newTrack.albumUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.albumCoverImage.image = [[UIImage alloc] initWithData:data];
}

-(void)playTrackWithId:(NSString *)trackId {
    isPlaying = YES;
    [[[AppDelegate rdioInstance] player] playSource:trackId];
    [self.trackHistory addObject:trackId];
   // [self requestSongWithId:trackId];
    
    for (NSString *track in self.trackHistory) {
        NSLog(@"Track %@", track);
    }
    [self untoggleLikeButton];
}

-(void)untoggleLikeButton {
    toggled = NO;
    [self.likeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"LikeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated {
    if(!dontStopPlayer) {
        RDPlayer* player = [[AppDelegate rdioInstance] player];
        [player removeObserver:self forKeyPath:@"position"];
        [[[AppDelegate rdioInstance] player] stop];
        dontStopPlayer = NO;
    }
}

- (IBAction)detailsButtonPressed:(id)sender {
    dontStopPlayer = YES;
    detailsViewVisible = YES;
    PlayerDetailsViewController *detailsVC = [[PlayerDetailsViewController alloc] init];
    detailsVC.artist = [[self.tracks objectAtIndex:currentTrack] artist];
    detailsVC.album = [[self.tracks objectAtIndex:currentTrack] album];
    detailsVC.song = [self.trackNames objectAtIndex:currentTrack];
    
    [self presentViewController:detailsVC animated:YES completion:nil];
}

- (IBAction)playButtonPressed:(id)sender {
    if (isPlayed) {
        [[[AppDelegate rdioInstance] player] stop];
        [self.playButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"PlayIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    } else {
        [self playCurrentTrack];
        [self.playButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"StopIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
    isPlayed = !isPlayed;
}

@end
