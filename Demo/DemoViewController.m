//
//  TFStackingSectionsTableViewController.h
//  TFStackingSectionsTableViewDemo
//
//  Created by Tony Mann on 6/1/14.
//  Copyright (c) 2014 TheFind. All rights reserved.
//

#import "DemoViewController.h"
#import "TFStackingSectionsTableView.h"

@interface DemoViewController ()
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *groups;
@property (nonatomic) NSArray *members;
@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.groups = @[@"Group A", @"Group B", @"Group C", @"Group D", @"Group E", @"Group F", @"Group G", @"Group H"];
    self.members = @[
        @[@"Brazil", @"Mexico", @"Croatia", @"Cameroon"],
        @[@"Netherlands", @"Chile", @"Spain", @"Australia"],
        @[@"Columbia", @"Greece", @"Côte D'Ivoire", @"Japan"],
        @[@"Costa Rica", @"Uraguay", @"Italy", @"England"],
        @[@"France", @"Switzerland", @"Ecuador", @"Honduras"],
        @[@"Argentina", @"Nigeria", @"Bosnia and Herzegovina", @"Iran"],
        @[@"Germany", @"USA", @"Portugal", @"Ghana"],
        @[@"Belgium", @"Algeria", @"Russia", @"Korea Republic"]
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.groups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.members[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *teams = self.members[indexPath.section];
    cell.textLabel.text = teams[indexPath.item];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groups[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    UILabel *label = [UILabel new];
    label.text = [@"  " stringByAppendingString:self.groups[section]];
    label.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0];
    label.textColor = [UIColor colorWithWhite:0.13f alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    return label;
}




@end
