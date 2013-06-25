//
//  MasterViewController.m
//  DiabetesTracker
//
//  Created by Tadeu Dutra on 5/20/13.
//  Copyright (c) 2013 Universidade Positivo. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AddViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Diabetes", @"DiabetesTracker");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // carregando opçao de ediçao
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // LISTA INICIAL DE DATAS (exibindo do plist)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DiabetesTracker" ofType:@"plist"];
    _objects = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    
    // atualizando na plist
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    AddViewController	*addViewController = [[AddViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    /**
     Perceba que a modal view não possui título, não tem botões para ser dispensada, não possui uma navigation bar. Devemos adicioná-los aqui, na mao.
     */
    addViewController.title = NSLocalizedString(@"Add Exame", "Diabetes Tracker App");
    addViewController.resultArray = _objects;
    
    
    // UINavigationController
    UINavigationController *addNavController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self presentViewController:addNavController animated:YES completion:nil];

}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    /**
     NSDate *object = _objects[indexPath.row];
     cell.textLabel.text = [object description];
     */
    NSDate *savedDate = [[_objects objectAtIndex:indexPath.row] objectForKey:@"data"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy/MM/dd"];
    NSString *strSavedDate = [formatter stringFromDate:savedDate];
    
    
    cell.textLabel.text = strSavedDate;
    
    
    
    // Celula editavel atraves de um Disclosure Indicator
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editing){
        if (!self.detailViewController) {
            self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        }
        self.detailViewController.resultado = [_objects objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    } else {
        AddViewController *editingResultVC = [[AddViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        editingResultVC.resultado = [_objects objectAtIndex:indexPath.row];
        editingResultVC.resultArray = _objects;
        UINavigationController *editingNavControl = [[UINavigationController alloc] initWithRootViewController:editingResultVC];
        
        [self.navigationController presentModalViewController:editingNavControl animated:YES];
    }  
}


// atualizando o resultado da lista apos o insert de um novo item
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// Funciona para gravar o plist (somente no emulador)
- (void)applicationDidEnterBackground:(NSNotification *) notif{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DiabetesTracker" ofType:@"plist"];
    [_objects writeToFile:path atomically:YES];
}


- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
