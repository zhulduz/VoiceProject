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
    NSMutableArray *arrayOfTracks_; //every track is type TrackSign
   // NSArray *const keys = [[NSArray alloc] initWithObjects:@"nameOfTrack", @"nameOfGroup",nil];
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
        NSFileManager * fmanager = [NSFileManager defaultManager];
        NSData *data = [fmanager contentsAtPath:[self documentPath:@"1.txt"]];
        NSString *stringOfData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.arrayOfGroups = [stringOfData componentsSeparatedByString:@" "];  
        
        NSData *data2 = [fmanager contentsAtPath:[self documentPath:@"2.txt"]];
        NSString *stringOfData2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        self.arrayOfTracks = [stringOfData2 componentsSeparatedByString:@" "]; 
    }
    return self;
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
    NSMutableString *bufferGroup = [self searchGroupWithName:nameOfGroup];
    if (bufferGroup == nil) {
        [self addGroup:nameOfGroup];
    }
    NSDictionary *trackSign = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:nameOfTrack, nameOfGroup, nil] forKeys:[NSArray arrayWithObjects:@"nameOfTrack",@"nameOfGroup", nil]];
    
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

- (void)deleteGroup:(NSMutableString *)nameOfGroup {
    if ([self searchGroupWithName:nameOfGroup]) {
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
    
    
}

- (void)dealloc {
    [super dealloc];
}

@end
