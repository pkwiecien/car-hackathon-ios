//
//  TestViewController.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *sunIcon;
@property (weak, nonatomic) IBOutlet UIButton *speedIcon;
@property (weak, nonatomic) IBOutlet UIButton *landscapeIcon;
@property (weak, nonatomic) IBOutlet UIButton *styleIcon;
@property (weak, nonatomic) IBOutlet UIButton *safetyIcon;
@property (weak, nonatomic) IBOutlet UIButton *timeIcon;
@property (weak, nonatomic) IBOutlet UILabel *speedLimitLabel;

@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *song;
@property (strong, nonatomic) NSString *genre;

- (IBAction)closeButtonPressed:(id)sender;

@end
