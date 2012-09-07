//
//  ViewController.h
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GroupViewController.h"

extern NSString *const keyForNotificationAddGroup;

@interface MainViewController : UIViewController<RenameButton, UITableViewDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate>
 
@end


