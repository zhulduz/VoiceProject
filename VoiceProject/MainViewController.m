//
//  ViewController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "XEditTableController.h"
#import "ManagerSingleton.h"
#import "TrackViewController.h"

@interface MainViewController ()

@property (retain, nonatomic) XEditTableController *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfGroups;
@property (retain, nonatomic) IBOutlet UIButton *selectGroup;

@property (retain, nonatomic) IBOutlet UIButton *voiceButton;
@property (retain, nonatomic) AVAudioRecorder *audioRecorder;
@property (retain, nonatomic) NSURL *fileOfTracks;

- (IBAction)recordOrStop:(id)sender;
- (IBAction)play;

@end

@implementation MainViewController {
    AVAudioRecorder *audioRecorder;
    NSURL *fileOfTracks;
    BOOL recording;
}


NSString *const keyForNotification = @"reloadTableOfGroup";

@synthesize xcontroller;
@synthesize tableOfGroups;
@synthesize selectGroup;
@synthesize voiceButton;
@synthesize audioRecorder;
@synthesize fileOfTracks;

- (IBAction)plusButton:(id)sender {
}

- (IBAction)editButton:(UIBarButtonItem *)sender {
}

- (void)viewDidLoad
{
    ManagerSingleton *manager = [ManagerSingleton instance];
    XEditTableController *controller = [[XEditTableController alloc]
                                    initWithArray:[manager arrayOfGroups]];
    self.xcontroller = controller;
    [controller release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reloadTableOfGroup:) 
                                                 name:keyForNotification 
                                               object:nil];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *edit =[[[UIBarButtonItem alloc] 
                             initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                             target:self
                             action:@selector(editing)] autorelease];
    self.navigationItem.leftBarButtonItem = edit;
    
    [self.tableOfGroups setDelegate: self];
    [self.tableOfGroups setDataSource: self.xcontroller];
    [super viewDidLoad];
    [self.selectGroup setTitle:[manager.arrayOfGroups objectAtIndex:0] forState:0];
    
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                            NSUserDomainMask,   
                                                            YES);
    NSString *docPathList = [pathList objectAtIndex:0];
    NSString *soundFilePath =[docPathList stringByAppendingPathComponent:@"tracks.caf"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    self.fileOfTracks = newURL;
    [newURL release];
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:44100.0], AVSampleRateKey, [NSNumber numberWithInt:kAudioFormatAppleLossless], AVFormatIDKey, [NSNumber numberWithInt:1], AVNumberOfChannelsKey, [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey, nil];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:newURL settings:recordSettings error:nil];
    recording = false;
}

-(IBAction)play
{
    AVAudioPlayer *player =[[AVAudioPlayer alloc] initWithContentsOfURL:self.fileOfTracks error:nil];
    
    [player prepareToPlay];
    [player play];
}

- (IBAction) recordOrStop:(id)sender {
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
        AVAudioRecorder *newRecorder =[[AVAudioRecorder alloc] initWithURL:self.fileOfTracks 
                                                                  settings: recordSettings error: nil];
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

- (void)reloadTableOfGroup:(NSNotification *)notification {
    [self.tableOfGroups reloadData];    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:keyForNotification object:nil];
}

- (void)editing {
    [self.tableOfGroups setEditing:!self.tableOfGroups.editing animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupViewControllerSegue"]) {
        GroupViewController *groupViewController = [segue destinationViewController];
        groupViewController.groupDelegate = self;
    }
    if ([[segue identifier] isEqualToString:@"TrackViewControllerSegue"]) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        TrackViewController *trackViewController = [segue destinationViewController];
        trackViewController.arrayOfTracks =  [manager getAllTracksOfTheGroup:(NSMutableString *)sender];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"TrackViewControllerSegue" sender:cell.textLabel.text];
}

- (void)viewDidUnload {
    [self setTableOfGroups:nil];
    [self setSelectGroup:nil];
    [self setVoiceButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)setNewNameOnButton:(NSString *)name {
    [self.selectGroup setTitle:name forState:0];
}

- (void)dealloc {
    [xcontroller release];
    [tableOfGroups release];
    [selectGroup release];
    [voiceButton release];
    [super dealloc];
}
@end
