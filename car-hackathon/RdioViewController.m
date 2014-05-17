//
//  RdioViewController.m
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/17/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "RdioViewController.h"

@interface RdioViewController ()

@end

@implementation RdioViewController

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
    // Do any additional setup after loading the view from its nib.
    
    RDPlayer *player = [[AppDelegate rdioInstance] player];
    [player addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
    player.delegate = self;
    // load sound fx
    CFURLRef urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("correct"), CFSTR("wav"), NULL);
    AudioServicesCreateSystemSoundID(urlRef, &correctSoundID);
    urlRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("incorrect"), CFSTR("wav"), NULL);
    AudioServicesCreateSystemSoundID(urlRef, &incorrectSoundID);
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)albumListButtonPressed:(id)sender {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"muse" forKey:@"query"];
    [params setObject:@"Artist" forKey:@"types"];
    [params setObject:[[Settings settings] userKey] forKey:@"user"];
    
    [[AppDelegate rdioInstance] callAPIMethod:@"search" withParameters:params delegate:self];
}

#pragma mark - RDPlayerDelegate
- (void)rdioPlayerChangedFromState:(RDPlayerState)oldState toState:(RDPlayerState)newState {
    NSLog(@"*** Player changed from state: %d toState: %d", oldState, newState);
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    
}

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
    NSString *song = dict[@"results"][0][@"topSongsKey"];
    [[[AppDelegate rdioInstance] player] playSource:song];
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

@end
