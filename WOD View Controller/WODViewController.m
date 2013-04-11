//
//  WODViewController.m
//  HealthAndFitness
//
//  Created by octal i-phone2 on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "WODViewController.h"
#import "TBXML.h"
#import "MusicSettingViewController.h"
#import "SettingsViewControllers.h"
#import "LogsViewController.h"
#import "WorkOutViewController.h"
#import "MovementsViewController.h"
#import "StopWatchViewController.h"
#import "AddFeedViewController.h"
#import "MyViewController.h"
#import "Config.h"
#import "TabataSettingsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TodayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "PostcommentViewController.h"
#import "CountDownViewController.h"
#import "IntervallSettingViewController.h"
#import "SaveValueInDatabase.h"
#import "Reachability.h"
#import "DemoCalendarMonth.h"


static NSUInteger kNumberOfPages = 6;

static NSString *NameKey = @"DESCRIPTION";
static NSString *titleKey = @"TITLE";
static NSString *linkKey = @"LINK";

@implementation WODViewController
@synthesize responsestring,statusString,rssfeedarray,webview,scrollrss;
@synthesize  pageControl, viewControllers, contentList,woddatetxt,feedtitlestr,urlstring,flagValidate,feeds;



@synthesize namestr;
@synthesize emailstr;
@synthesize commentstr,feedidstr;

const CGFloat kScrollObjHeight6	= 80.0;
const CGFloat kScrollObjWidth6	= 90.0;
int l6=0;
NSUInteger kNumImage6		= 0;









// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top_bar.png"] forBarMetrics:UIBarMetricsDefault];
    }
	self.navigationItem.hidesBackButton=YES;
	UILabel *lblTitle  = [[UILabel alloc]initWithFrame:CGRectMake(0,0,120,36)];
	lblTitle.text = @"WOD";
	[lblTitle setTextAlignment:UITextAlignmentCenter];
	lblTitle.font = [UIFont boldSystemFontOfSize:20];
	[lblTitle setBackgroundColor:[UIColor clearColor]];	
	[lblTitle setTextColor:[UIColor colorWithRed:0.039215686 green:0.55686275 blue:0.99607843 alpha:1.0]];
	self.navigationItem.titleView=lblTitle;
	[lblTitle release];
	
	 todaybtn= [UIButton buttonWithType:UIButtonTypeCustom];
	todaybtn.bounds=CGRectMake(0, 0, 50.0, 30.0);
	[todaybtn setImage:[UIImage imageNamed:@"today_button.png"]forState:UIControlStateNormal];
	[todaybtn addTarget:self action:@selector(todaybtnpressed:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton  = [[UIBarButtonItem alloc] initWithCustomView:todaybtn];
	self.navigationItem.leftBarButtonItem=barButton;
    [barButton release];
	
	 musicbtn= [UIButton buttonWithType:UIButtonTypeCustom];
	musicbtn.bounds=CGRectMake(0, 0, 50.0, 30.0);
	[musicbtn setImage:[UIImage imageNamed:@"music_button.png"]forState:UIControlStateNormal];
	[musicbtn addTarget:self action:@selector(musicbtnpressed) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton1  = [[UIBarButtonItem alloc] initWithCustomView:musicbtn];
	self.navigationItem.rightBarButtonItem=barButton1;
    [barButton1 release];
	
	woddatetxt.layer.masksToBounds = YES;
	woddatetxt.layer.cornerRadius = 15.0;
	
    if (rssfeedarray==nil) {
        feeds=[[NSMutableArray alloc]init];
        rssfeedarray=[[NSMutableArray alloc]init];
        rssItems = nil;
       // rss = nil;
        [todaybtn setEnabled:FALSE];
        [postcommentbtn setEnabled:FALSE];
        [chossetimer setEnabled:FALSE];
        [pageControl setEnabled:FALSE];
        [postcommentbig setEnabled:FALSE];
        [musicbtn setEnabled:FALSE];
        [indicator setHidden:FALSE];
        [indicator startAnimating];
        
        
        int status=[self netStatus];
        if(status==0)
        {
       
            [self getdatafromFeedtbl];
        }
        
        else {
            WODArrayG=[[NSMutableArray alloc]init];
            [chossetimer setEnabled:TRUE];
            [musicbtn setEnabled:TRUE];
            [indicator setHidden:TRUE];
            [indicator stopAnimating];

        }
    }
	
}




-(int)netStatus
{
	int variable;
	Reachability *networkReachability = [Reachability reachabilityForInternetConnection];   
	NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];    
	
	if (networkStatus == NotReachable) {
        
		       
		variable=1;
	} 
	else {        
		variable=0;
		
    }        
	return variable;
}





-(void)musicbtnpressed
{
	[commentsview removeFromSuperview];
	MusicSettingViewController *musicsettingView=[[MusicSettingViewController alloc]init];
	[self.navigationController pushViewController:musicsettingView animated:YES];
	[musicsettingView release];
}
-(IBAction)todaybtnpressed:(id)sender
{
	[self loadScrollViewWithPage:0];
	pageControl.currentPage = 0;
	CGRect frame = scrollrss.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
	[scrollrss scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
	
}
-(void)getrssfeed
{
	woddatetxt.text=@"";
	[feedlabl setText:@""];
    
    if ([urlstring isEqualToString:@"http://www.crossfit.com/index1.xml"]) {
        rssfeedflag=TRUE;
    }
    else {
        rssfeedflag=TRUE;
    }
		
	flag=TRUE;
	NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]];
	responseData=[[NSMutableData alloc]init];
    [NSURLConnection connectionWithRequest:request1 delegate:self];
	
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if (flag==TRUE) {
		
		[indicator stopAnimating];
		[indicator setHidden:TRUE];
		
		[todaybtn setEnabled:FALSE];
		[postcommentbtn setEnabled:FALSE];
		[chossetimer setEnabled:FALSE];
		[pageControl setEnabled:FALSE];
		[postcommentbig setEnabled:FALSE];
		[musicbtn setEnabled:TRUE];
		[pageControl setCurrentPage:4];
		 scrollrss.delegate = nil;
		scrollrss.pagingEnabled = NO;
		
		woddatetxt.text=@"";
		[feedlabl setText:@""];
		
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Not able to get data from that RSS feed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
	}
	else {
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Not able to post comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
	}
	
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {		
	[nametxt setText:@""];
	[Emailtxt setText:@""];
	[commenttxt setText:@""];
	
	[indicator setHidden:TRUE];
	if (flag==TRUE) {
	[indicator stopAnimating];
	[indicator setHidden:TRUE];
	
	responsestring= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responsestring retain];
	if (responsestring == (NSString*)[NSNull class] ) {
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Not able to get data from that RSS feed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
	}
	else {
		[todaybtn setEnabled:TRUE];
		[postcommentbtn setEnabled:TRUE];
		[chossetimer setEnabled:TRUE];
		[pageControl setEnabled:TRUE];
		[postcommentbig setEnabled:TRUE];
		[musicbtn setEnabled:TRUE];
			
			[self getlist];
		}
	}
	else {
		[indicator stopAnimating];
		[indicator setHidden:TRUE];
		[todaybtn setEnabled:TRUE];
		responsestring= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
		NSString *errorstr=@"error";
		range = [responsestring rangeOfString:errorstr];
				 if(range.location != NSNotFound)
				 {
					 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Comment Submission Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
					 [alert show];
					 [alert release];
					 
				 }
		else {
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Your comment have been posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			[alert release];
		}
				 
	}

}
-(void)getlist
{
	BOOL flagValue = FALSE; 
	TBXML *xmlTB=[[TBXML alloc] initWithXMLString:responsestring];
	TBXMLElement *rootElement=xmlTB.rootXMLElement;
	if (rootElement)
	{
		TBXMLElement *RssBody = [TBXML childElementNamed:@"channel" parentElement:rootElement];
		if (RssBody) 
		{
			TBXMLElement *RssItems = [TBXML childElementNamed:@"item" parentElement:RssBody];
			while (RssItems)
			{
				TBXMLElement *titleElement = [TBXML childElementNamed:@"title" parentElement:RssItems];
                TBXMLElement *titleElement1 = [TBXML childElementNamed:@"pubDate" parentElement:RssItems];
				TBXMLElement *linkElement = [TBXML childElementNamed:@"link" parentElement:RssItems];
				TBXMLElement *descriptionElement = [TBXML childElementNamed:@"description" parentElement:RssItems];
				NSString *titlestr=@"";
				NSString *linkstr=@"";
				NSString *descriptionstr=@"";
				flagValue = TRUE;
                if (rssfeedflag==TRUE) {
                   titlestr=[TBXML textForElement:titleElement]; 
                }
                else {
                   
                    titlestr=[TBXML textForElement:titleElement1]; 
                }
				
				linkstr=[TBXML textForElement:linkElement];
				descriptionstr=[TBXML textForElement:descriptionElement];
				NSScanner *scanner = [NSScanner scannerWithString:descriptionstr];
				NSCharacterSet *whiteSpace = [NSCharacterSet characterSetWithCharactersInString:@"."];
				NSCharacterSet *nonWhitespace = [whiteSpace invertedSet];
				int wordcount = 0;
				
				while(![scanner isAtEnd])
				{
					[scanner scanUpToCharactersFromSet:nonWhitespace intoString:nil];
					[scanner scanUpToCharactersFromSet:whiteSpace intoString:nil];
					wordcount++;
					if (wordcount==1) {
						
					}
				}
                [rssfeedarray addObject:[NSDictionary dictionaryWithObjectsAndKeys:titlestr,@"TITLE",linkstr,@"LINK",descriptionstr,@"DESCRIPTION",nil]];
                
				RssItems=[TBXML nextSiblingNamed:@"item" searchFromElement:RssItems];
			}
            
		}
	}
	else {
		[todaybtn setEnabled:FALSE];
		[postcommentbtn setEnabled:FALSE];
		[chossetimer setEnabled:FALSE];
		[pageControl setEnabled:FALSE];
		[postcommentbig setEnabled:FALSE];
		[musicbtn setEnabled:TRUE];
		[pageControl setCurrentPage:4];
		scrollrss.delegate = nil;
		scrollrss.pagingEnabled = NO;
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Not able to get data from that RSS feed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
	}
	
	if(flagValue){
	
		[self showdata];
	}
	else {
		[todaybtn setEnabled:FALSE];
		[postcommentbtn setEnabled:FALSE];
		[chossetimer setEnabled:FALSE];
		[pageControl setEnabled:FALSE];
		[postcommentbig setEnabled:FALSE];
		[musicbtn setEnabled:TRUE];
		[pageControl setCurrentPage:4];
		scrollrss.delegate = nil;
		scrollrss.pagingEnabled = NO;
		UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Not able to get data from that RSS feed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
		[alert release];
	}
    [xmlTB release];
    
}
-(void)getdatafromFeedtbl
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"DBWorkout.sqlite"];
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
	{
		const char *sql = "select * from Feed";
		sqlite3_stmt *selectStatement;
		int returnValue = sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL);
		if(returnValue == SQLITE_OK)
		{
			while(sqlite3_step(selectStatement) == SQLITE_ROW)
			{ 
				urlstring =[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2)];
				[urlstring retain];
				feedtitlestr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
				[feedtitlestr retain];
			}
		}
		sqlite3_finalize(selectStatement);
	}
	else
		sqlite3_close(database);	
	sqlite3_close(database);
	
	[self getrssfeed];
}
-(void)showdata
{
	[feedlabl setText:feedtitlestr];
  
	kNumberOfPages=[rssfeedarray count];
	WODArrayG=[[NSMutableArray alloc]initWithArray:[rssfeedarray retain]];
    self.contentList = [NSArray arrayWithArray:rssfeedarray];
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
    pageControl.currentPage = 0;
	[self loadScrollViewWithPage:0];
	CGRect frame = scrollrss.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
	[scrollrss scrollRectToVisible:frame animated:NO];
    pageControlUsed = YES;
}
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    MyViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {   
        controller = [[MyViewController alloc] initWithPageNumber:page];
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
	NSString *s=[self flattenHTML:[numberItem valueForKey:NameKey]];
	s = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                       "<head> \n"
                                       "<style type=\"text/css\"> \n"
                                       "body {font-family: \"%@\"; font-size: %@; color:white;}\n"
                                       "</style> \n"
                                       "</head> \n"
                                       "<body style=\"background-color: transparent;\" >%@</body> \n"
                                       "</html>", @"helvetica", [NSNumber numberWithInt:20],s];
        
    [controller.dectxt loadHTMLString:myDescriptionHTML baseURL:nil];
        
	stopwatchfeedG=[s retain];
	}
	
	NSString *Titletxt = @"";
	NSDictionary *numberItem1 = [self.contentList objectAtIndex:page];
	
	NSString *feed=[numberItem1 valueForKey:linkKey];
	NSInteger feedlength=[feed length]-5;
	NSString *feed1=[NSString stringWithString:[feed substringToIndex:feedlength]];
	feedidstrG=[NSString stringWithString:[feed1 substringFromIndex:36]];
	[feedidstrG retain];
	NSScanner *scanner = [NSScanner scannerWithString:[numberItem1 valueForKey:titleKey]];
	NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
	NSCharacterSet *nonWhitespace = [whiteSpace invertedSet];
	int wordcount = 0;
	while(![scanner isAtEnd])
	{
		[scanner scanUpToCharactersFromSet:nonWhitespace intoString:nil];
		[scanner scanUpToCharactersFromSet:whiteSpace intoString:nil];
		wordcount++;
		if (wordcount==1) {
			NSInteger titlelength=[scanner scanLocation] ;
			Titletxt=[[numberItem1 valueForKey:titleKey] substringFromIndex:titlelength];
		}
	}
	NSDateFormatter *dateFormatstartDate =[[NSDateFormatter alloc] init];
    
      if (rssfeedflag==TRUE) {
	  [dateFormatstartDate setDateFormat:@"yyMMdd"];
          
          NSDate *dateEventstart = [[dateFormatstartDate dateFromString:Titletxt] retain];
          [dateFormatstartDate release];
          
          NSDateFormatter *dateFormatstartDate1 = [[NSDateFormatter alloc] init];
          [dateFormatstartDate1 setDateFormat:@"EEEE, MM/dd/YYYY"];
          NSString *startDatestrLast=[dateFormatstartDate1 stringFromDate:dateEventstart];
          [dateEventstart release];
          [dateFormatstartDate1 release];
          woddatetxt.text=startDatestrLast;
          WODdatestrG=[startDatestrLast retain];
      }
      else {
          [dateFormatstartDate setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
          NSDate *dateEventstart = [[dateFormatstartDate dateFromString:[numberItem1 valueForKey:titleKey]] retain];
          [dateFormatstartDate release];
          
          NSDateFormatter *dateFormatstartDate1 = [[NSDateFormatter alloc] init];
          [dateFormatstartDate1 setDateFormat:@"EEEE, MM/dd/YYYY"];
          NSString *startDatestrLast=[dateFormatstartDate1 stringFromDate:dateEventstart];
          [dateEventstart release];
          [dateFormatstartDate1 release];
          woddatetxt.text=startDatestrLast;
          WODdatestrG=[startDatestrLast retain];
      }
	
	
	pageNoG=page;
	
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
	pageControl.currentPage = page;
    [self loadScrollViewWithPage:page];
    
    CGRect frame = scrollrss.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
	[scrollrss scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}
-(void)viewWillAppear:(BOOL)animated
 {
	if (feedischange==TRUE) {
		
		[todaybtn setEnabled:FALSE];
		[postcommentbtn setEnabled:FALSE];
		[chossetimer setEnabled:FALSE];
		[pageControl setEnabled:FALSE];
		[postcommentbig setEnabled:FALSE];
		[musicbtn setEnabled:FALSE];

		[indicator setHidden:FALSE];
		NSArray *subviews = [[scrollrss subviews] copy];
		for (UIView *subview in subviews) {
			[subview removeFromSuperview];
		}
		[subviews release];
		[WODArrayG removeAllObjects];
		scrollrss.pagingEnabled = NO;
		scrollrss.delegate = nil;
		[viewControllers removeAllObjects];
        [feeds removeAllObjects];

		[rssfeedarray removeAllObjects];
        rssfeedarray=[[NSMutableArray alloc]init];
		feedischange=FALSE;
		[indicator setHidden:FALSE];
		[indicator startAnimating];
		[self getdatafromFeedtbl];
	}
}

-(IBAction)commentbtnpressed:(id)sender
{
	PostcommentViewController *PostCommentView=[[PostcommentViewController alloc]init];
	[self.navigationController pushViewController:PostCommentView animated:YES];
	[PostCommentView release];
}

- (NSString *)flattenHTML:(NSString *)html {
  
    html=[self htmlEntityDecode:html];
    
	NSString *dectextstr=@"";
    NSString *input = html;
    NSArray *timeSplit = [input componentsSeparatedByString:@"<p>"];
    NSString *imgtag=@"<img";
    NSString *herftag=@"<a href";
    for (int i=0; i<=[timeSplit count]-1; i++) {
        
        NSString *word =[timeSplit objectAtIndex:i];
        range1 = [word rangeOfString:imgtag];
        range2 = [word rangeOfString:herftag];
        if(range1.location == NSNotFound)
        {
            if(range2.location == NSNotFound){
                dectextstr=[dectextstr stringByAppendingString:word];
            }
        }
    }
    html=dectextstr;
    html=[html stringByReplacingOccurrencesOfString:@"</p>" withString:@"</br>"];
    
    
    

    return html;
}
-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}


-(IBAction)choosetimerbtnpressd:(id)sender
{
	UIActionSheet *myActionSheetshare=[[UIActionSheet alloc] initWithTitle:@"Timers" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Stopwatch",@"Interval",@"Countdown",@"Tabata",nil];
	[myActionSheetshare showInView:self.view];
	[myActionSheetshare release];
}
-(IBAction)workoutbtnpressed:(id)sender
{
	WorkOutViewController *workoutView=[[WorkOutViewController alloc]init];
	[self.navigationController pushViewController:workoutView animated:NO];
	[workoutView release];
}
-(IBAction)Movementbtnpressed:(id)sender
{
	MovementsViewController *MovementsView=[[MovementsViewController alloc]init];
	[self.navigationController pushViewController:MovementsView animated:NO];
	[MovementsView release];
}
-(IBAction)Logsbtnpressed:(id)sender
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
-(IBAction)Settingsbtnpressed:(id)sender
{
	SettingsViewControllers *SettingsView=[[SettingsViewControllers alloc]init];
	[self.navigationController pushViewController:SettingsView animated:NO];
	[SettingsView release];
}

-(IBAction)feedbuttonpressed:(id)sender
{
	[commentsview removeFromSuperview];
	AddFeedViewController *AddFeed=[[AddFeedViewController alloc]init];
	[self.navigationController pushViewController:AddFeed animated:YES];
	[AddFeed release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		StopWatchViewController *stopwatch=[[StopWatchViewController alloc]init];
		[self.navigationController pushViewController:stopwatch animated:YES];
		[stopwatch release];
	}
    else if(buttonIndex==1) {
		IntervallSettingViewController *IntervallSettingView=[[IntervallSettingViewController alloc]init];
		[self.navigationController pushViewController:IntervallSettingView animated:YES];
		[IntervallSettingView release];
	}
	else if(buttonIndex==2) {
		CountDownViewController *CountDownView=[[CountDownViewController alloc]init];
		[self.navigationController pushViewController:CountDownView animated:YES];
		[CountDownView release];
	}
	else if(buttonIndex==3) {
		TabataSettingsViewController *TabataSettingsView=[[TabataSettingsViewController alloc]init];
		[self.navigationController pushViewController:TabataSettingsView animated:YES];
		[TabataSettingsView release];
	}
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
	rssItems = nil;
	[rssItems release];
    [super dealloc];
}


@end
