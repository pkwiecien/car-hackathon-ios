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

@interface PlayerViewController ()

@property (nonatomic, strong) NSMutableArray *artistNames;
@property (nonatomic, strong) NSMutableArray *trackHistory;
@end

@implementation PlayerViewController

static BOOL toggled;
static BOOL isPlayed;
static BOOL dontStopPlayer;
static BOOL detailsViewVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.artistNames = [[NSMutableArray alloc] initWithObjects:@"Muse", @"Editors", @"Imagine Dragons", nil];
        self.trackHistory = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.playButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"PlayIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated {
    self.title = @"Driving";
    if(!detailsViewVisible) {
        RDPlayer *player = [[AppDelegate rdioInstance] player];
        [player addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
        player.delegate = self;
        // load sound fx
        CFURLRef urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("correct"), CFSTR("wav"), NULL);
        AudioServicesCreateSystemSoundID(urlRef, &correctSoundID);
        urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("incorrect"), CFSTR("wav"), NULL);
        AudioServicesCreateSystemSoundID(urlRef, &incorrectSoundID);
        self.navigationController.navigationBarHidden = NO;
        [self fetchSong];
        self.playButton.layer.cornerRadius = 60;
        [self.dislikeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"DislikeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"LikeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        toggled = NO;
        isPlayed = YES;
        
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
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped)];
        tapGesture.delegate = self;
        [tapGesture setNumberOfTapsRequired:1];
        [[self albumCoverImage] addGestureRecognizer:tapGesture];
    } else {
        detailsViewVisible = NO;
        dontStopPlayer = NO;
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        [self fetchSong];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        if ([self.trackHistory count] > 0) {
            [self.trackHistory removeLastObject];
            NSString *lastTrackId = [self.trackHistory lastObject];
            [self playTrackWithId:lastTrackId];
        }
    }
}

-(void)tapGestureTapped {
    if (isPlayed) {
        [[[AppDelegate rdioInstance] player] stop];
        [self.playButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"StopIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    } else {
        [[[AppDelegate rdioInstance] player] play];
        [self.playButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"PlayIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    }
    isPlayed = !isPlayed;
}

#pragma mark - RDPlayerDelegate
- (void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    NSLog(@"*** Player changed from state: %d toState: %d", oldState, newState);
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    
}

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    if (data != nil && [data objectForKey:@"results"]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
        NSString *trackId = dict[@"results"][0][@"topSongsKey"];
        [self playTrackWithId:trackId];
    } else {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
        for (NSString * key in dict) {
            NSString *coverUrl = dict[key][@"tracks"][0][@"icon400"];
            NSURL *url = [NSURL URLWithString:coverUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.albumCoverImage.image = [[UIImage alloc] initWithData:data];
        }
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
    [self fetchSong];
    [self untoggleLikeButton];
}

-(void)fetchSong {
    NSInteger randomNumber = arc4random() % [self.artistNames count];
    NSString *artist = [self.artistNames objectAtIndex:randomNumber];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:artist forKey:@"query"];
    [params setObject:@"Artist" forKey:@"types"];
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

-(void)playTrackWithId:(NSString *)trackId {
    [[[AppDelegate rdioInstance] player] playSource:trackId];
    [self.trackHistory addObject:trackId];
    [self requestSongWithId:trackId];
    
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
    PlayerDetailsViewController *testVC = [[PlayerDetailsViewController alloc] init];
    [self presentViewController:testVC animated:YES completion:nil];
}

@end
