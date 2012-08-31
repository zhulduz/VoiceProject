//
//  Track.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrackViewController.h"
#import "XTableController.h"
#import "ManagerSingleton.h"
#import "MainViewController.h"

@interface TrackViewController ()

@property (retain, nonatomic) XTableController *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfTracks;

@end

@implementation TrackViewController

@synthesize xcontroller;
@synthesize tableOfTracks;
@synthesize arrayOfTracks;

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
    XTableController *controller = [[XTableController alloc]
                                    initWithArray:self.arrayOfTracks];
    self.xcontroller = controller;
    [controller release];
    [self.tableOfTracks setDelegate: self.xcontroller];
    [self.tableOfTracks setDataSource: self.xcontroller];
    [self setTableOfTracks:nil];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
       [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tableOfTracks release];
    [super dealloc];
}
@end
