//
//  AdditionTrackViewController.m
//  VoiceProject
//
//  Created by trainee on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdditionTrackViewController.h"
#import "ManagerSingleton.h"

@interface AdditionTrackViewController ()

@property (retain, nonatomic) IBOutlet UITextField *additionalTrack;

@end

@implementation AdditionTrackViewController {
    id<RenameTrack> trackDelegate;
}

@synthesize trackDelegate;
@synthesize additionalTrack;

- (IBAction)addTrack:(id)sender {
    ManagerSingleton *manager = [ManagerSingleton instance];
    if ([self.additionalTrack.text length] != 0) {
        if ([manager searchTrackWithName:self.additionalTrack.text] == false) {
            if ((self.trackDelegate != nil) && [self.trackDelegate respondsToSelector:@selector(setNewNameOfTrack:)]) {
                [self.trackDelegate performSelector:@selector(setNewNameOfTrack:) withObject:self.additionalTrack.text];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                            message:[NSString stringWithFormat:@"Track with name %@ is exist already", self.additionalTrack.text] 
                                                           delegate:self 
                                                  cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]; 
            [alert show];
            [alert release];

        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" 
                                                        message:@"Enter track name to add" 
                                                       delegate:self 
                                              cancelButtonTitle:@"Close" otherButtonTitles:nil, nil]; 
        [alert show];
        [alert release];

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
    [self setAdditionalTrack:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [additionalTrack release];
    [super dealloc];
}
@end
