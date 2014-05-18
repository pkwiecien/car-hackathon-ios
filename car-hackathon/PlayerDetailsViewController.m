//
//  TestViewController.m
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "PlayerDetailsViewController.h"
#import "UtilityManager.h"

@interface PlayerDetailsViewController ()

@end

@implementation PlayerDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.closeButton setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"CrossIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.sunIcon setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"SunIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.speedIcon setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"CircleIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.landscapeIcon setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"CityIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.safetyIcon setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"CautionIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.timeIcon setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"DaytimeIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.styleIcon setBackgroundImage:[UtilityManager colorImage:[UIImage imageNamed:@"LightningIcon"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    self.artistLabel.text = self.artist;
    self.albumLabel.text = self.album;
    self.songLabel.text = self.song;
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
