//
//  Track.h
//  car-hackathon
//
//  Created by Pawel Kwiecien on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSString *trackId;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSString *songTitle;
@property (strong, nonatomic) NSString *album;
@property (strong, nonatomic) NSString *albumUrl;

@end
