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

- (BOOL)isAddGroup:(NSString *)nameOfGroup;

- (void)removeTrack:(NSString *)nameOfTrack atNewGroup:(NSString *)nameOfGroup;

- (BOOL)isAddTrack:(NSString *)nameOfTrack atGroup:(NSString *)nameOfGroup;

- (NSString *)searchGroupWithName:(NSString *)nameOfGroup;

- (BOOL)searchTrackWithName:(NSString *)nameOfTrack;

- (void)renameGroup:(NSString *)oldNameOfGroup toNewGroup:(NSString *)newNameGroup;

- (BOOL)renameTrack:(NSString *)oldNameOfTrack toNewTrack:(NSString *)newNameTrack;

- (NSMutableArray *)getAllTracksOfTheGroup:(NSString *)nameOfGroup;

- (void)deleteGroup:(NSString *)nameOfGroup;

- (NSString *)searchGroupThoseTrackBelongTo:(NSString *)nameOfTrack;

- (void)saveData;

@end
