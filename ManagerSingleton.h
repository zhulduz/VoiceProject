//
//  ManagerSingleton.h
//  VoiceProject
//
//  Created by trainee on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

extern NSString *const keyGroup;
extern NSString *const keyTrack;

@interface ManagerSingleton : NSObject

@property (retain, nonatomic) NSMutableArray *arrayOfGroups;
@property (retain, nonatomic) NSMutableArray *arrayOfTracks;

+ (ManagerSingleton *)instance; 

- (id)init;

- (void)readFromFile:(NSString *)fileName;

- (NSString *)documentPath:(NSString *)file_name;

- (void)addGroup:(NSString *)nameOfGroup;

- (void)removeTrack:(NSString *)nameOfTrack AtNewGroup:(NSString *)nameOfGroup;

- (void)addTrack:(NSString *)nameOfTrack AtGroup:(NSString *)nameOfGroup;

- (NSString *)searchGroupWithName:(NSString *)nameOfGroup;

- (void)renameGroup:(NSString *)oldNameOfGroup ToNewGroup:(NSString *)newNameGroup;

- (void)renameTrack:(NSString *)oldNameOfTrack ToNewTrack:(NSString *)newNameTrack;

- (NSMutableArray *)getAllTracksOfTheGroup:(NSString *)nameOfGroup;

- (void)deleteGroup:(NSString *)nameOfGroup;

- (NSString *)searchGroupThoseTrackBelongRo:(NSString *)nameOfTrack;

- (void)saveData;

@end
