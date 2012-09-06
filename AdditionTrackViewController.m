//
//  AdditionTrackViewController.m
//  VoiceProject
//
//  Created by trainee on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdditionTrackViewController.h"
#import "ManagerSingleton.h"

@interface AdditionTrackViewController ()

@property (retain, nonatomic) IBOutlet UITextField *additionalTrack;

@end

@implementation AdditionTrackViewController {
    id <RenameTrack> trackDelegate;
}

@synthesize trackDelegate;
@synthesize additionalTrack;

- (IBAction)addTrack:(id)sender {
    if (self.additionalTrack) {
        if ((self.trackDelegate != nil) && [self.trackDelegate respondsToSelector:@selector(setNewNameOfTrack:)]) {
            [self.trackDelegate performSelector:@selector(setNewNameOfTrack:) withObject:self.additionalTrack.text];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setAdditionalTrack:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [additionalTrack release];
    [super dealloc];
}
@end
