//
//  AddViewController.h
//  DiabetesTracker
//
//  Created by Tadeu Dutra on 5/20/13.
//  Copyright (c) 2013 Universidade Positivo. All rights reserved.
//

#import "DetailViewController.h"

@interface AddViewController : DetailViewController{
    BOOL _keyboardVisible;
}


- (IBAction)save:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;
- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;

// Gravando plist
@property (strong, nonatomic) NSMutableArray *resultArray;

@end
