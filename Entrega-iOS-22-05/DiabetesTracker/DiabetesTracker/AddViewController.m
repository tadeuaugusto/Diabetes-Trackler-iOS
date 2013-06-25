//
//  AddViewController.m
//  DiabetesTracker
//
//  Created by Tadeu Dutra on 5/20/13.
//  Copyright (c) 2013 Universidade Positivo. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Novo", @"DiabetesTracker");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.dataExame setHidden:FALSE];
    // [self.btEmailHidden setHidden:YES];
    [self.btEmailHidden setHidden:TRUE];
    
    // set Navigation Items
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Açao Cancelar
 */
- (IBAction)cancel:(UIButton *)sender{
    [self dismissModalViewControllerAnimated:YES];
}

/**
 Acao Salvar
 */
- (IBAction)save:(UIButton *)sender{
    
    if (self.resultado != nil) {
        [_resultArray removeObject:self.resultado];
        self.resultado = nil;
    }
    
    NSMutableDictionary *newRecord = [[NSMutableDictionary alloc] init];
    [newRecord setValue:self.jejum.text     forKey:@"jejum"];
    [newRecord setValue:self.cafe.text      forKey:@"cafe"];
    [newRecord setValue:self.preAlmoco.text forKey:@"preAlmoco"];
    [newRecord setValue:self.posAlmoco.text forKey:@"posAlmoco"];
    [newRecord setValue:self.preJanta.text  forKey:@"preJanta"];
    [newRecord setValue:self.posJanta.text  forKey:@"posJanta"];
    
    // NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [newRecord setValue:self.dataExame.date forKey:@"data"];
    
    // [newRecord setValue:self.dataExame.date forKey:@"data"];
    NSString *strDate = [dateFormatter stringFromDate:self.dataExame.date];
    // NSLog(strDate);
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:strDate
                          message:@"Registro salvo"
                          delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil];
    
    [alert show];
    
    
    
    [_resultArray addObject:newRecord];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 Tratamento para scroll quando for aberto o teclado nativo
 */
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    _keyboardVisible = NO;
    
}

/**
 Tratamento para scroll quando for aberto o teclado nativo
 */
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 Tratamento para scroll quando for aberto o teclado nativo
 */
- (void)keyboardDidShow:(NSNotification *)notif{
    if (_keyboardVisible)
        return;
    
    NSDictionary *info = [notif userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    // Modificar o tamanho da scrollView
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    self.scrollView.frame = viewFrame;
    
    _keyboardVisible = YES;
}

/**
 Tratamento para scroll quando for aberto o teclado nativo
 */
- (void)keyboardDidHide:(NSNotification *)notif{
    if (!_keyboardVisible)
        return;
    
    // Voltanto para full screen
    self.scrollView.frame = self.view.bounds;
    _keyboardVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
