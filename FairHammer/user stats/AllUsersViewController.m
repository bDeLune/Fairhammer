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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)notesAdded:(NSNotification*)notification

{
    [self.navigationController popToRootViewControllerAnimated:NO];
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    
    // if ([dict count]>[allUsers count]) {
    
    [allUsers removeAllObjects];
    allUsers=[NSMutableArray arrayWithArray:[dict allKeys]];
    
    [allUsersDetails removeAllObjects];
    allUsersDetails=[NSMutableArray arrayWithArray:[dict allValues]];
    
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{

    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    
   // if ([dict count]>[allUsers count]) {
        
        [allUsers removeAllObjects];
        allUsers=[NSMutableArray arrayWithArray:[dict allKeys]];
    
        [allUsersDetails removeAllObjects];
        allUsersDetails=[NSMutableArray arrayWithArray:[dict allValues]];
        
        [self.tableView reloadData];
   // }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [allUsers count];
   // return [allUsers objectAtIndex:section.se];
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
    
    // Configure the cell...
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Users";
        self.tabBarItem.image = [UIImage imageNamed:@"Menu-Users"];
        
              //  bgimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SettingsScreenBackground"]];
        // [self.view insertSubview:bgimage atIndex:0];
        
    }
    return self;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *dict= [self getUserForUsername:[allUsers objectAtIndex:indexPath.row]];
     UserDetailViewController *detailViewController = [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
    [detailViewController setUSerData:[dict mutableCopy]];
     // ...
     // Pass the selected object to the new view controller.
    NSString  *username=[allUsers objectAtIndex:indexPath.row];
    detailViewController.title=username;
    [self.navigationController pushViewController:detailViewController animated:YES];
     
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString  *name=[allUsers objectAtIndex:indexPath.row];
    
    // Remove the row from data model
    
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    NSMutableDictionary  *mdict=[dict mutableCopy];
    [mdict removeObjectForKey:name];
    [[NSUserDefaults standardUserDefaults]setObject:mdict forKey:@"users"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
        
        [allUsers removeAllObjects];
        allUsers=[NSMutableArray arrayWithArray:[mdict allKeys]];
        
        [allUsersDetails removeAllObjects];
        allUsersDetails=[NSMutableArray arrayWithArray:[mdict allValues]];
        
        [tableView reloadData];
    }

    
@end
