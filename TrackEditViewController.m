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
@property (retain,nonatomic) AVAudioPlayer *audioPlayer;
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
@synthesize nameOfTrackButton;
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize fileOfTrack;

- (IBAction)play:(id)sender {
    
    NSString *fileDate = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
        
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    NSString *docPathList = [pathList objectAtIndex:0];
    NSString *soundFilePath =[docPathList stringByAppendingPathComponent:fileDate];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.fileOfTrack = newURL;
    [newURL release];

    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithContentsOfURL:self.fileOfTrack error:nil];
    self.audioPlayer = player;
    [player release];

    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (IBAction)recordOrStop:(id)sender {
    if (recording) {
        [self.audioRecorder stop];
        recording = false;
        self.audioRecorder = nil;
        [self.voiceButton setTitle: @"Rerecord" forState:UIControlStateNormal];
        [self.voiceButton setTitle: @"Rerecord" forState:UIControlStateHighlighted];
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryRecord error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                                       [NSNumber numberWithInt: kAudioFormatAppleLossless],  AVFormatIDKey,
                                       [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                       [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey, nil];
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                NSUserDomainMask,   
                                                                YES);
        //Deleting old track
        NSString *docPathList = [pathList objectAtIndex:0];
        NSString *file = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
        NSString *oldSoundFilePath = [docPathList stringByAppendingPathComponent:file];
        NSURL *oldURL = [[NSURL alloc] initFileURLWithPath:oldSoundFilePath];
        AVAudioRecorder *oldRecorder = [[AVAudioRecorder alloc] initWithURL:oldURL
                                                                   settings:recordSettings 
                                                                      error:nil];
        [oldRecorder deleteRecording];
        [oldRecorder release];
        [oldURL release];
        
        //Creation new track
        //Creation dateFile
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        NSString *fileDate = [dateString stringByAppendingPathExtension:@"caf"];
        [self.trackNameButton setTitle:dateString forState:0];
        
        NSString *soundFilePath =[docPathList stringByAppendingPathComponent:fileDate];
        NSURL *newURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
        self.fileOfTrack = newURL;
        [newURL release];
        
        //Creation recorder
        AVAudioRecorder *newRecorder =[[AVAudioRecorder alloc] initWithURL:self.fileOfTrack 
                                                                  settings:recordSettings 
                                                                     error:nil];
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
        
        if (self.trackNameButton.titleLabel.text && self.groupNameButton.titleLabel.text) {
            ManagerSingleton *manager = [ManagerSingleton instance];
            [manager renameTrack:self.nameOfTrackButton ToNewTrack:self.trackNameButton.titleLabel.text];
            [manager saveData];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationRenameTrack object:nil];
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
    [self.trackNameButton setTitle:self.nameOfTrackButton forState:0];
    [self.groupNameButton setTitle:[manager searchGroupThoseTrackBelongRo:self.nameOfTrackButton] forState:0];
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *oldNameOfTrack = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    NSString *docPathList = [pathList objectAtIndex:0];
    NSString *soundFilePath =[docPathList stringByAppendingPathComponent:oldNameOfTrack];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.fileOfTrack = newURL;
       
    NSString *newNameOfTrack = [name stringByAppendingPathExtension:@"caf"];
    NSString *soundNewFilePath =[docPathList stringByAppendingPathComponent:newNameOfTrack];
    newURL = [[NSURL alloc] initFileURLWithPath: soundNewFilePath];
    
    [fileManager moveItemAtURL:self.fileOfTrack toURL:newURL error:nil];
    self.fileOfTrack = newURL;
    [newURL release];
    [self.trackNameButton setTitle:name forState:0];
    
    if (self.trackNameButton.titleLabel.text && self.groupNameButton.titleLabel.text) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [manager renameTrack:self.nameOfTrackButton ToNewTrack:self.trackNameButton.titleLabel.text];
        [manager saveData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationRenameTrack object:nil];
}

- (void)setNewNameOnButton:(NSString *)name {
    [self.groupNameButton setTitle:name forState:0];
    if (self.trackNameButton.titleLabel.text && self.groupNameButton.titleLabel.text) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [manager removeTrack:self.trackNameButton.titleLabel.text AtNewGroup:self.groupNameButton.titleLabel.text];
        [manager saveData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationRenameTrack object:nil];
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
