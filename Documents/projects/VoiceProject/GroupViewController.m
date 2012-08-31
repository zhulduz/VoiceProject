//
//  GroupViewControllerViewController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupViewController.h"
#import "XTableController.h"
#import "ManagerSingleton.h"

@interface GroupViewController ()

@property (retain, nonatomic) XTableController *xcontroller;
@property (retain, nonatomic) IBOutlet UITableView *tableOfGroups;

@end

@implementation GroupViewController {
    id<RenameButton> groupDelegate;
}

@synthesize tableOfGroups;
@synthesize xcontroller;
@synthesize groupDelegate;

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
    XTableController *controller = [[XTableController alloc]
                                 initWithArray:manager.arrayOfGroups];
 
    self.xcontroller = controller;
    [controller release];
    [self.tableOfGroups setDelegate: self];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
/*- (void)help {
    if ((self.groupDelegate != nil) && [self.groupDelegate respondsToSelector:@selector(setNewNameOnButton:)]) {
        [self performSelector:@selector(setNewNameOnButton:) withObject:@"ppp"];
    NSLog(@"help");
    }

}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //SEL selector = @selector(setNewNameOnButton:);
    if ((self.groupDelegate != nil) && [self.groupDelegate respondsToSelector:@selector(setNewNameOnButton:)]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self performSelector:@selector(setNewNameOnButton:) withObject:cell.textLabel.text];
    }
}

- (void)dealloc {
    [tableOfGroups release];
    [super dealloc];
}
@end
