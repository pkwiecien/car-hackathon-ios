//
//  ServerResponse.h
//  car-hackathon
//
//  Created by Simina Pasat on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResponse : NSObject
@property (nonatomic, retain) NSString *weatherType;
@property (nonatomic, retain) NSString *maxSpeed;
@property (nonatomic, retain) NSString *averageSpeed;
@property (nonatomic, retain) NSString *mood;
@property (nonatomic, retain) NSMutableArray *tracksNames;
@property (nonatomic, retain) NSMutableArray *tracksArtists;
@property (nonatomic, retain) NSMutableArray *tracksAlbums;
@property (nonatomic, retain) NSMutableDictionary *genres;

- (id) initWithData: (NSMutableDictionary *)responseDict ;
@end


