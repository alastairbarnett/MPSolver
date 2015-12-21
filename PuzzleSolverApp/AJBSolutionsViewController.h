//
//  AJBSolutionsViewController.h
//  PuzzleSolverApp
//
//  Created by Alastair Barnett on 17/10/12.
//  Copyright (c) 2012 Alastair Barnett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleSolvers.h"

@interface AJBSolutionsViewController : UITableViewController<UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *solutions;
@property(nonatomic,strong)NSIndexPath *currentSelectedCell;
-(void)setDetailItem:(NSMutableArray*)detailItem;
@end
