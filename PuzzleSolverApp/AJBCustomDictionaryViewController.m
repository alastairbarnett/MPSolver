//
//  AJBCustomDictionaryViewController.m
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 30/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import "AJBCustomDictionaryViewController.h"

@implementation AJBCustomDictionaryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Set table view background image
    self.tableView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"plainPaperBackgroundImage.png"]];
    
    //Show the navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //Iterate through all cells
    //If the text of any existent cells is empty, the cell must have been removed by being deleted in the detail view
    //If this is the case, the word must be deleted from the dictionary
    //Else, re-add the word to the dictionary to update it incase it was edited
    for(int iterator = 0;iterator<self.customWordArray.count;iterator++){
        //If the string is empty, remove the cell, delete the word from Core Data and delete the word from the dictionary
        if([[[self.customWordArray objectAtIndex:iterator] word] isEqualToString:@""] || [[self.customWordArray objectAtIndex:iterator] word]==nil){
            //Remove from Core Data
            [self.managedObjectContext deleteObject:[self.customWordArray objectAtIndex:iterator]];
            
            //Remove from word array(i.e. table view)
            [self.customWordArray removeObjectAtIndex:iterator];
            
            //Remove from dictionary, use wordPriorToEditing to refer to the word
            [self.dictionary removeWord:self.wordPriorToEditing];
            
            //save Core Data
            NSError *error = nil;
            [self.managedObjectContext save:&error];
        }
        else{
            //Re add the word to the dictionary to update the dictionary's definition
            AJBDiskStoredWord * currentWord=[self.customWordArray objectAtIndex:iterator];
            [self.dictionary addWord:currentWord.word withDefinition:currentWord.definition andAnagram:currentWord.anagram asBaseWord:NO];
        }
    }
    
    //Sort the cells by name, this must be done because core data order of strings is inconsistent
    
    NSArray *sortedArray;
    
    //Uses custom comparison by creating a block
    sortedArray = [self.customWordArray sortedArrayUsingComparator:^NSComparisonResult(AJBDiskStoredWord* firstWord, AJBDiskStoredWord* secondWord){
        return [firstWord.word compare:secondWord.word];
    }];
    self.customWordArray=[[NSMutableArray alloc] initWithArray:sortedArray];
    
    //Reload the data
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Fetch managed object context
    self.managedObjectContext = [(AJBAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    
    //Get entity description
    NSEntityDescription *wordEntityDescription = [NSEntityDescription entityForName:@"AJBDiskStoredWord" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *wordFetchRequest = [[NSFetchRequest alloc] init];
    
    // Associate the entity description with the fetch request
    [wordFetchRequest setEntity:wordEntityDescription];
    
    // Execute the query and store the fetch results in the temporary newCustomWordsArray
    NSError *error = nil;
    NSArray *newCustomWordsArray = [self.managedObjectContext executeFetchRequest:wordFetchRequest error:&error];
    
    // Assign to the instance variable
    self.customWordArray = [NSMutableArray arrayWithArray:newCustomWordsArray];
        
    //Initialize table view with editing enabled and allowing selection
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.editing=TRUE;
    self.tableView.allowsSelectionDuringEditing=TRUE;
}

- (void)viewDidUnload
{
    [self setAddButton:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Always one secton
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section, will be the object count of the array
    return self.customWordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell as object at array index of row
    AJBDiskStoredWord *wordForCell=[self.customWordArray objectAtIndex:indexPath.row];
    
    //Main text is word
    cell.textLabel.text=wordForCell.word;
    
    //Subtitle is definition
    cell.detailTextLabel.text=wordForCell.definition;
    
    //Show disclosure indicator
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // All items are editable
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from Core Data, Table View and dictionary
        
        //Remove from Core Data
        [self.managedObjectContext deleteObject:[self.customWordArray objectAtIndex:indexPath.row]];
        
        //Remove word from dictionary
        [self.dictionary removeWord:[[self.customWordArray  objectAtIndex:indexPath.row] word]];
        
        //Remove from data source (array of words)
        [self.customWordArray removeObjectAtIndex:indexPath.row];
        
        //Save Core Data
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        
        //Remove from table view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}


-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    //Declare detail view controller and assign it with the destrination view controller
    AJBCustomDictionaryDetailViewController * customDictionaryDetailViewController=segue.destinationViewController;
    
    //If the segue must create a new word allocate and store it then pass it as the detail item
    if([segue.identifier isEqualToString:@"newWord"]){
        
        //Initialize new word as AJBWord to compute the anagram
        AJBWord *newWord =[[AJBWord alloc]initWithWord:@"" andDefinition:@""];
        
        //Initialize new word as AJBDiskStoredWord and add it to Core Data in addition to the table view
        
        //Add to Core Data
        AJBDiskStoredWord *newDiskStoredWord=[NSEntityDescription insertNewObjectForEntityForName:@"AJBDiskStoredWord" inManagedObjectContext:self.managedObjectContext];
        newDiskStoredWord.word=newWord.word;
        newDiskStoredWord.definition=newWord.definition;
        newDiskStoredWord.anagram=newWord.anagram;
        
        
        //Add to the table view and data source
        [self.customWordArray insertObject:newDiskStoredWord atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //Save Core Data
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        
        //Pass word as detail item
        customDictionaryDetailViewController.word=newDiskStoredWord;
    }
    //Cell already exists
    else{
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        //Pass word as detail item
        customDictionaryDetailViewController.word=[self.customWordArray objectAtIndex:indexPath.row];
        
        //Save word before editing it
        self.wordPriorToEditing=customDictionaryDetailViewController.word.word;
    }
    
}

@end