//
//  RecordViewController.m
//  VoiceProject
//
//  Created by trainee on 9/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordViewController.h"
#import "ManagerSingleton.h"

@interface RecordViewController ()

@property (retain, nonatomic) IBOutlet UITextField *additionalTrack;
@property (retain, nonatomic) IBOutlet UIButton *addGroupForTrack;
@property (retain, nonatomic) IBOutlet UIButton *playButton;
@property (retain, nonatomic) IBOutlet UIButton *recordOrStopButton;



@end

@implementation RecordViewController 


@synthesize additionalTrack;
@synthesize addGroupForTrack;
@synthesize playButton;
@synthesize recordOrStopButton;




- (IBAction)addTrackButton:(id)sender {
    if (self.additionalTrack.text && ![self.addGroupForTrack.titleLabel.text isEqual:@"add group"]) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [manager addtrack:self.additionalTrack.text AtGroup:self.addGroupForTrack.titleLabel.text];
        [manager saveData];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ChoseGroupForTrackSegue"]) {
        GroupViewController *groupViewController = [segue destinationViewController];
        groupViewController.groupDelegate = self;
    }
}

- (void)setNewNameOnButton:(NSString *)name {
    [self.addGroupForTrack setTitle:name forState:0];
}

- (void)viewDidUnload {
    [self setAdditionalTrack:nil];
    [self setAddGroupForTrack:nil];
    [self setPlayButton:nil];
    [self setRecordOrStopButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [additionalTrack release];
    [addGroupForTrack release];
    [playButton release];
    [recordOrStopButton release];
    [super dealloc];
}
@end