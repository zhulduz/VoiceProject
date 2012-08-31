//
//  XTableController.m
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XTableController.h"
#import "MainViewController.h"

@interface XTableController ()

@property (retain, nonatomic) NSArray *arrayOfData;

@end

@implementation XTableController {
    NSArray *arrayOfData_;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //Find cells
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //If cell was founded
    if (cell == nil) {
        //Creating cells
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.arrayOfData objectAtIndex:indexPath.row];
    
    return cell;
}



/*- (NSArray *) sectionIndexTitlesForTableView: (UITableView *) tableView {
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:@"Фрукты"];
    [values addObject:@"Овощи"];
    return values;
}*/

-(void)dealloc {
    [arrayOfData_ release];
    [super dealloc];
}

@end
