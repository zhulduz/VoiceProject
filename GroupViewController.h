//
//  GroupViewControllerViewController.h
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RenameButton<NSObject>

- (void)setNewNameOnButton:(NSString *)name;

@end


@interface GroupViewController : UIViewController<UITableViewDelegate>

@property (nonatomic, assign) id<RenameButton> groupDelegate;

@end
