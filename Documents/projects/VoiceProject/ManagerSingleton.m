//
//  ManagerSingleton.m
//  VoiceProject
//
//  Created by trainee on 8/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ManagerSingleton.h"

@implementation ManagerSingleton {
    NSMutableArray *arrayOfGroups_;
    NSMutableArray *arrayOfTracks_; //every track is type of NSMutableDictionary
}

@synthesize arrayOfGroups = arrayOfGroups_;
@synthesize arrayOfTracks = arrayOfTracks_;

+ (ManagerSingleton *)instance {
    static ManagerSingleton *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        //reading from file
        /*[self readFromFile:@"1.txt" ToArray:self.arrayOfGroups];
        if (self.arrayOfGroups == nil) {
            self.arrayOfGroups = [[NSMutableArray alloc] initWithObjects:@"group0", nil];
        }
        [self readFromFile:@"2.txt" ToArray:self.arrayOfTracks];
        if (self.arrayOfTracks == nil) {
            self.arrayOfTracks = [[NSMutableArray alloc] initWithCapacity:1];
        }*/
        self.arrayOfGroups = [[NSMutableArray alloc] initWithObjects:@"group0",@"group1", @"group2",@"group3",@"group4",@"group5",nil];
        self.arrayOfTracks = [[NSMutableArray alloc] initWithObjects:[[NSMutableDictionary alloc] initWithObjects:[NSMutableArray arrayWithObjects: @"tracks1",@"group1", nil] forKeys:[NSMutableArray arrayWithObjects: @"nameOfTrack",@"nameOfGroup", nil]], nil];
    }
    return self;
}

- (void)readFromFile:(NSString *)fileName ToArray:(NSMutableArray *)array {
    NSFileManager * fmanager = [NSFileManager defaultManager];
    NSData *data = [fmanager contentsAtPath:[self documentPath:fileName]];
    NSString *stringOfData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    array = [stringOfData componentsSeparatedByString:@" "];
}

- (NSString *)documentPath:(NSString *)file_name
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    return [[pathList objectAtIndex:0] stringByAppendingPathComponent:file_name];
    
}

- (void)addGroup:(NSMutableString *)nameOfGroup {
    [self.arrayOfGroups addObject:nameOfGroup];
}


- (void)addtrack:(NSMutableString *)nameOfTrack AtGroup:(NSMutableString *)nameOfGroup {
    NSMutableString *findGroup = [self searchGroupWithName:nameOfGroup];
    if (findGroup == nil) {
        [self addGroup:nameOfGroup];
    }
    NSMutableDictionary *trackSign = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:nameOfTrack, nameOfGroup, nil] forKeys:[NSArray arrayWithObjects:@"nameOfTrack",@"nameOfGroup", nil]];
    
    [self.arrayOfTracks addObject:trackSign];
    
}

- (NSMutableString *)searchGroupWithName:(NSMutableString *)nameOfGroup {
    for (int i = 0; i < [self.arrayOfGroups count]; ++i) {
        if ([[self.arrayOfGroups objectAtIndex:i] isEqual:nameOfGroup]) {
            return [self.arrayOfGroups objectAtIndex:i];
        }
    }
    return nil;
}

- (void)renameGroup:(NSMutableString *)oldNameOfGroup ToNewGroup:(NSMutableString *)newNameGroup {
    for (int i = 0; i < [self.arrayOfGroups count]; ++i) {
        if ([[self.arrayOfGroups objectAtIndex:i] isEqual:oldNameOfGroup]) {
            [[self.arrayOfGroups objectAtIndex:i] setString:newNameGroup];
        }
    }
}

- (void)renameTrack:(NSMutableString *)oldNameOfTrack ToNewGroup:(NSMutableString *)newNameTrack {
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:@"nameOfTrack"] isEqual:oldNameOfTrack]) {
            [[self.arrayOfTracks objectAtIndex:i] setValue:newNameTrack forKeyPath:@"nameOfTrack"];
        }
    }
}

- (NSMutableArray *)getAllTracksOfTheGroup:(NSMutableArray *)nameOfGroup {
    NSMutableArray *arrayOfTracksAtTheGroup = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:@"nameOfGroup"] isEqual:nameOfGroup]) {
            [arrayOfTracksAtTheGroup addObject: [[self.arrayOfTracks objectAtIndex:i] valueForKey:@"nameOfTrack"]];
        }
    }
    return [arrayOfTracksAtTheGroup autorelease];
}

- (void)deleteGroup:(NSMutableString *)nameOfGroup {
    if ([self searchGroupWithName:nameOfGroup] != nil) {
        [self.arrayOfGroups removeObject:nameOfGroup];
    }
}

- (void)deleteTrack:(NSMutableString *)nameOfTrack {
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:@"nameOfTrack"] isEqual:nameOfTrack]) {
            [self.arrayOfTracks removeObject:[self.arrayOfTracks objectAtIndex:i]];
        }
    }
}

- (void)saveData {
    NSFileManager *fmanager = [NSFileManager defaultManager]; 
    [fmanager createFileAtPath:[self documentPath:@"1.txt"] contents:[[self.arrayOfGroups componentsJoinedByString:@" "] dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

@end
