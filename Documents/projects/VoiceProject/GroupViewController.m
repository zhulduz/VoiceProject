//
//  GroupViewControllerViewController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import "MainViewController.h"
#import "XTableController.h"

@interface GroupViewController ()

@property (retain, nonatomic) XTableController *xcontroller;
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
    MainViewController *rootViewController = [[MainViewController alloc] init];
    XTableController *controller = [[XTableController alloc]
                                 initWithArray:rootViewController.groups];
    self.xcontroller = controller;
    [controller release];
    [tableOfGroups setDelegate: self.xcontroller];
    [tableOfGroups setDataSource: self.xcontroller];
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
 //   [tableOfGroups release];
//    [tableOfGroups release];
    [tableOfGroups release];
    [super dealloc];
}
@end
