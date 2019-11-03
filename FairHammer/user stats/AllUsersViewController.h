//
//  AllUsersViewController.h
//  FairHammer
//
//  Created by barry on 16/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllUsersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)IBOutlet  UITableView  *tableView;
@end
