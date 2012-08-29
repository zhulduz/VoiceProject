//
//  GroupViewControllerViewController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import "XTableControllerForGroupClass.h"
#import "ManagerSingleton.h"

@interface GroupViewController ()

@property (retain, nonatomic) XTableControllerForGroupClass *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfGroups;

@end

@implementation GroupViewController

@synthesize tableOfGroups;
@synthesize xcontroller;

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
    XTableControllerForGroupClass *controller = [[XTableControllerForGroupClass alloc]
                                 initWithArray:manager.arrayOfGroups];
 
    self.xcontroller = controller;
    [controller release];
    [self.tableOfGroups setDelegate: self.xcontroller];
    [self.tableOfGroups setDataSource: self.xcontroller];
}

- (void)viewDidUnload
{
    [self setTableOfGroups:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tableOfGroups release];
    [super dealloc];
}
@end
