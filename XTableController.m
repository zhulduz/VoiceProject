//
//  XTableController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XTableController.h"
#import "ManagerSingleton.h"


@interface XTableController ()

@property (retain, nonatomic) NSArray *arrayOfData;
@property (retain, nonatomic) NSString *group;

@end

@implementation XTableController {
    NSArray *arrayOfData_;
    NSString *group_;
}

@synthesize arrayOfData = arrayOfData_;
@synthesize group = group_;

- (id)initWithGroupName:(NSString *)nameOfGroup {
    if ((self = [super init])) {
        self.group = nameOfGroup;
        [self reloadTracks];
    }
    return self;
}

- (id)initArray {
    if ((self = [super init])) {
        self.arrayOfData = [ManagerSingleton instance].arrayOfGroups;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayOfData_ count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    //Find cells
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //If cell was founded
    if (cell == nil) {
        //Creating cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }

    cell.textLabel.text = [self.arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)reloadTracks {
    ManagerSingleton *manager = [ManagerSingleton instance];
    self.arrayOfData = [manager getAllTracksOfTheGroup:self.group];
}

-(void)dealloc {
    [arrayOfData_ release];
    [group_ release];
    [super dealloc];
}

@end
