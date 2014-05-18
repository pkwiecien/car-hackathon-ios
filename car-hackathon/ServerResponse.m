//
//  ServerResponse.m
//  car-hackathon
//
//  Created by Simina Pasat on 5/18/14.
//  Copyright (c) 2014 Pawel Kwiecien. All rights reserved.
//

#import "ServerResponse.h"

@implementation ServerResponse

- (id) initWithData: (NSMutableDictionary *)responseDict {
    self = [super init];
    self.averageSpeed = responseDict[@"average_speed"];
    //self.maxSpeed = responseDict[@"max_speed"];
    self.mood = responseDict[@"mood"];
    self.weatherType = responseDict[@"weather"];
    self.tracksNames = [[NSMutableArray alloc] init];
    self.tracksArtists = [[NSMutableArray alloc] init];
    self.tracksAlbums = [[NSMutableArray alloc] init];
    self.genres = [[NSMutableDictionary alloc] init];
    /*
    for (NSDictionary *albums in responseDict[@"playlist"][@"ALBUM"]) {
        NSString *artist = albums[@"artist"][0][@"value"];
        NSString *genre = albums[@"GENRE"][0][@"VALUE"];
        [self.genres setObject:track[@"artist"] forKey:track[@"genre"]];
        Track* track ;
        for (NSDictionary *track in albums[@"TRACK"]) {
            //for each track
            track.artist = track[@"ARTIST"][0][@"VALUE"];
            track.title = track[@"TITLE"][0][@"VALUE"];
            track.album = albums[@"TITLE"][0][@"VALUE"];
            
            //add to track array
        }
        track.title =
        // use track object
    }*/
    for (NSDictionary *track in responseDict[@"tracks"]) {
        [self.tracksNames addObject:track[@"name"]];
        [self.tracksArtists addObject:track[@"artist"]];
        [self.tracksAlbums addObject:track[@"album"]];
        [self.genres setObject:track[@"artist"] forKey:track[@"genre"]];
    }
    return self;
}
@end
