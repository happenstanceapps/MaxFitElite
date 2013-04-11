//
//  WorkOutDetailViewController.h
//  HealthAndFitness
//
//  Created by octal i-phone2 on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface WorkOutDetailViewController : UIViewController<UIScrollViewDelegate> {
	NSString *workoutidstr;
	BOOL pageControlUsed;
	NSArray *contentList;
	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	IBOutlet UIScrollView *scrollrss;
	IBOutlet UITextView *workoutdiscriptiontxt;
	sqlite3 *database;
	NSInteger pageno;
	NSString *catidstr;
	IBOutlet UITableView *tblmovement;
	NSMutableArray *movementArray;
	IBOutlet UIView *tableview;
	IBOutlet UIScrollView *videoscrollview;
	NSString *workoutIdstr;
	NSMutableArray *infoarray;
	NSString *desstr;
    IBOutlet UILabel *categorylbl;

}
@property(nonatomic,retain)NSString *workoutidstr;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *contentList;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic,retain)IBOutlet UIScrollView *scrollrss;
@property (nonatomic,retain)IBOutlet UITextView *workoutdiscriptiontxt;
@property (nonatomic,retain) NSString *catidstr;
@property (nonatomic,retain) IBOutlet UITableView *tblmovement;
@property (nonatomic,retain) IBOutlet UIView *tableview;
@property (nonatomic,retain)IBOutlet UIScrollView *videoscrollview;
@property (nonatomic,retain)NSString *workoutIdstr;
@property (nonatomic,retain)NSMutableArray *infoarray;
@property (nonatomic,retain)NSString *desstr;

- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
-(void)getrelatedmovement;
-(NSString *)getcategory:(NSString *)catid;
-(IBAction)getrandomno:(id)sender;

-(IBAction)movementbtnpressed:(id)sender;
-(IBAction)logsbtnpressd:(id)sender;
-(IBAction)settingsbtnpressed:(id)sender;
-(IBAction)WODbtnpressed:(id)sender;
-(IBAction)workoutbtnpressed:(id)sender;
- (void)layoutScrollImages;
-(void)loadScrollView;
-(void)getworkoutinfo:(NSString *)workoutid;
-(void)showdata;


@end
