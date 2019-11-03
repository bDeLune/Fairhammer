//
//  AllTimesForDateViewController.m
//  FairHammer
//
//  Created by barry on 26/02/2014.
//  Copyright (c) 2014 barry. All rights reserved.
//

#import "AllTimesForDateViewController.h"

@interface AllTimesForDateViewController ()
{
    NSMutableDictionary  *_userData;
    NSDate  *_mainDate;
    NSArray  *_sortedDates;
    NSArray  *_sortedDateKeysForDate;

    NSArray  *_dataForDay;


}
@end

@implementation AllTimesForDateViewController

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
    return [_sortedDateKeysForDate count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 0, tableView.frame.size.width,20 )];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel  *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 330,20 )];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];
    
    NSDate  *date=[_sortedDateKeysForDate objectAtIndex:section];
    NSString  *datestring=[dateFormat stringFromDate:date];
    //  [label setText:attemptDateString];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:20.0]];
    [label setTextColor:[UIColor blackColor]];
    [label setText:datestring];
    [view addSubview:label];
    return view;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];

    NSMutableDictionary  *allscores=[_userData objectForKey:@"allscores"];
    NSDate  *date=[_sortedDateKeysForDate objectAtIndex:indexPath.section];
    NSDictionary  *scoredata=[allscores objectForKey:[dateFormat stringFromDate:date]];
    NSString  *strength=[scoredata objectForKey:@"strength"];
    NSString  *difficulty=[scoredata objectForKey:@"difficulty"];
    NSString  *direction=[scoredata objectForKey:@"direction"];

    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            
            //  NSNumber  *thenumber=[dict objectForKey:@"bestduration"];
            [cell.textLabel setText:[NSString stringWithFormat:@"Strength : %@",strength]];
            break;
        case 1:
            [cell.textLabel setText:[NSString stringWithFormat:@"Difficulty : %@",difficulty]];

            break;
        case 2:
            [cell.textLabel setText:[NSString stringWithFormat:@"Breath : %@",direction]];
            
            break;
            
        default:
            break;
    }

    return cell;
}
-(void)makeAllDatesFromNoTime:(NSDate*)date
{
    
    NSMutableArray *tempArray=[NSMutableArray new];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    for (NSDate *date in _sortedDates) {
        if ([[dateFormat stringFromDate:date] isEqualToString:[dateFormat stringFromDate:_mainDate]])
        {
            //It's the same day
            NSMutableDictionary  *allscoresForUser=[_userData objectForKey:@"allscores"];

            NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
            [dateFormat2 setDateFormat:@"d MMM y H:m:s"];
            
            NSString  *datestring=[dateFormat2 stringFromDate:date];
            
            NSDictionary  *scoredata=[allscoresForUser objectForKey:datestring];
            NSString  *strength=[scoredata objectForKey:@"strength"];

            if ([strength floatValue]>0.0) {
                [tempArray addObject:date];

            }
            
        }
        
    }
    
    
   // NSMutableDictionary  *allscoresForUser=[_userData objectForKey:@"allscores"];
   // NSArray  *dateStrings=[allscoresForUser allKeys];

    [tempArray sortUsingSelector:@selector(compare:)];
    
    _sortedDateKeysForDate=[NSArray arrayWithArray:tempArray];

    
    
}

-(void)setUSerData:(NSMutableDictionary*)userData forDate:(NSDate*)date;
{
    _userData=userData;
    _mainDate=date;
    
    
    NSMutableDictionary  *allscoresForUser=[_userData objectForKey:@"allscores"];
    NSArray  *dateStrings=[allscoresForUser allKeys];
   // NSArray  *allvalues=[allscoresForUser allValues];
    
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
    
    _sortedDates=[NSArray arrayWithArray:dateArray];
    [self makeAllDatesFromNoTime:_mainDate];
   // sortedDateKeys=[NSArray arrayWithArray:dateArray];
   // [self makeDateArrayNoTimes];
    [self.tableView reloadData];

}
@end
