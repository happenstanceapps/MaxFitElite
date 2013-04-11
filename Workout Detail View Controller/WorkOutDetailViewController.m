//
//  WorkOutDetailViewController.m
//  HealthAndFitness
//
//  Created by octal i-phone2 on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WorkOutDetailViewController.h"
#import "WorkoutDetailpage.h"
#import "Config.h"
#import "WorkOutViewController.h"
#import "SettingsViewControllers.h"
#import "MovementsViewController.h"
#import "LogsViewController.h"
#import "WODViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MovementDetailViewController.h"
#import "TodayViewController.h"
#import "SaveValueInDatabase.h"

static NSUInteger kNumberOfPages = 6;

static NSString *NameKey = @"DESCRIPTION";
static NSString *titleKey = @"TITLE";
static NSString *CATIDKey = @"CATID";
static NSString *workoutIDKey = @"ID";
static NSString *ISCREATEDkey = @"ISCREATED";
@implementation WorkOutDetailViewController
@synthesize workoutidstr,catidstr,workoutIdstr,infoarray,desstr;
@synthesize  pageControl, viewControllers, contentList,scrollrss,workoutdiscriptiontxt,tblmovement,tableview,videoscrollview;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    }

	UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0,0,120,36)];
	[lblTitle setTextColor:[UIColor colorWithRed:0.039215686 green:0.55686275 blue:0.99607843 alpha:1.0]];
	[lblTitle setTextAlignment:UITextAlignmentCenter];
	lblTitle.font = [UIFont boldSystemFontOfSize:20];
	[lblTitle setBackgroundColor:[UIColor clearColor]];	
	[lblTitle setText:@"Workouts"];
	self.navigationItem.titleView=lblTitle;
	[lblTitle release];
	
	UIButton * button= [UIButton buttonWithType:UIButtonTypeCustom];
	button.bounds=CGRectMake(0, 0, 30.0, 30.0);
	[button setImage:[UIImage imageNamed:@"back_button.png"]forState:UIControlStateNormal];
	[button addTarget:self action:@selector(backbtnpressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton  = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem=barButton;
    [barButton release];
	
	tblmovement.layer.masksToBounds = YES;
	tblmovement.layer.cornerRadius = 5;
  
	
	UIButton * randombtn= [UIButton buttonWithType:UIButtonTypeCustom];
	randombtn.bounds=CGRectMake(0, 0, 60.0, 37.0);
	[randombtn setImage:[UIImage imageNamed:@"random_blue.png"]forState:UIControlStateNormal];
	[randombtn addTarget:self action:@selector(getrandomno:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton1  = [[UIBarButtonItem alloc] initWithCustomView:randombtn];
	self.navigationItem.rightBarButtonItem=barButton1;
    [barButton1 release];
	
	kNumberOfPages=[WorkoutarrayG count];
    self.contentList = [NSArray arrayWithArray:WorkoutarrayG];
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    scrollrss.pagingEnabled = YES;
    scrollrss.contentSize = CGSizeMake(scrollrss.frame.size.width * kNumberOfPages, scrollrss.frame.size.height);
    scrollrss.showsHorizontalScrollIndicator = NO;
    scrollrss.showsVerticalScrollIndicator = NO;
    scrollrss.scrollsToTop = NO;
    scrollrss.delegate = self;
    pageControl.numberOfPages = kNumberOfPages;
   
	for (int i=0; i<=[WorkoutarrayG count]-1; i++) {
		NSString *workoutidvalue=[[WorkoutarrayG objectAtIndex:i]objectForKey:@"ID"];
		if ([workoutidstr isEqualToString:workoutidvalue]) {
			pageno=i;
		}
	}
	 pageControl.currentPage = pageno;
	[self loadScrollViewWithPage:pageno];
    CGRect frame = scrollrss.frame;
    frame.origin.x = frame.size.width * pageno;
    frame.origin.y = 0;
	[scrollrss scrollRectToVisible:frame animated:NO];
    pageControlUsed = YES;
	
	//[self loadScrollView];
}
-(void)loadScrollView{
	
	NSArray *subviews = [[videoscrollview subviews] copy];
	for (UIView *subview in subviews) {
		[subview removeFromSuperview];
	}
	[subviews release];
	
	[videoscrollview setCanCancelContentTouches:NO];
	videoscrollview.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	videoscrollview.pagingEnabled = NO;
	NSUInteger i;
	for (i = 0; i<[movementArray count]; i++)
	{
		UIImageView	*imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[[movementArray objectAtIndex:i]objectForKey:@"IMAGE"]]];
		[imageView setFrame:CGRectMake((i*107)+10, 0, 105, 65)];
		imageView.tag = i+1;	
		[videoscrollview addSubview:imageView];
		UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
		btn1.frame = imageView.frame;
		btn1.titleLabel.font=[UIFont boldSystemFontOfSize:13.0];
		[btn1 setTitle:[[movementArray objectAtIndex:i]objectForKey:@"ID"] forState:UIControlStateReserved];
		[btn1 addTarget:self action:@selector(workoutscrollbtnpresed:) forControlEvents:UIControlEventTouchUpInside];
		[btn1 setTag:i+1];
		[videoscrollview addSubview:btn1];
        [imageView release];
	}
	[self layoutScrollImages];	
}
- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [videoscrollview subviews];
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag !=0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			curXLoc += (107);
		}
	}
	[videoscrollview setContentSize:CGSizeMake((([movementArray count]) * 115)+15, [videoscrollview bounds].size.height)];
}
-(void)backbtnpressed:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    NSLog(@"%d",page);
    WorkoutDetailpage *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {   
        controller = [[WorkoutDetailpage alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
	if (controller.view.superview == nil)
    {
	CGRect frame = scrollrss.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	controller.view.frame = frame;
	[scrollrss addSubview:controller.view];
	NSDictionary *numberItem = [self.contentList objectAtIndex:page];
	controller.workoutnamelbl.font=[UIFont systemFontOfSize:20];
	controller.workoutnamelbl.text =[numberItem valueForKey:titleKey];
	}
	NSDictionary *numberItem1 = [self.contentList objectAtIndex:page];
	catidstr=[numberItem1 valueForKey:CATIDKey];
	workoutIdstr=[numberItem1 valueForKey:workoutIDKey];
	desstr=[[numberItem1 valueForKey:NameKey]retain];
	if (![catidstr isEqualToString:@"0"]) {
        [categorylbl setText:[self getcategory:catidstr]];
	}
	else {
        [categorylbl setText:@"No category"];
 }
   [self getworkoutinfo:workoutIdstr];
	if (page!=kNumberOfPages-1) {
		NSDictionary *numberItem3 = [self.contentList objectAtIndex:page+1];
		controller.nextworkoutlabl.text=[numberItem3 valueForKey:titleKey];
	}
	if (page!=0) {
		NSDictionary *numberItem2 = [self.contentList objectAtIndex:page-1];
		controller.prevworkoutlbl.text=[numberItem2 valueForKey:titleKey];
	}
	
	if (![catidstr isEqualToString:@"0"]) {
		controller.workoutcategorylbl.text=[self getcategory:catidstr];
	}
}
-(void)getworkoutinfo:(NSString *)workoutid
{
	infoarray=[[NSMutableArray alloc]init];
	[movementArray removeAllObjects];
	movementArray=[[NSMutableArray alloc] init];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"DBWorkout.sqlite"];
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
	{
		NSString *s =  [NSString stringWithFormat:@"Select Workout.ID,Workout.CatID,Workout.Title as WTitle, Workout.Type, Workout.Description, Workoutinfo.Rep,Workoutinfo.Distance, Workoutinfo.Weight, Movements.Title as MTitle, Movements. Description as MDesc, Movements.ID as MID from Workout, Workoutinfo, Movements where Workout.ID = Workoutinfo.WorkoutID and Workoutinfo.MovementID= Movements.ID and Workout.ID = %@",workoutid];
		
		const char *sql = [s cStringUsingEncoding:NSASCIIStringEncoding];
		sqlite3_stmt *selectStatement;
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{ 
				NSString *workoutID=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
				NSString *workoutcatid =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
				NSString *workoutname =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2)];
				NSString *workouttype =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3)];
				NSString *workoutdes =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 4)];
				NSString *repstr =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 5)];
				NSString *distancestr =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 6)];
				NSString *weightstr =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 7)];
				NSString *movementtitle =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 8)];
				NSString *movementdesstr =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 9)];
				NSString *movementIDstr =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 10)];
			
				[infoarray addObject:[NSDictionary dictionaryWithObjectsAndKeys:workoutID,@"ID",workoutcatid,@"CATID",workoutname,@"TITLE",workouttype,@"TYPE",workoutdes,@"DESCRIPTION",repstr,@"REP",distancestr,@"DISTANCE",weightstr,@"WEIGHT",movementtitle,@"MOVTITLE",movementdesstr,@"MOVDES",movementIDstr,@"MOVID",nil]];

				[movementArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:movementtitle,@"TITLE",movementIDstr,@"ID",movementdesstr,@"DES",@"images-1.jpg",@"IMAGE",nil]];
			}
		}
		sqlite3_finalize(selectStatement);
	}
	else
		sqlite3_close(database);	
	sqlite3_close(database);
	movementarrayG =[[NSMutableArray alloc]initWithArray:movementArray];
	[self showdata];
	[tblmovement reloadData];
}
-(void)showdata
{
	NSString *destextstr=desstr;
	destextstr=[destextstr stringByAppendingFormat:@"\n\n"];
	for (int i = 0; i<[infoarray count]; i++)
	{
		if (![[[infoarray objectAtIndex:i]objectForKey:@"REP"] isEqualToString:@"0"]) {
			destextstr=[destextstr stringByAppendingFormat:@" %@",[[infoarray objectAtIndex:i]objectForKey:@"REP"]];
			
		}
		else if (![[[infoarray objectAtIndex:i]objectForKey:@"DISTANCE"] isEqualToString:@"0"]) {
			destextstr=[destextstr stringByAppendingFormat:@" %@",[[infoarray objectAtIndex:i]objectForKey:@"DISTANCE"]];
		}
		else if (![[[infoarray objectAtIndex:i]objectForKey:@"WEIGHT"] isEqualToString:@"0"]) {
			destextstr=[destextstr stringByAppendingFormat:@" %@",[[infoarray objectAtIndex:i]objectForKey:@"WEIGHT"]];
		}
		destextstr=[destextstr stringByAppendingFormat:@" %@",[[infoarray objectAtIndex:i]objectForKey:@"MOVTITLE"]];
		destextstr=[destextstr stringByAppendingFormat:@"\n"];
		
	}
	workoutdiscriptiontxt.text=destextstr;
}
-(NSString *)getcategory:(NSString *)catid
{
	NSString *categorystr=@"";
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"DBWorkout.sqlite"];
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
	{
		NSString *s =  [NSString stringWithFormat:@"SELECT * from Category WHERE Id = %@",catid];
		const char *sql = [s cStringUsingEncoding:NSASCIIStringEncoding];
		sqlite3_stmt *selectStatement;
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{ 
				categorystr =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
			}
		}
		sqlite3_finalize(selectStatement);
	}
	else
		sqlite3_close(database);	
	sqlite3_close(database);
	return categorystr;
}
-(void)getrelatedmovement
{
}
-(IBAction)getrandomno:(id)sender
{
	NSInteger randInt = (random() % [WorkoutarrayG count]);
	pageControl.currentPage = randInt;
	[self loadScrollViewWithPage:randInt];
    CGRect frame = scrollrss.frame;
    frame.origin.x = frame.size.width * randInt;
    frame.origin.y = 0;
	[scrollrss scrollRectToVisible:frame animated:NO];
    pageControlUsed = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
   	if (pageControlUsed)
    {
        return;
    }
    CGFloat pageWidth = scrollrss.frame.size.width;
    int page = floor((scrollrss.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self loadScrollViewWithPage:page];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}
- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
    [self loadScrollViewWithPage:page];
    CGRect frame = scrollrss.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
	[scrollrss scrollRectToVisible:frame animated:NO];
    pageControlUsed = YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [movementArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        [cell setBackgroundColor:[UIColor clearColor]];
        [tableView setSeparatorColor:[UIColor clearColor]];
		UILabel *movementlbl=[[UILabel alloc]initWithFrame:CGRectMake(2, 10, 200, 20)];
		[movementlbl setBackgroundColor:[UIColor clearColor]];
		[movementlbl setTextColor:[UIColor whiteColor]];
		[movementlbl setTag:5];
		[movementlbl setTextAlignment:UITextAlignmentLeft];
		[cell.contentView addSubview:movementlbl];
        [movementlbl release];
	}
	if ([movementArray count]>0) {
		UILabel *movmentlbl=(UILabel *)[cell viewWithTag:5];
		[movmentlbl setText:[[movementArray objectAtIndex:indexPath.row]objectForKey:@"TITLE"]];
        [tableView setSeparatorColor:[UIColor whiteColor]];
	}

	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    NSIndexPath *indexPMain = [NSIndexPath indexPathForRow:-1 inSection:0];
    
    [tblmovement selectRowAtIndexPath:indexPMain animated:NO scrollPosition:UITableViewScrollPositionNone];
    
	MovementDetailViewController *movementDetailView=[[MovementDetailViewController alloc]init];

	movementDetailView.movementstr=[[movementArray objectAtIndex:indexPath.row]objectForKey:@"ID"];
	[self.navigationController pushViewController:movementDetailView animated:YES];
	[movementDetailView release];
}

-(void)workoutscrollbtnpresed:(id)sender
{
	UIButton *btn=(UIButton *)sender;
	
	
	MovementDetailViewController *movementDetailView=[[MovementDetailViewController alloc]init];
	movementDetailView.movementstr=[btn titleForState:UIControlStateReserved];
	[self.navigationController pushViewController:movementDetailView animated:YES];
	[movementDetailView release];
	
	
}

-(IBAction)movementbtnpressed:(id)sender
{ 
	MovementsViewController *movementlist=[[MovementsViewController alloc]init];
	[self.navigationController pushViewController:movementlist animated:NO];
	[movementlist release];
	
}
-(IBAction)logsbtnpressd:(id)sender
{
	NSString *logviewstr=[SaveValueInDatabase selectloginviewInLogintable];
    
    if ([logviewstr isEqualToString:@""]) {
        TodayViewController *LogsView=[[TodayViewController alloc]init];
        [self.navigationController pushViewController:LogsView animated:NO];
        [LogsView release];
    }
    else
    {
        if ([logviewstr isEqualToString:@"List"]) {
            LogsViewController *LogView =[[LogsViewController alloc]init];
            [self.navigationController pushViewController:LogView animated:NO];
            [LogView release];
        }
        else
        {
            TodayViewController *LogsView=[[TodayViewController alloc]init];
            [self.navigationController pushViewController:LogsView animated:NO];
            [LogsView release];
        }
        
    }
	
}
-(IBAction)settingsbtnpressed:(id)sender
{
	SettingsViewControllers *settingsView=[[SettingsViewControllers alloc]init];
	[self.navigationController pushViewController:settingsView animated:NO];
	[settingsView release];
}
-(IBAction)WODbtnpressed:(id)sender
{
	WODViewController *WODView=[[WODViewController alloc]init];
	[self.navigationController pushViewController:WODView animated:NO];
	[WODView release];
}
-(IBAction)workoutbtnpressed:(id)sender
{
	WorkOutViewController *WorkOutView=[[WorkOutViewController alloc]init];
	[self.navigationController pushViewController:WorkOutView animated:NO];
	[WorkOutView release];
	
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
