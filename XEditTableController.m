//
//  XEditTableController.m
//  VoiceProject
//
//  Created by trainee on 9/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XEditTableController.h"
#import "ManagerSingleton.h"

@interface XEditTableController ()

@property (retain, nonatomic) NSMutableArray *arrayOfData;

@end

@implementation XEditTableController {
    NSMutableArray *arrayOfData_;
}

@synthesize arrayOfData = arrayOfData_;

- (id)initWithArray:(NSMutableArray *)groups {
    if ((self = [super init])) {
        self.arrayOfData = groups;
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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [self.arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ManagerSingleton *manager = [ManagerSingleton instance];
        [self.arrayOfData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        [manager saveData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    ManagerSingleton *manager = [ManagerSingleton instance];
    [self.arrayOfData exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [manager saveData];
}

-(void)dealloc {
    [arrayOfData_ release];
    [super dealloc];
}

@end
