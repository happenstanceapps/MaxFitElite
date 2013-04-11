//
//  WODViewController.h
//  HealthAndFitness
//
//  Created by octal i-phone2 on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class ContentController;
@class Reachability;
@interface WODViewController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate> {
	
	sqlite3 *database;
	NSMutableData *responseData;
	NSString *responsestring;
	NSMutableArray *rssfeedarray;
	 UIWebView *webview;
	IBOutlet UIScrollView *scrollrss;
	NSMutableArray* rssItems;
	IBOutlet UITextField *woddatetxt;
	ContentController *contentlist;
	UITextView *textdesc;

	UIPageControl *pageControl;
    NSMutableArray *viewControllers;
	IBOutlet UIActivityIndicatorView *indicator;
    
    BOOL pageControlUsed;
	NSArray *contentList;
	IBOutlet UILabel *feedlabl;
	NSString *feedtitlestr;
	NSInteger pageNo;
	NSString *urlstring;
	UIButton *todaybtn;
	IBOutlet UIView *commentsview;
	IBOutlet UITextField *nametxt;
	IBOutlet UITextField *Emailtxt;
	IBOutlet UITextView *commenttxt;
	BOOL flag;
	NSString *namestr;
	NSString *emailstr;
	NSString *commentstr;
	NSString *feedidstr;
	int value;
	int movementDistance;
	float movementDuration;
	IBOutlet UIToolbar *keyboardtool;
	IBOutlet UIButton *postcommentbtn;
	IBOutlet UIButton *chossetimer;
	NSRange range;
	IBOutlet UIButton *postcommentbig;
	UIButton * musicbtn;
    NSRange range1;
    NSRange range2;
    NSMutableArray *feeds;
    
    BOOL rssfeedflag;
    Reachability* hostReach;
    NSString *statusString;
    

}
@property (nonatomic,retain)NSString *responsestring;
@property (nonatomic,retain)NSMutableArray *rssfeedarray;
@property (nonatomic,retain)IBOutlet UIWebView *webview;
@property (nonatomic,retain)IBOutlet UIScrollView *scrollrss;
@property (nonatomic,retain)IBOutlet UITextField *woddatetxt;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *contentList;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain)NSString *feedtitlestr;
@property (nonatomic, retain)NSString *urlstring;
@property (nonatomic, assign) BOOL flagValidate;
@property (nonatomic, retain)NSString *feedidstr;
@property (nonatomic, retain)NSMutableArray *feeds;
@property (nonatomic, retain) NSString *namestr;
@property (nonatomic, retain) NSString *emailstr;
@property (nonatomic, retain) NSString *commentstr;
@property(nonatomic,retain)NSString *statusString;



- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
-(void)getrssfeed;
-(void)getlist;
- (NSString *)flattenHTML:(NSString *)html;
-(IBAction)choosetimerbtnpressd:(id)sender;
-(IBAction)workoutbtnpressed:(id)sender;
-(IBAction)Movementbtnpressed:(id)sender;
-(IBAction)Logsbtnpressed:(id)sender;
-(IBAction)Settingsbtnpressed:(id)sender;
- (IBAction)changePage:(id)sender;
-(IBAction)feedbuttonpressed:(id)sender;
-(IBAction)todaybtnpressed:(id)sender;
-(void)showdata;
-(IBAction)commentbtnpressed:(id)sender;
-(void)getdatafromFeedtbl;
-(NSString *)htmlEntityDecode:(NSString *)string;
//- (void) updateInterfaceWithReachability: (Reachability*) curReach;

@end
