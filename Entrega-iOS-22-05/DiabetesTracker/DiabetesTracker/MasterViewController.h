//
//  MasterViewController.h
//  DiabetesTracker
//
//  Created by Tadeu Dutra on 5/20/13.
//  Copyright (c) 2013 Universidade Positivo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
