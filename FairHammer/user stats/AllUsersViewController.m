//
//  AllUsersViewController.m
//  FairHammer
//
//  Created by barry on 16/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "AllUsersViewController.h"

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
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewWillAppear:(BOOL)animated
{

    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    
    if ([dict count]>[allUsers count]) {
        
        [allUsers removeAllObjects];
        allUsers=[NSMutableArray arrayWithArray:[dict allKeys]];
    
        [allUsersDetails removeAllObjects];
        allUsersDetails=[NSMutableArray arrayWithArray:[dict allValues]];
        
        [self.tableView reloadData];
    }
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
    return [allUsers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
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
    
    NSDictionary  *dict=[self getUserForUsername:[allUsers objectAtIndex:indexPath.section]];
    NSNumber  *t=[dict objectForKey:@"bestduration"];
    float val=[t floatValue];
    switch (indexPath.row) {
        case 0:
            
          //  NSNumber  *thenumber=[dict objectForKey:@"bestduration"];
                       cell.textLabel.text=[NSString stringWithFormat:@"Best Duration : %0.1f",val];
            break;
        case 1:
            cell.textLabel.text=[NSString stringWithFormat:@"Best Strenth : %@",[dict valueForKey:@"beststrength"]];

            break;
        case 2:
            cell.textLabel.text=[NSString stringWithFormat:@"Last Login : %@",[dict valueForKey:@"lastlogin"]];

            break;
            
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel  *label=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 300,60 )];
    label.text=[allUsers objectAtIndex:section];
    [label setBackgroundColor:[UIColor blackColor]];
    [label setFont:[UIFont boldSystemFontOfSize:30.0]];
    [label setTextColor:[UIColor lightTextColor]];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
@end
