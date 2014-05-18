//
//  TestViewController.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerDetailsViewController : UIViewController
- (IBAction)closeButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
