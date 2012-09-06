//
//  TrackEditViewController.m
//  VoiceProject
//
//  Created by trainee on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackEditViewController.h"
#import "ManagerSingleton.h"

@interface TrackEditViewController ()

@property (retain, nonatomic) IBOutlet UIButton *trackNameButton;
@property (retain, nonatomic) IBOutlet UIButton *groupNameButton;
@property (retain, nonatomic) IBOutlet UIButton *voiceButton;

@property (retain,nonatomic) AVAudioRecorder *audioRecorder;
@property (retain, nonatomic) NSURL *fileOfTrack;


- (IBAction)play:(id)sender;
- (IBAction)recordOrStop:(id)sender;

@end

@implementation TrackEditViewController {
    BOOL recording;
}

@synthesize groupNameButton;
@synthesize voiceButton;
@synthesize trackNameButton;
@synthesize nameOfButton;
@synthesize audioRecorder;
@synthesize fileOfTrack;

- (IBAction)saveChanges:(id)sender {
    if (self.trackNameButton && self.groupNameButton) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [manager renameTrack:self.nameOfButton ToNewGroup:self.trackNameButton.titleLabel.text];
        [manager saveData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableOfTrack" object:nil];
}

- (IBAction)play:(id)sender {
    
    NSString *fileDate = [self.nameOfButton stringByAppendingPathExtension:@"caf"];
        
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    NSString *docPathList = [pathList objectAtIndex:0];
    NSString *soundFilePath =[docPathList stringByAppendingPathComponent:fileDate];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.fileOfTrack = newURL;
    [newURL release];

    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithContentsOfURL:self.fileOfTrack error:nil];
    
    [player prepareToPlay];
    [player play];
}

- (IBAction)recordOrStop:(id)sender {
    if (recording) {
        [self.audioRecorder stop];
        recording = false;
        self.audioRecorder = nil;
        [self.voiceButton setTitle: @"Record" forState:UIControlStateNormal];
        [self.voiceButton setTitle: @"Record" forState:UIControlStateHighlighted];
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        NSDictionary *recordSettings =[[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                                       [NSNumber numberWithInt: kAudioFormatAppleLossless],  AVFormatIDKey,
                                       [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                       [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey, nil];
        
        //create dateFile
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        NSString *fileDate = [dateString stringByAppendingPathExtension:@"caf"];
        [self.trackNameButton setTitle:dateString forState:0];
        
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                NSUserDomainMask,   
                                                                YES);
        NSString *docPathList = [pathList objectAtIndex:0];
        NSString *soundFilePath =[docPathList stringByAppendingPathComponent:fileDate];
        NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        self.fileOfTrack = newURL;
        [newURL release];
        
        //create recprder
        AVAudioRecorder *newRecorder =[[AVAudioRecorder alloc] initWithURL:self.fileOfTrack 
                                                                  settings: recordSettings error: nil];
        [date release];
        [dateFormatter release];
        [recordSettings release];
        self.audioRecorder = newRecorder;
        [newRecorder release];
        self.audioRecorder.delegate = self;
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder record];
        [self.voiceButton setTitle: @"Stop" forState: UIControlStateNormal];
        [self.voiceButton setTitle: @"Stop" forState: UIControlStateHighlighted];
        recording = true;
    }

}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"success");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"fail");
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
    ManagerSingleton *manager = [ManagerSingleton instance];
    [self.trackNameButton setTitle:self.nameOfButton forState:0];
    [self.groupNameButton setTitle:[manager searchGroupThoseTrackBelongRo:self.nameOfButton] forState:0];
    [super viewDidLoad];
    
    recording = false;
	// Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupViewControllerSegue"]) {
        GroupViewController *groupViewControler = [segue destinationViewController];
        groupViewControler.groupDelegate = self;
    }
    if ([[segue identifier] isEqualToString:@"AdditionTrackSegue"]) {
        AdditionTrackViewController *addTrack = [segue destinationViewController];
        addTrack.trackDelegate = self;
    }
}
- (void)setNewNameOfTrack:(NSString *)name {
    [self.trackNameButton setTitle:name forState:0];
}

- (void)viewDidUnload {
    
    [self setTrackNameButton:nil];
    [self setGroupNameButton:nil];
    [self setVoiceButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [fileOfTrack release];
    [trackNameButton release];
    [groupNameButton release];
    [voiceButton release];
        [super dealloc];
}
@end
