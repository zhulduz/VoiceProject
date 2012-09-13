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
@property (retain, nonatomic) IBOutlet UISlider *aSlider;

@property (retain,nonatomic) AVAudioRecorder *audioRecorder;
@property (retain,nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) NSURL *fileOfTrack;
@property (retain, nonatomic) IBOutlet UILabel *trackDuration;


- (IBAction)play:(id)sender;
- (IBAction)recordOrStop:(id)sender;

@end

@implementation TrackEditViewController {
    BOOL recording;
    NSTimer *sliderTimer;
}

@synthesize groupNameButton;
@synthesize voiceButton;
@synthesize aSlider;
@synthesize trackNameButton;
@synthesize nameOfTrackButton;
@synthesize audioRecorder;
@synthesize audioPlayer;
@synthesize fileOfTrack;
@synthesize trackDuration;

- (NSString *)pathForTracks:(NSString *)fileName {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    NSString *docPathList = [pathList objectAtIndex:0];
    NSString *soundFilePath =[docPathList stringByAppendingPathComponent:fileName];
    return soundFilePath;
}

- (IBAction)stopPlay:(id)sender {
    if (self.audioPlayer.playing) {
        [self.audioPlayer stop];
        [sliderTimer invalidate];
        self.aSlider.value = 0;
    }
}

- (IBAction)play:(id)sender { 
    NSString *fileDate = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: [self pathForTracks:fileDate]];
    self.fileOfTrack = newURL;
    [newURL release];
    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithContentsOfURL:self.fileOfTrack 
                                                                  error:nil];
    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
                                                   target:self 
                                                 selector:@selector(updateSlider) 
                                                 userInfo:nil 
                                                  repeats:YES];
    self.aSlider.maximumValue = player.duration;
    [self.aSlider addTarget:self 
                     action:@selector(sliderChanged:) 
           forControlEvents:UIControlEventValueChanged];
    self.audioPlayer = player;
    [self.trackDuration setText:[NSString stringWithFormat:@"%f", self.audioPlayer.duration]];
    [player release];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)updateSlider {
    self.aSlider.value = self.audioPlayer.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    [self.audioPlayer stop];
    [self.audioPlayer setCurrentTime:self.aSlider.value];
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
        //Deleting old track
        NSString *file = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
        NSURL *oldURL = [[NSURL alloc] initFileURLWithPath:[self pathForTracks:file]];
        AVAudioRecorder *oldRecorder = [[AVAudioRecorder alloc] initWithURL:oldURL
                                                                   settings:recordSettings 
                                                                      error:nil];
        [oldRecorder deleteRecording];
        [oldRecorder release];
        [oldURL release];
        
        //Creation new track
        //Creation default name of track
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        NSString *fileDate = [dateString stringByAppendingPathExtension:@"caf"];
        [self.trackNameButton setTitle:dateString forState:0];
        
        NSURL *newURL = [[NSURL alloc] initFileURLWithPath:[self pathForTracks:fileDate]];
        self.fileOfTrack = newURL;
        [newURL release];
        
        //Creation recorder
        AVAudioRecorder *newRecorder =[[AVAudioRecorder alloc] initWithURL:self.fileOfTrack 
                                                                  settings:recordSettings 
                                                                     error:nil];
        
        self.audioRecorder = newRecorder;
        [newRecorder release];
        self.audioRecorder.delegate = self;
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder record];
        [self.voiceButton setTitle: @"Stop" forState: UIControlStateNormal];
        [self.voiceButton setTitle: @"Stop" forState: UIControlStateHighlighted];
        recording = true;
        [date release];
        [dateFormatter release];
        [recordSettings release];
        if ([self.trackNameButton.titleLabel.text length] != 0 && [self.groupNameButton.titleLabel.text length] != 0) {
            ManagerSingleton *manager = [ManagerSingleton instance];
            [manager renameTrack:self.nameOfTrackButton toNewTrack:self.trackNameButton.titleLabel.text];
            [manager saveData];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationRenameTrack 
                                                            object:nil];
    }

}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"success");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"fail");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    ManagerSingleton *manager = [ManagerSingleton instance];
    [self.trackNameButton setTitle:self.nameOfTrackButton forState:0];
    [self.groupNameButton setTitle:[manager searchGroupThoseTrackBelongTo:self.nameOfTrackButton] forState:0];
    [super viewDidLoad];
    recording = false;
    
    NSString *fileDate = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: [self pathForTracks:fileDate]];
    self.fileOfTrack = newURL;
    [newURL release];
    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithContentsOfURL:self.fileOfTrack error:nil];
    
    self.trackDuration.backgroundColor = [UIColor blueColor];
    [self.trackDuration setText:[NSString stringWithFormat:@"%f",player.duration]];
    [player release];
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
    NSString *oldName = self.trackNameButton.titleLabel.text;
    NSString *oldNameOfTrack = [self.trackNameButton.titleLabel.text stringByAppendingPathExtension:@"caf"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: [self pathForTracks:oldNameOfTrack]];
    self.fileOfTrack = newURL;
    
    NSString *newNameOfTrack = [name stringByAppendingPathExtension:@"caf"];
    newURL = [[NSURL alloc] initFileURLWithPath: [self pathForTracks:newNameOfTrack]];
   
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtURL:self.fileOfTrack toURL:newURL error:nil];
    self.fileOfTrack = newURL;
    [newURL release];
    
    [self.trackNameButton setTitle:name forState:0];
    
  //  if (self.trackNameButton.titleLabel.text && self.groupNameButton.titleLabel.text) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [manager renameTrack:oldName 
                  toNewTrack:name];
        [manager saveData];
  //  }
    [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationRenameTrack 
                                                        object:nil];
}

- (void)setNewNameOnButton:(NSString *)name {
    [self.groupNameButton setTitle:name forState:0];
    if (self.trackNameButton.titleLabel.text && self.groupNameButton.titleLabel.text) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [manager removeTrack:self.trackNameButton.titleLabel.text 
                  atNewGroup:self.groupNameButton.titleLabel.text];
        [manager saveData];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationRenameTrack 
                                                        object:nil];
}

- (void)viewDidUnload {
    
    [self setTrackNameButton:nil];
    [self setGroupNameButton:nil];
    [self setVoiceButton:nil];
    [self setASlider:nil];
    [self setTrackDuration:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [fileOfTrack release];
    [trackNameButton release];
    [groupNameButton release];
    [voiceButton release];
    [aSlider release];
    [trackDuration release];
    [super dealloc];
}
@end
