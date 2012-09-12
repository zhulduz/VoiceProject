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
    NSMutableArray *arrayOfTracks_; //Every track is type of NSMutableDictionary
}

@synthesize arrayOfGroups = arrayOfGroups_;
@synthesize arrayOfTracks = arrayOfTracks_;

NSString *const keyGroup = @"nameOfGroup";
NSString *const keyTrack = @"nameOfTrack";

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
        [self readFromFile:@"1.txt"];
        [self readFromFile:@"2.txt"];
        if (self.arrayOfGroups == nil || [self.arrayOfGroups count] == 0) {
            self.arrayOfGroups = [NSMutableArray arrayWithObject:@"Default group"];
        }
    }
    return self;
}

- (void)readFromFile:(NSString *)fileName {
    NSFileManager *fmanager = [NSFileManager defaultManager];
    if (![fmanager fileExistsAtPath:[self documentPath:fileName]]) {
        return;
    }
    NSData *data = [fmanager contentsAtPath:[self documentPath:fileName]];
    if ([fileName isEqualToString:@"1.txt"]) {
        self.arrayOfGroups = [NSJSONSerialization JSONObjectWithData:data 
                                                             options:NSJSONReadingMutableContainers 
                                                               error:nil];
    } else {
        self.arrayOfTracks = [NSJSONSerialization JSONObjectWithData:data 
                                                             options:NSJSONReadingMutableContainers 
                                                               error:nil];
    }
}

- (NSString *)documentPath:(NSString *)file_name {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[pathList objectAtIndex:0] stringByAppendingPathComponent:file_name];
}

- (BOOL)isAddGroup:(NSString *)nameOfGroup {
    if ([self searchGroupWithName:nameOfGroup] == nil) {
        [self.arrayOfGroups addObject:nameOfGroup];
        return true;
    }
    return false;
}

- (void)removeTrack:(NSString *)nameOfTrack atNewGroup:(NSString *)nameOfGroup {
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:keyTrack] isEqualToString:nameOfTrack]) {
            [[self.arrayOfTracks objectAtIndex:i] setValue:nameOfGroup forKey:keyGroup];
        }
    }
}

- (BOOL)isAddTrack:(NSString *)nameOfTrack atGroup:(NSString *)nameOfGroup {
    if ([self searchTrackWithName:nameOfTrack] == false) {
        NSMutableDictionary *trackSign = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          nameOfGroup, keyGroup,
                                          nameOfTrack, keyTrack, nil];
        if (self.arrayOfTracks == nil || [self.arrayOfTracks count] == 0) {
            self.arrayOfTracks = [NSMutableArray arrayWithObject:trackSign];
        } else {
            [self.arrayOfTracks addObject:trackSign];
        }
        return true;
    }
    return false;
}

- (BOOL)searchTrackWithName:(NSString *)nameOfTrack {
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:keyTrack] isEqualToString:nameOfTrack]) {
            return true;
        }
    }
    return false;
}

- (NSString *)searchGroupWithName:(NSString *)nameOfGroup {
    for (int i = 0; i < [self.arrayOfGroups count]; ++i) {
        if ([[self.arrayOfGroups objectAtIndex:i] isEqualToString:nameOfGroup]) {
            return [self.arrayOfGroups objectAtIndex:i];
        }
    }
    return nil;
}

- (void)renameGroup:(NSString *)oldNameOfGroup toNewGroup:(NSString *)newNameGroup {
    for (int i = 0; i < [self.arrayOfGroups count]; ++i) {
        if ([[self.arrayOfGroups objectAtIndex:i] isEqual:oldNameOfGroup]) {
            [[self.arrayOfGroups objectAtIndex:i] setString:newNameGroup];
        }
    }
}

- (BOOL)renameTrack:(NSString *)oldNameOfTrack toNewTrack:(NSString *)newNameTrack {
    if ([self searchTrackWithName:newNameTrack] == false) {
        for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
            if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:keyTrack] isEqual:oldNameOfTrack]) {
                [[self.arrayOfTracks objectAtIndex:i] setValue:newNameTrack forKeyPath:keyTrack];
            }
        }
        return true;
    }
    return false;
}

- (NSArray *)getAllTracksOfTheGroup:(NSString *)nameOfGroup {
    NSMutableArray *arrayOfTracksAtTheGroup = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] valueForKey:keyGroup] isEqual:nameOfGroup]) {
            [arrayOfTracksAtTheGroup addObject: [[self.arrayOfTracks objectAtIndex:i] valueForKey:keyTrack]];
        }
    }
    return [arrayOfTracksAtTheGroup autorelease];
}

- (void)deleteGroup:(NSString *)nameOfGroup {
    NSDictionary *recordSettings =[[[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                                   [NSNumber numberWithInt: kAudioFormatAppleLossless],  AVFormatIDKey,
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey, nil] autorelease];
   
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    NSString *docPathList = [pathList objectAtIndex:0];
    if ([self.arrayOfTracks count] != 0) {
        NSMutableArray *arrayOfObjectToDelete = [[NSMutableArray alloc] initWithCapacity:1];
        for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
            if([[[self.arrayOfTracks objectAtIndex:i] valueForKey:keyGroup] isEqualToString:nameOfGroup]) {
                NSString *file = [[[self.arrayOfTracks objectAtIndex:i] valueForKey:keyTrack] 
                                  stringByAppendingPathExtension:@"caf"];
                NSString *soundFilePath =[docPathList stringByAppendingPathComponent:file];
                NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
            
                AVAudioRecorder *recorder =[[[AVAudioRecorder alloc] initWithURL:newURL
                                                                    settings: recordSettings 
                                                                       error: nil] autorelease];
                [recorder deleteRecording];  
                [arrayOfObjectToDelete addObject:[self.arrayOfTracks objectAtIndex:i]];
                [newURL release];
            }
        }
        if ([arrayOfObjectToDelete count] != 0) {
            [self.arrayOfTracks removeObjectsInArray:arrayOfObjectToDelete];
        } 
        [arrayOfObjectToDelete release];
    }
    if ([self searchGroupWithName:nameOfGroup] != nil) {
        [self.arrayOfGroups removeObject:nameOfGroup];
    }
}

- (NSString *)searchGroupThoseTrackBelongTo:(NSString *)nameOfTrack {
    for (int i = 0; i < [self.arrayOfTracks count]; ++i) {
        if ([[[self.arrayOfTracks objectAtIndex:i] objectForKey:keyTrack] isEqualToString:nameOfTrack]) {
            return [[self.arrayOfTracks objectAtIndex:i] objectForKey:keyGroup];
        }
    }
    return nil;
}

- (void)saveData {
    NSFileManager *fmanager = [NSFileManager defaultManager]; 
    if ([NSJSONSerialization isValidJSONObject:self.arrayOfGroups] && [NSJSONSerialization isValidJSONObject:self.arrayOfTracks]) {
        NSData *dataOfGroups = [NSJSONSerialization dataWithJSONObject:self.arrayOfGroups 
                                                               options:NSJSONWritingPrettyPrinted 
                                                                 error:nil];
        NSData *dataOfTracks = [NSJSONSerialization dataWithJSONObject:self.arrayOfTracks 
                                                               options:NSJSONWritingPrettyPrinted 
                                                                 error:nil];
        [fmanager createFileAtPath:[self documentPath:@"1.txt"] 
                          contents:dataOfGroups attributes:nil];
        [fmanager createFileAtPath:[self documentPath:@"2.txt"] 
                          contents:dataOfTracks attributes:nil];
    }
}

@end
