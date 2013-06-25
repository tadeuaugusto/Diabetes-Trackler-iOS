//
//  DetailViewController.m
//  DiabetesTracker
//
//  Created by Tadeu Dutra on 5/20/13.
//  Copyright (c) 2013 Universidade Positivo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _scrollView.contentSize = self.view.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detalhes", @"Diabetes");
        
        /** Devera ser usado em conjunto com a funcao <edit>,
         como o registro eh salvo sempre ao sair da tela <viewWillDisappear>
         resolvi nao implementar o botao de <Edit> na tela de Details
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
        **/
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    // usando UITextField
    _jejum.text     = [_resultado objectForKey:@"jejum"];
    _cafe.text      = [_resultado objectForKey:@"cafe"];
    _preAlmoco.text = [_resultado objectForKey:@"preAlmoco"];
    _posAlmoco.text = [_resultado objectForKey:@"posAlmoco"];
    _preJanta.text  = [_resultado objectForKey:@"preJanta"];
    // _dataExame.date = [_resultado objectForKey:@"data"];
    _posJanta.text  = [_resultado objectForKey:@"posJanta"];
    // _btEmailHidden.hidden = FALSE;
    
    // [self.btEmailHidden setHidden:FALSE];
    
    
    // Mostrando a data do header da pagina detail
    NSDate *savedDate = [_resultado objectForKey:@"data"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy/MM/dd"];
    NSString *strSavedDate = [formatter stringFromDate:savedDate];
    self.title = NSLocalizedString(strSavedDate, @"Diabetes");
    
    

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [_resultado setValue:_jejum.text forKey:@"jejum"];
    [_resultado setValue:_cafe.text forKey:@"cafe"];
    [_resultado setValue:_preAlmoco.text forKey:@"preAlmoco"];
    [_resultado setValue:_posAlmoco.text forKey:@"posAlmoco"];
    [_resultado setValue:_preJanta.text forKey:@"preJanta"];
    [_resultado setValue:_posJanta.text forKey:@"posJanta"];

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)edit:(UIButton *)sender{
    
    [_resultado setValue:_jejum.text forKey:@"jejum"];
    [_resultado setValue:_cafe.text forKey:@"cafe"];
    [_resultado setValue:_preAlmoco.text forKey:@"preAlmoco"];
    [_resultado setValue:_posAlmoco.text forKey:@"posAlmoco"];
    [_resultado setValue:_preJanta.text forKey:@"preJanta"];
    [_resultado setValue:_posJanta.text forKey:@"posJanta"];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"teste"
                          message:@"Registro atualizado"
                          delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles:nil];
    
    [alert show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btEmailPressed:(UIButton *)sender {
    
    
    NSMutableString *jejum = [NSMutableString stringWithFormat:@"Jejum: %@", [_resultado objectForKey:@"jejum"]];
    NSMutableString *cafe = [NSMutableString stringWithFormat:@"Café da Manha: %@", [_resultado objectForKey:@"cafe"]];
    NSMutableString *preAlmoco = [NSMutableString stringWithFormat:@"Pré-Almoço: %@", [_resultado objectForKey:@"preAlmoco"]];
    NSMutableString *posAlmoco = [NSMutableString stringWithFormat:@"Pós-Almoço: %@", [_resultado objectForKey:@"posAlmoco"]];
    NSMutableString *preJanta = [NSMutableString stringWithFormat:@"Pré-Janta: %@", [_resultado objectForKey:@"preJanta"]];
    NSMutableString *posJanta = [NSMutableString stringWithFormat:@"Pós-Janta: %@", [_resultado objectForKey:@"posJanta"]];

    
    NSString *breakline = @" \n";
    
    NSString *tJejum = [jejum stringByAppendingString:breakline];
    NSString *tCafe = [cafe stringByAppendingString:breakline];
    NSString *tPreAlmoco = [preAlmoco stringByAppendingString:breakline];
    NSString *tPosAlmoco = [posAlmoco stringByAppendingString:breakline];
    NSString *tPreJanta = [preJanta stringByAppendingString:breakline];
    NSString *tPosJanta = [posJanta stringByAppendingString:breakline];
    
    NSString *messageBody = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", tJejum, tCafe, tPreAlmoco, tPosAlmoco, tPreJanta, tPosJanta];
    
    
    // Email Subject
    NSString *emailTitle = @"Dados do Relatorio: ";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"tadeuaugusto@gmail.com"];

    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setTitle:emailTitle];
        [mailController setToRecipients:toRecipents];
        [mailController setSubject:emailTitle];
        [mailController setMessageBody:messageBody isHTML:NO];
        [self presentViewController:mailController animated:YES completion:nil];
    }
    else {
        NSString *strMsg = @"Sorry you need to setup email address first.";
        NSLog(strMsg);
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Email Service"
                              message:strMsg
                              delegate:nil
                              cancelButtonTitle:@"Close"
                              otherButtonTitles:nil];
        
        [alert show];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//Método do delegate do mail composer
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction)backgroundTouched:(id)sender
{
    [self.view endEditing:YES];
    // [sender resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
