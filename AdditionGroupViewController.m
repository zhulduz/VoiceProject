//
//  AdditionGroupViewController.m
//  VoiceProject
//
//  Created by trainee on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdditionGroupViewController.h"
#import "ManagerSingleton.h"
#import "MainViewController.h"

@interface AdditionGroupViewController ()

@property (retain, nonatomic) IBOutlet UITextField *additionalGroup;

@end

@implementation AdditionGroupViewController

@synthesize additionalGroup;

- (IBAction)addGroup:(id)sender {
    if ([self.additionalGroup.text length] != 0) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        if ([manager isAddGroup:self.additionalGroup.text] == false) {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                          message:[NSString stringWithFormat:@"Group with name %@ is exist already", self.additionalGroup.text] 
                                                         delegate:self 
                                                cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]; 
            [alert show];
            [alert release];
        } else {
            [manager saveData];
            [[NSNotificationCenter defaultCenter] postNotificationName:keyForNotificationAddGroup object:nil]; 
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                        message:@"Enter group name to add" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]; 
        [alert show];
        [alert release];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)viewDidUnload {
    [self setAdditionalGroup:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [additionalGroup release];
    [super dealloc];
}
@end
