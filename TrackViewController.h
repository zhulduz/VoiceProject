//
//  Track.h
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const keyForNotificationRenameTrack;

@interface TrackViewController : UIViewController<UITableViewDelegate>

@property (retain, nonatomic) NSString *groupName;

@end
