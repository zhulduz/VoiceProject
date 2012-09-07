//
//  AdditionTrackViewController.h
//  VoiceProject
//
//  Created by trainee on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RenameTrack<NSObject>

- (void)setNewNameOfTrack:(NSString *)name;

@end

@interface AdditionTrackViewController : UIViewController

@property (nonatomic, assign) id<RenameTrack> trackDelegate;

@end
