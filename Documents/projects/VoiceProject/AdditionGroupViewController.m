//
//  AdditionGroupViewController.m
//  VoiceProject
//
//  Created by trainee on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdditionGroupViewController.h"
#import "ManagerSingleton.h"

@interface AdditionGroupViewController ()
@property (retain, nonatomic) IBOutlet UITextField *additionalGroup;

@end

@implementation AdditionGroupViewController

@synthesize additionalGroup;

- (IBAction)addGroup:(id)sender {
    ManagerSingleton *manager = [ManagerSingleton instance];
    if (self.additionalGroup.text) {
        [manager.arrayOfGroups addObject:self.additionalGroup.text];
        [manager saveData];
    }
}

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload
{
    [self setAdditionalGroup:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [additionalGroup release];
    [super dealloc];
}
@end
