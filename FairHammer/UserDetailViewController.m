//
//  UserDetailViewController.m
//  FairHammer
//
//  Created by barry on 12/09/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "UserDetailViewController.h"
#import "SessionHeaderViewController.h"
#import "SessionNoteViewController.h"
@interface UserDetailViewController ()
{
    NSMutableDictionary  *_userData;
    NSArray  *sortedDateKeys;
    UIPopoverController  *thispopover;
}
@end

@implementation UserDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setUSerData:(NSMutableDictionary*)userData
{
    _userData=userData;
    
    NSMutableDictionary  *allscoresForUser=[_userData objectForKey:@"allscores"];
    NSArray  *dateStrings=[allscoresForUser allKeys];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d MMM y H:m:s"];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSString *dateString in dateStrings) {
        NSDate *date = [formatter dateFromString:dateString];
        if (date) [dateArray addObject:date];
        // If the date is nil, the string wasn't a valid date.
        // You could add some error reporting in that case.
    }
    [dateArray sortUsingSelector:@selector(compare:)];
    
    sortedDateKeys=[NSArray arrayWithArray:dateArray];
    
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 60.0;
 }
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSDictionary  *dict=[_userData objectForKey:@"allscores"];
    NSArray  *keys=[dict allKeys];
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDate  *date=[sortedDateKeys objectAtIndex:indexPath.section];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];
    NSString *attemptDateString = [dateFormat stringFromDate:date];
    
    NSDictionary  *dict=[_userData objectForKey:@"allscores"];
    NSDictionary  *dict2=[dict objectForKey:attemptDateString];

    NSNumber  *t=[dict2 objectForKey:@"duration"];
    float val=[t floatValue];
    switch (indexPath.row) {
        case 0:
            
            //  NSNumber  *thenumber=[dict objectForKey:@"bestduration"];
            cell.textLabel.text=[NSString stringWithFormat:@"Best Duration : %0.1f",val];
            break;
        case 1:
            cell.textLabel.text=[NSString stringWithFormat:@"Best Strength : %@",[dict2 valueForKey:@"strength"]];
            
            break;
                    
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
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

-(void)addShowNoteForSection:(id)sender
{
    
   
    UIButton  *button=(UIButton*)sender;
    int tag=button.tag-1;
    SessionNoteViewController  *notecontroller=[[SessionNoteViewController alloc]initWithNibName:@"SessionNoteViewController" bundle:nil];
    notecontroller.userdata=_userData;
    NSDate  *date=[sortedDateKeys objectAtIndex:tag];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];
    NSString *attemptDateString = [dateFormat stringFromDate:date];
    notecontroller.date=attemptDateString;
    notecontroller.textView.userInteractionEnabled=YES;
    notecontroller.textView.editable=YES;
    
    [self resignFirstResponder];
  
    [self presentViewController:notecontroller animated:YES completion:nil];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 0, tableView.frame.size.width,60 )];
    [view setBackgroundColor:[UIColor blackColor]];
    UILabel  *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 330,60 )];
    UIButton  *notebutton=[UIButton buttonWithType:UIButtonTypeContactAdd];
    notebutton.frame=CGRectMake(400, 10, 30, 30);
    
    NSDate  *date=[sortedDateKeys objectAtIndex:section];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];
    NSString *attemptDateString = [dateFormat stringFromDate:date];
    [view addSubview:label];
    [view addSubview:notebutton];
    notebutton.tag=section+1;
    [notebutton addTarget:self action:@selector(addShowNoteForSection:) forControlEvents:UIControlEventTouchUpInside];
    [label setText:attemptDateString];
    [label setBackgroundColor:[UIColor blackColor]];
    [label setFont:[UIFont boldSystemFontOfSize:30.0]];
    [label setTextColor:[UIColor lightTextColor]];
    return view;

}
@end
