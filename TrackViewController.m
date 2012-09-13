//
//  Track.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackViewController.h"
#import "XTableController.h"
#import "MainViewController.h"
#import "TrackEditViewController.h"

@interface TrackViewController ()

@property (retain, nonatomic) XTableController *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfTracks;
@property (retain, nonatomic) NSString *nameOfcell;

@end

@implementation TrackViewController

NSString *const keyForNotificationRenameTrack = @"reloadTableOfTrack";

@synthesize xcontroller;
@synthesize tableOfTracks;
@synthesize nameOfcell;
@synthesize groupName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    XTableController *controller = [[XTableController alloc]
                                    initWithGroupName:self.groupName];
    self.xcontroller = controller;
    [controller release];
    
    //create table of tracks
    [self.tableOfTracks setDelegate: self];
    [self.tableOfTracks setDataSource: self.xcontroller];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(reloadTableOfTrack:) 
                                                 name:keyForNotificationRenameTrack
                                               object:nil];
}

- (void)reloadTableOfTrack:(NSNotification *)notification {
    [self.xcontroller reloadTracks];
    [self.tableOfTracks reloadData];  
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"TrackEditViewControllerSegue"]) {
        TrackEditViewController *trackEditViewController = [segue destinationViewController];
        trackEditViewController.nameOfTrackButton = sender;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.nameOfcell = cell.textLabel.text;
    [self performSegueWithIdentifier:@"TrackEditViewControllerSegue" sender:cell.textLabel.text];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload {
       [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:keyForNotificationRenameTrack object:nil];
    [tableOfTracks release];
    [super dealloc];
}
@end
