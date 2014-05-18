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

@implementation DashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    
    [self addGestureRecognizers];
    [self displayGenres];
}

- (void) displayGenres {
    NSArray *orderedKeysArray;
    
    orderedKeysArray = [self.genrePreferences keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
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
    if ([orderedKeysArray count] > 0) {
        self.topLeftGenreName.text = [orderedKeysArray objectAtIndex:0];
    }
    if ([orderedKeysArray count] > 1) {
        self.topRightGenreName.text = [orderedKeysArray objectAtIndex:1];
    }
    if ([orderedKeysArray count] > 2) {
        self.bottomLeftGenreName.text = [orderedKeysArray objectAtIndex:2];
    }
    if ([orderedKeysArray count] > 3) {
        self.bottomRightGenreName.text = [orderedKeysArray objectAtIndex:3];
    }
   /*
    for (NSString *favKey in orderedKeysArray) {
        <#statements#>
    }
    self.topLeftImageView
    self.topRightImageView
    self.bottomLeftImageView
    self.topRightImageView
    self.genrePreferences obje */
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
@end
