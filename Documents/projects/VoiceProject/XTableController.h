//
//  XTableController.h
//  VoiceProject
//
//  Created by trainee on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTableController : NSObject<UITableViewDelegate, UITableViewDataSource> {

}

- (id)initWithArray:(NSMutableArray *)groups;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)index_path;

@end
