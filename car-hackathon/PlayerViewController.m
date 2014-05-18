//
//  PlayerViewController.m
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PlayerViewController.h"
#import "UtilityManager.h"

@interface PlayerViewController ()

@property (nonatomic, strong) NSMutableArray *artistNames;
@end

@implementation PlayerViewController

static BOOL toggled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.artistNames = [[NSMutableArray alloc] initWithObjects:@"Muse", @"Editors", @"Imagine Dragons", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.playButton setImage:[UtilityManager colorImage:[UIImage imageNamed:@"PlayIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    
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
        NSString *song = dict[@"results"][0][@"topSongsKey"];
        [[[AppDelegate rdioInstance] player] playSource:song];
        [self requestSongWithId:song];
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

-(void)viewWillDisappear:(BOOL)animated {
//    RDPlayer* player = [[AppDelegate rdioInstance] player];
//    [player removeObserver:self forKeyPath:@"position"];
//    [[[AppDelegate rdioInstance] player] stop];
}


- (void)dealloc {
    RDPlayer* player = [[AppDelegate rdioInstance] player];
    [player removeObserver:self forKeyPath:@"position"];
    [player stop];
}

@end
