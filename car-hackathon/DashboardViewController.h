//
//  DashboardViewController.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topRightImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomRightView;
@property (weak, nonatomic) IBOutlet UIView *bottomLeftView;
@property (weak, nonatomic) IBOutlet UIView *topLeftView;
@property (weak, nonatomic) IBOutlet UIView *topRightView;

- (IBAction)mainButtonPressed:(id)sender;

@end
