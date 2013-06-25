//
//  DetailViewController.h
//  DiabetesTracker
//
//  Created by Tadeu Dutra on 5/20/13.
//  Copyright (c) 2013 Universidade Positivo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MFMailComposeViewController.h>

@interface DetailViewController : UIViewController<MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSDictionary *resultado;

@property (strong, nonatomic) IBOutlet UITextField *jejum;
@property (strong, nonatomic) IBOutlet UITextField *cafe;
@property (strong, nonatomic) IBOutlet UITextField *preAlmoco;
@property (strong, nonatomic) IBOutlet UITextField *posAlmoco;
@property (strong, nonatomic) IBOutlet UITextField *preJanta;
@property (strong, nonatomic) IBOutlet UITextField *posJanta;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIDatePicker *dataExame;

// Edit Action
- (IBAction)edit:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *btEmailHidden;
- (IBAction)btEmailPressed:(UIButton *)sender;


// evento para esconder o teclado
- (IBAction)backgroundTouched:(id)sender;

// Gravando plist
@property (strong, nonatomic) NSMutableArray *resultArrayEdit;

@end
