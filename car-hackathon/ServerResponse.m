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
    self.tracks = [[NSMutableArray alloc] init];
    self.genres = [[NSMutableDictionary alloc] init];
    
    
    for (NSDictionary *albums in responseDict[@"playlist"][0][@"ALBUM"]) {
        NSString *artist = albums[@"ARTIST"][0][@"VALUE"];
        NSString *genre = albums[@"GENRE"][0][@"VALUE"];
        [self.genres setObject:artist forKey:genre];
        for (NSDictionary *track in albums[@"TRACK"]) {
            //for each track
            Track* newTrack = [[Track alloc] init];
            newTrack.songTitle = track[@"TITLE"][0][@"VALUE"];
            newTrack.artist = track[@"ARTIST"][0][@"VALUE"];
            //newTrack.genre = genre;
            newTrack.album = albums[@"ALBUM"][0][@"VALUE"];
            newTrack.albumUrl = albums[@"TITLE"][0][@"VALUE"];
            if (newTrack != nil) {
                [self.tracks addObject: newTrack];
            }
        }
        //add newTrack to tracks
        
    }
    return self;
}

- (id) initWithPlaylist: (NSMutableDictionary *)playlist {
    self = [super init];
    self.tracks = [[NSMutableArray alloc] init];
    self.genres = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *albums in playlist[@"ALBUM"]) {
        NSString *artist = albums[@"ARTIST"][0][@"VALUE"];
        NSString *genre = albums[@"GENRE"][0][@"VALUE"];
        [self.genres setObject:artist forKey:genre];
        for (NSDictionary *track in albums[@"TRACK"]) {
            //for each track
            Track* newTrack = [[Track alloc] init];
            newTrack.songTitle = track[@"TITLE"][0][@"VALUE"];
            newTrack.artist = track[@"ARTIST"][0][@"VALUE"];
            //newTrack.genre = genre;
            newTrack.album = albums[@"ALBUM"][0][@"VALUE"];
            newTrack.albumUrl = albums[@"TITLE"][0][@"VALUE"];
            if (newTrack != nil) {
                [self.tracks addObject: newTrack];
            }
        }        
    }
    return self;
}
@end
