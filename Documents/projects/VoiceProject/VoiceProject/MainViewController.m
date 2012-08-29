//
//  ViewController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "XTableController.h"
#import "ManagerSingleton.h"

@interface MainViewController ()
   
@property (retain, nonatomic) XTableController *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfGroups;
@property (retain, nonatomic) IBOutlet UIButton *selectGroup;



@end

@implementation MainViewController {
     NSMutableArray *groups;
}

@synthesize xcontroller;
@synthesize tableOfGroups;
@synthesize selectGroup;


- (IBAction)voiceButton:(UIButton *)sender {
}


- (IBAction)plusButton:(id)sender {
}

- (IBAction)editButton:(UIBarButtonItem *)sender {
}


- (void)viewDidLoad
{
    ManagerSingleton *manager = [ManagerSingleton instance];
    XTableController *controller = [[XTableController alloc]
                                    initWithArray:manager.arrayOfGroups];
    self.xcontroller = controller;
    [controller release];
    [self.selectGroup setTitle:<#(NSString *)#> forState:nil];
    [self.tableOfGroups setDelegate: self.xcontroller];
    [self.tableOfGroups setDataSource: self.xcontroller];
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setTableOfGroups:nil];
    [self setSelectGroup:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [xcontroller release];
    [tableOfGroups release];
    [selectGroup release];
    [super dealloc];
}
@end
