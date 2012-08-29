//
//  XTableControllerForGroupClass.h
//  VoiceProject
//
//  Created by trainee on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTableControllerForGroupClass : NSObject<UITableViewDelegate, UITableViewDataSource> {
    
}
- (id)initWithArray:(NSMutableArray *)groups;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)index_path;

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
