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
    static ManagerSingleton *_default = nil;
    if (_default != nil) {
        return _default;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _default = [[self alloc] init];
    });
    return _default;
}

- (id)init {
    if ((self = [super init])) {
        //reading from file
        self.arrayOfGroups = [self readFromFile:@"1.txt"];
        if (self.arrayOfGroups == nil) {
            self.arrayOfGroups = [[NSMutableArray alloc] initWithObjects:@"group0", nil];
        }
        self.arrayOfTracks = [self readFromFile:@"2.txt"];
        if (self.arrayOfTracks == nil) {
            self.arrayOfTracks = [[NSMutableArray alloc] initWithCapacity:1];
        }
    }
    return self;
}

- (NSMutableArray *)readFromFile:(NSString *)fileName {
    NSFileManager * fmanager = [NSFileManager defaultManager];
    if (![fmanager fileExistsAtPath:[self documentPath:fileName]]) {
        return nil;
    }
    NSData *data = [fmanager contentsAtPath:[self documentPath:fileName]];
    NSString *stringOfData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!stringOfData) {
        return nil;
    } else {
        if ([fileName isEqualToString:@"1.txt"]) {
            return [[stringOfData componentsSeparatedByString:@" "] autorelease];
        } else {
            NSMutableArray *arrayOfElemOfStringOfData = [stringOfData componentsSeparatedByString:@"\n"];
            NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:1];
            [arrayOfElemOfStringOfData removeLastObject];
            for (int i = 0; i < [arrayOfElemOfStringOfData count]; ++i) {
                NSMutableDictionary *elem = [[NSMutableDictionary alloc] initWithCapacity:1];
                [elem setObject:[[[arrayOfElemOfStringOfData objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:0]forKey:@"nameOfGroup"];
                [elem setObject:[[[arrayOfElemOfStringOfData objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:1]forKey:@"nameOfTrack"];
                [result addObject:elem];
            }
            return [result autorelease];
        }
    }
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
    NSMutableDictionary *trackSign = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:nameOfTrack, nameOfGroup, nil] 
                                                                          forKeys:[NSArray arrayWithObjects:@"nameOfTrack",@"nameOfGroup", nil]];
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

- (NSMutableArray *)getAllTracksOfTheGroup:(NSMutableString *)nameOfGroup {
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
    
    NSMutableString *fileContent = [[NSMutableString alloc] initWithCapacity:1];
    NSMutableDictionary *elem = [[NSMutableDictionary alloc] initWithCapacity:1];
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        ///elem = [self.arrayOfTracks objectAtIndex:i];
        [fileContent appendString:[[self.arrayOfTracks objectAtIndex:i] objectForKey:@"nameOfGroup"]];
        [fileContent appendString:@" "];
        [fileContent appendString:[[self.arrayOfTracks objectAtIndex:i] objectForKey:@"nameOfTrack"]];
        [fileContent appendString:@"\n"];
    }
    [fmanager createFileAtPath:[self documentPath:@"2.txt"] contents:[fileContent dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    [elem release];
    [fileContent release];
}


@end
