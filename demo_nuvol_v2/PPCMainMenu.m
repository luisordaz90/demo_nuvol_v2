//
//  PPCMainMenu.m
//  demo_nuvol_v2
//
//  Created by Luis Ordaz on 6/9/14.
//  Copyright (c) 2014 Luis Ordaz. All rights reserved.
//

#import "PPCMainMenu.h"

@interface PPCMainMenu ()

@end

NSArray *titleArray;

@implementation PPCMainMenu

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    titleArray = [[NSArray alloc] initWithObjects:@"Inicio",@"Asistencia",@"Directorio",@"Nómina",@"Configuración", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickedCell:(NSIndexPath *)pathToCell{
    /*[_welcomeTable selectRowAtIndexPath:pathToCell animated:YES scrollPosition:UITableViewScrollPositionNone];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animateSelectionTimer:) userInfo:pathToCell repeats:NO];*/
    
}

-(void)animateSelectionTimer:(NSTimer *)timer;
{
    [self performSelectorOnMainThread:@selector(animateSelection:) withObject:(NSIndexPath *)timer.userInfo waitUntilDone:NO];
    [timer invalidate];
}

-(void)animateSelection:(NSIndexPath *)pathToCell
{
 /*   if ([_welcomeTable.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]) {
        [_welcomeTable.delegate tableView:_welcomeTable willSelectRowAtIndexPath:pathToCell];
    }
    
    if ([_welcomeTable.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_welcomeTable.delegate tableView:_welcomeTable didSelectRowAtIndexPath:pathToCell];
    }*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section
{
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     *   This is an important bit, it asks the table view if it has any available cells
     *   already created which it is not using (if they are offscreen), so that it can
     *   reuse them (saving the time of alloc/init/load from xib a new cell ).
     *   The identifier is there to differentiate between different types of cells
     *   (you can display different types of cells in the same table view)
     */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    /*
     *   If the cell is nil it means no cell was available for reuse and that we should
     *   create a new one.
     */
    if (cell == nil) {
        
        /*
         *   Actually create a new cell (with an identifier so that it can be dequeued).
         */
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    /*
     *   Now that we have a cell we can configure it to display the data corresponding to
     *   this row/section
     */
    
    
    /* Now that the cell is configured we return it to the table view so that it can display it */
    cell.textLabel.text = [titleArray objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            if([self.delegate respondsToSelector:@selector(setNewCentralPane:)])
            {
                [self.delegate setNewCentralPane: 0];
            }
            ;
            break;
        case 1:
            if([self.delegate respondsToSelector:@selector(setNewCentralPane:)])
            {
                [self.delegate setNewCentralPane: 1];
            }
            ;
            break;
        case 2:
            if([self.delegate respondsToSelector:@selector(setNewCentralPane:)])
            {
                [self.delegate setNewCentralPane: 2];
            }
            break;
        case 3:
            if([self.delegate respondsToSelector:@selector(setNewCentralPane:)])
            {
                [self.delegate setNewCentralPane: 3];
            }
            ;
            break;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}


@end
