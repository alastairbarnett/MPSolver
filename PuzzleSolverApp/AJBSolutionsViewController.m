//
//  AJBSolutionsViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 17/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBSolutionsViewController.h"

@implementation AJBSolutionsViewController

//Set the solutions list
-(void)setDetailItem:(NSMutableArray*)detailItem{
    self.solutions=[NSMutableArray arrayWithArray:detailItem];
    //Remove any empty words from the list
    for(AJBWord *iterator in self.solutions){
        if([filterNSStringToLowercaseCharacters(iterator.word) isEqualToString:@""])[self.solutions removeObject:iterator];
    }
}

-(void)viewDidLoad{
    //Initialize currentSelectedCell to nil to ensure that if there are no solutions the message box
    //will return from the view
    self.currentSelectedCell=nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Set background image
    self.tableView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"plainPaperBackgroundImage.png"]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //If the array is empty, display an alert view and return rather than dumping an empty table
    if(self.solutions.count==0){
        //Set delegate to self so alertView:clickedButtonAtIndex: action can be invoked
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Solutions Found"
                                                        message:@"No solutions were found for the puzzle that you have entered.\n(Sorry)"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        //Show alert
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //If currentSelectedCell is not nil then deselect it as the alert view displays a cell's definition
    if(self.currentSelectedCell){
        [self.tableView deselectRowAtIndexPath:self.currentSelectedCell animated:YES];
    }
    //Else return from segue to previous view controller (layer two) as the alert view indicates that no words were found
    else{
        UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:2];
        [self.navigationController popToViewController:previousViewController animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //Always one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Number of rows will be count of objects in the solutions array
    return self.solutions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    //Set cell text to be the text of the word of the row
    AJBWord * currentWord=[self.solutions objectAtIndex:indexPath.row];
    cell.textLabel.text=currentWord.word;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Retrive word
    AJBWord * wordForCurrentCell=[self.solutions objectAtIndex:[indexPath row]];
    
    //Test if a definition exists, if so, display it in a message box
    //If not, call the built in dictionary
    if(![wordForCurrentCell.definition isEqualToString:@""]){
        //Display a message box with the definition, declare with self as delegate
        UIAlertView *alert = [[UIAlertView alloc]
                       initWithTitle:[NSString stringWithFormat:@"Definition of \"%@\"",wordForCurrentCell.word]
                                                        message:wordForCurrentCell.definition
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        //Store the index path of the cell to deselect it when 'OK' is pressed
        self.currentSelectedCell=indexPath;
    }
    else{
        //Call built in dictionary
        UIReferenceLibraryViewController *reference = [[UIReferenceLibraryViewController alloc] initWithTerm:wordForCurrentCell.word];
        [self presentModalViewController:reference animated:YES];
    }
}

@end
