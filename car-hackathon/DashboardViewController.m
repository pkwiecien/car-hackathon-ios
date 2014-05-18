//
//  DashboardViewController.m
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "DashboardViewController.h"
#import "SettingsViewController.h"
#import "UtilityManager.h"
#import "PlayerViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController {
    NSArray *genreImageViews;
    NSArray *genreLabels;
    NSArray *genreViews;
    int currentTile;
    int currentImageCounter;
    }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Carbeats";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:26/256 green:26/256 blue:26/256 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame=CGRectMake(0,0,30,30);
    UIImage *settingsImage = [UtilityManager colorImage:[UIImage imageNamed: @"SettingsIcon"] withColor:[UIColor whiteColor]];
    [button setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationController.navigationBarHidden = NO;
    self.topLeftView.layer.cornerRadius = 4.0;
    self.topRightView.layer.cornerRadius = 4.0;
    self.bottomLeftView.layer.cornerRadius = 4.0;
    self.bottomRightView.layer.cornerRadius = 4.0;
    
    genreImageViews = [[NSArray alloc] initWithObjects:self.mainImageView ,self.topLeftImageView, self.topRightImageView, self.bottomLeftImageView, self.bottomRightImageView, nil];
    genreLabels = [[NSArray alloc] initWithObjects:self.mainGenreName, self.topLeftGenreName, self.topRightGenreName, self.bottomLeftGenreName, self.bottomRightGenreName, nil];
    
    genreViews = [[NSArray alloc] initWithObjects:self.topLeftView, self.topRightView, self.bottomLeftView, self.bottomRightView, nil];
    
    //TODO : mock from Raza
    [self addGestureRecognizers];
    [self displayGenres];
    
}

- (void) fetchAlbumCover: (NSString *) artist{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:artist forKey:@"query"];
    [params setObject:@"album" forKey:@"types"];
    //[params setObject:[[Settings settings] userKey] forKey:@"user"];
    [[AppDelegate rdioInstance] callAPIMethod:@"search" withParameters:params delegate:self];
}

- (void) displayGenres {
    //display the fetched genres
    
    //all the genres are in self.currentContext.genres
    //for each (distinct) genre, get one artist and populate the tiles
    currentTile = 0;
    currentImageCounter = 0;
    for(id key in self.currentContext.genres) {
        NSString* artist = [self.currentContext.genres objectForKey:key];
        [self fetchAlbumCover:artist];
        UILabel *currentLabel = (UILabel *)[genreLabels objectAtIndex:currentTile];
        currentLabel.text = (NSString*) key;
        currentLabel.hidden = FALSE;
        UIView *currentView = (UIView*)[genreViews objectAtIndex:currentTile];
        currentView.hidden = FALSE;
        currentTile++;
    }
}

- (void) fillEmptyGenreTile:(UIImageView*)imageView withAlbum:(NSString*)album {
    
}
-(void)tapGestureTapped {
    if(self.topLeftView.backgroundColor == [UIColor whiteColor]) {
        self.topLeftView.backgroundColor = [UIColor customOrange];
    } else
        self.topLeftView.backgroundColor = [UIColor whiteColor];
}

-(void)rightBarButtonItemPressed {
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}


- (IBAction)mainButtonPressed:(id)sender {
    PlayerViewController *playerVC = [[PlayerViewController alloc] init];
    playerVC.trackNames = [self.currentContext.tracks copy];
    [self.navigationController pushViewController:playerVC animated:YES];
}


-(void)addGestureRecognizers {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped)];
    tapGesture.delegate = self;
    [tapGesture setNumberOfTapsRequired:1];
    [[self topLeftView] addGestureRecognizer:tapGesture];
    
    // sorry for copying but it's the quickest
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped2)];
    tapGesture2.delegate = self;
    [tapGesture2 setNumberOfTapsRequired:1];
    [[self topRightView] addGestureRecognizer:tapGesture2];
    
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped3)];
    tapGesture3.delegate = self;
    [tapGesture3 setNumberOfTapsRequired:1];
    [[self bottomLeftView] addGestureRecognizer:tapGesture3];
    
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTapped4)];
    tapGesture4.delegate = self;
    [tapGesture4 setNumberOfTapsRequired:1];
    [[self bottomRightView] addGestureRecognizer:tapGesture4];
    
}

-(void)tapGestureTapped2 {
    if(self.topRightView.backgroundColor == [UIColor whiteColor]) {
        self.topRightView.backgroundColor = [UIColor customOrange];
    } else
        self.topRightView.backgroundColor = [UIColor whiteColor];
}

-(void)tapGestureTapped3 {
    if(self.bottomLeftView.backgroundColor == [UIColor whiteColor]) {
        self.bottomLeftView.backgroundColor = [UIColor customOrange];
    } else
        self.bottomLeftView.backgroundColor = [UIColor whiteColor];
}

-(void)tapGestureTapped4 {
    if(self.bottomRightView.backgroundColor == [UIColor whiteColor]) {
        self.bottomRightView.backgroundColor = [UIColor customOrange];
    } else
        self.bottomRightView.backgroundColor = [UIColor whiteColor];
}

- (void)rdioRequest:(RDAPIRequest *)request didFailWithError:(NSError*)error {
    
}

- (void)rdioRequest:(RDAPIRequest *)request didLoadData:(id)data {
    
    if (data != nil && [data objectForKey:@"results"]) {
        //in this step, the result from the server containing the details about an album is returned
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
        NSString *albumIconSmallUrl = dict[@"results"][0][@"icon"];
        NSString *albumIconBigUrl = [albumIconSmallUrl stringByReplacingOccurrencesOfString:@"-200" withString:@"-400"];
        NSURL *url = [NSURL URLWithString:albumIconSmallUrl];
        NSURL *urlBigImage = [NSURL URLWithString:albumIconBigUrl];
        //try to get the bigger image if possible
        NSData *data = [NSData dataWithContentsOfURL:urlBigImage];
        if (data == nil) {
            data = [NSData dataWithContentsOfURL:url];
        }
        [self fillEmptyGenreTile:data];
    }
}
- (void) fillEmptyGenreTile: (NSData *)data {
    //depending on the answer from Raza
    //self.albumCoverImage.image = [[UIImage alloc] initWithData:data];
    UIImageView *currentImageView = [genreImageViews objectAtIndex:currentImageCounter];
    
    currentImageView.image = [[UIImage alloc] initWithData:data];
    currentImageView.hidden = FALSE;
    currentImageCounter++;
    NSLog(@"increase image counter");
    
}

@end
