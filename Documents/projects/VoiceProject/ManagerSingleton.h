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

- (NSMutableArray *)readFromFile:(NSString *)fileName;

- (NSString *)documentPath:(NSString *)file_name;

- (void)addGroup:(NSMutableString *)nameOfGroup;

- (void)addtrack:(NSMutableString *)nameOfTrack AtGroup:(NSMutableString *)nameOfGroup;

- (NSMutableString *)searchGroupWithName:(NSMutableString *)nameOfGroup;

- (void)renameGroup:(NSMutableString *)oldNameOfGroup ToNewGroup:(NSMutableString *)newNameGroup;

- (void)renameTrack:(NSMutableString *)oldNameOfTrack ToNewGroup:(NSMutableString *)newNameTrack;

- (NSMutableArray *)getAllTracksOfTheGroup:(NSMutableString *)nameOfGroup;

- (void)deleteGroup:(NSMutableString *)nameOfGroup;

- (void)deleteTrack:(NSMutableString *)nameOfTrack;

- (void)saveData;

@end
