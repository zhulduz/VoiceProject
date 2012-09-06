//
//  TrackEditViewController.h
//  VoiceProject
//
//  Created by trainee on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GroupViewController.h"
#import "AdditionTrackViewController.h"

@interface TrackEditViewController : UIViewController<RenameTrack, RenameButton, AVAudioPlayerDelegate>

@property (retain, nonatomic) NSString *nameOfButton;

@end