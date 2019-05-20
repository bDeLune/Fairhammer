//
//  AllUsersViewController.m
//  FairHammer
//
//  Created by barry on 16/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "AllUsersViewController.h"
#import "SessionNoteViewController.h"
#import "UserDetailViewController.h"
@interface AllUsersViewController ()
{
    NSMutableArray   *allUsers;
    NSMutableArray   *allUsersDetails;
}
@end

@implementation AllUsersViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    allUsers=[[NSMutableArray alloc]init];
    allUsersDetails=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notesAdded:) name:SESSION_NOTE_ADDED_NOTIFY object:nil];
}

-(void)notesAdded:(NSNotification*)notification
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    [allUsers removeAllObjects];
    allUsers=[NSMutableArray arrayWithArray:[dict allKeys]];
    
    [allUsersDetails removeAllObjects];
    allUsersDetails=[NSMutableArray arrayWithArray:[dict allValues]];
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
        
    [allUsers removeAllObjects];
    allUsers=[NSMutableArray arrayWithArray:[dict allKeys]];

    [allUsersDetails removeAllObjects];
    allUsersDetails=[NSMutableArray arrayWithArray:[dict allValues]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allUsers count];
}
-(NSDictionary*)getUserForUsername:(NSString*)pUsersname;

{
    NSDictionary  *result;
    
    for (int i=0; i<[allUsersDetails count]; i++) {
        NSDictionary   *dictionary=[allUsersDetails objectAtIndex:i];
        if ([[dictionary valueForKey:@"username"]isEqualToString:pUsersname]) {
            result=dictionary;
            return result;
        }
    }
  
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text=[allUsers objectAtIndex:indexPath.row];
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Users";
        self.tabBarItem.image = [UIImage imageNamed:@"Menu-Users"];
    }
    return self;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict= [self getUserForUsername:[allUsers objectAtIndex:indexPath.row]];
     UserDetailViewController *detailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    [detailViewController setUSerData:[dict mutableCopy]];
    NSString  *username=[allUsers objectAtIndex:indexPath.row];
    detailViewController.title=username;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString  *name=[allUsers objectAtIndex:indexPath.row];
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    NSMutableDictionary  *mdict=[dict mutableCopy];
    [mdict removeObjectForKey:name];
    [[NSUserDefaults standardUserDefaults]setObject:mdict forKey:@"users"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [allUsers removeAllObjects];
    allUsers=[NSMutableArray arrayWithArray:[mdict allKeys]];
        
    [allUsersDetails removeAllObjects];
    allUsersDetails=[NSMutableArray arrayWithArray:[mdict allValues]];
}
    
@end
