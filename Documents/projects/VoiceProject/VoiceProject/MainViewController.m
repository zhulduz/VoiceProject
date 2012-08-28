//
//  ViewController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "XTableController.h"

@interface MainViewController ()
   
@property (retain, nonatomic) XTableController *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfGroups;


@end

@implementation MainViewController {
     NSMutableArray *groups;
}

@synthesize xcontroller;
@synthesize tableOfGroups;
@synthesize groups;


- (IBAction)voiceButton:(UIButton *)sender {
}


- (IBAction)plusButton:(id)sender {
}

- (IBAction)editButton:(UIBarButtonItem *)sender {
}

- (IBAction)groupButton:(UIButton *)sender {
    //create new window of groups
    
}

- (void)viewDidLoad
{
    self.groups = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    XTableController *controller = [[XTableController alloc]
                                    initWithArray:self.groups];
    self.xcontroller = controller;
    [controller release];
    [tableOfGroups setDelegate: self.xcontroller];
    [tableOfGroups setDataSource: self.xcontroller];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setTableOfGroups:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [xcontroller release];
    [tableOfGroups release];
    [groups release];
    [super dealloc];
}
@end
