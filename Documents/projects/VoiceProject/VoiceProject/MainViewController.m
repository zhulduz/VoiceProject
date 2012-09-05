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

@end

@implementation MainViewController 

NSString *const keyForNotification = @"reloadTableOfGroup";

@synthesize xcontroller;
@synthesize tableOfGroups;
@synthesize selectGroup;
@synthesize voiceButton;

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

- (void)viewDidUnload
{
    [self setTableOfGroups:nil];
    [self setSelectGroup:nil];
    [self setVoiceButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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
