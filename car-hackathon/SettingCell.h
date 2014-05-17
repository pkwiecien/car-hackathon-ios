//
//  SettingCell.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell

+(SettingCell *)settingCell;
@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@end
