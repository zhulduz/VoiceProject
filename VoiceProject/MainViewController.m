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
@property (retain, nonatomic) NSURL *fileOfTrack;
@property (retain, nonatomic) NSString *nameOfTrack;


- (IBAction)recordOrStop:(id)sender;

@end

@implementation MainViewController {
    AVAudioRecorder *audioRecorder;
    BOOL recording;
}

NSString *const keyForNotificationAddGroup = @"reloadTableOfGroup";

@synthesize xcontroller;
@synthesize tableOfGroups;
@synthesize selectGroup;
@synthesize voiceButton;
@synthesize audioRecorder;
@synthesize fileOfTrack;
@synthesize nameOfTrack;

- (IBAction)plusButton:(id)sender {
}

- (IBAction)editButton:(UIBarButtonItem *)sender {
}

- (void)viewDidLoad {
    ManagerSingleton *manager = [ManagerSingleton instance];
    XEditTableController *controller = [[XEditTableController alloc]
                                        initWithArray:manager.arrayOfGroups];
    self.xcontroller = controller;
    [controller release];
    //Notification for reload table of group
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reloadTableOfGroup:) 
                                                 name:keyForNotificationAddGroup
                                               object:nil];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //Creation table
    [self.tableOfGroups setDelegate: self];
    [self.tableOfGroups setDataSource: self.xcontroller];
    [super viewDidLoad];
    [self.selectGroup setTitle:[manager.arrayOfGroups objectAtIndex:0] forState:0];
    
    //Instance for recordering mode
    recording = false;
    self.tableOfGroups.separatorColor = [UIColor grayColor];
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
        
        //Creation dateFile
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        NSString *fileDate = [dateString stringByAppendingPathExtension:@"caf"];
        self.nameOfTrack = dateString;
        
        NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                NSUserDomainMask,   
                                                                YES);
        NSString *docPathList = [pathList objectAtIndex:0];
        NSString *soundFilePath =[docPathList stringByAppendingPathComponent:fileDate];
        NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        self.fileOfTrack = newURL;
        [newURL release];
        
        //Creation recorder
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
        
        //Saving track
        ManagerSingleton *manager = [ManagerSingleton instance];
        if (self.fileOfTrack) {
            [manager isAddTrack:(self.nameOfTrack) atGroup:(self.selectGroup.titleLabel.text)];
            [manager saveData];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableOfGroups setEditing:editing animated:animated];
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    NSLog(@"success");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    NSLog(@"fail");
}

- (void)reloadTableOfGroup:(NSNotification *)notification {
    [self.tableOfGroups reloadData];    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupViewControllerSegue"]) {
        GroupViewController *groupViewController = [segue destinationViewController];
        groupViewController.groupDelegate = self;
    }
    if ([[segue identifier] isEqualToString:@"TrackViewControllerSegue"]) {
        TrackViewController *trackViewController = [segue destinationViewController];
        trackViewController.groupName = sender;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"TrackViewControllerSegue" sender:cell.textLabel.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)setNewNameOnButton:(NSString *)name {
    [self.selectGroup setTitle:name forState:0];
}

- (void)viewDidUnload {
    [self setTableOfGroups:nil];
    [self setSelectGroup:nil];
    [self setVoiceButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:keyForNotificationAddGroup object:nil];
    [audioRecorder release];
    [fileOfTrack release];
    [nameOfTrack release];
    [xcontroller release];
    [tableOfGroups release];
    [selectGroup release];
    [voiceButton release];
    [super dealloc];
}
@end

