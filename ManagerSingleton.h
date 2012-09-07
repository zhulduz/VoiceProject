//
//  ManagerSingleton.h
//  VoiceProject
//
//  Created by trainee on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ManagerSingleton : NSObject

@property (retain, nonatomic) NSMutableArray *arrayOfGroups;
@property (retain, nonatomic) NSMutableArray *arrayOfTracks;

+ (ManagerSingleton *)instance; 

- (id)init;

- (NSArray *)readFromFile:(NSString *)fileName;

- (NSString *)documentPath:(NSString *)file_name;

- (void)addGroup:(NSString *)nameOfGroup;

- (void)addtrack:(NSString *)nameOfTrack AtGroup:(NSString *)nameOfGroup;

- (NSString *)searchGroupWithName:(NSString *)nameOfGroup;

- (void)renameGroup:(NSString *)oldNameOfGroup ToNewGroup:(NSString *)newNameGroup;

- (void)renameTrack:(NSString *)oldNameOfTrack ToNewGroup:(NSString *)newNameTrack;

- (NSMutableArray *)getAllTracksOfTheGroup:(NSString *)nameOfGroup;

- (void)deleteGroup:(NSString *)nameOfGroup;

- (void)deleteTrack:(NSString *)nameOfTrack;

- (NSString *)searchGroupThoseTrackBelongRo:(NSString *)nameOfTrack;

- (void)saveData;

@end
