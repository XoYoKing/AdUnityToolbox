//
//  AdTableViewController.m
//  AdUnityToolbox
//
//  Created by APPLE on 9/5/14.
//  Copyright (c) 2014 GankoTech. All rights reserved.
//

#import "AdTableViewController.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
//#import "AdManager.h"
//#import "UMFeedback.h"
#import "Chartboost/Chartboost.h"
#import <VungleSDK/VungleSDK.h>

#import <AdColony/AdColony.h>
#import "UIView+Toast.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface AdTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AdTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)removeAllBanner
{
    [self removeBannerAdmob];
    [self removeBannerInmob];
    [self basicUsageHideBanner];
}

-(void) createAd:(enum kAdType) type
{
    // if ([AdManager inst].bannerShowSetting==eAll) {
    switch (type) {
        case kAdmob:
            [self removeAllBanner];
            [self showBannerAdmob];
            
            break;
        case kAdmobInter:
            [self showInterstitialAdmob];
            break;
        case kCB:
            [self showCBInterstitial];
            break;
        case kCBVideo:
            [self showCBVideo];
            break;
        case kCBVideoReward:
            [self showCBVideoReward];
            break;
        case kCBMoreGames:
            [self moreAppCB];
            break;
        case kInmobi:
            [self removeAllBanner];
            [self showBannerInmob];//
            break;
        case kInmobiInter:
            [self showInterstitialInmob];
            break;
        case kRevmob:
            [self removeAllBanner];
            [self basicUsageShowBanner];
            break;
        case kRevmobInter:
            [self basicUsageShowFullscreen];
            break;
        case     kRevmobAdLink:
            [self basicUsageOpenAdLink];
            break;
        case        kRevmobPopup:
            [self basicUsageShowPopup];
            break;
        case kVungle:
            //  [self showVungleAd];
            [self showVungleAdAdvance];//
            break;
        case kAdColony:
            [self showAdColony];
            break;
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:@"AdView"];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void) backPressed:(UIButton *) sender {
   // [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    UIStoryboard *story =[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *newViewController = [[UINavigationController alloc]init];
    newViewController=[story instantiateViewControllerWithIdentifier:@"mybetListBar"];
    [self presentViewController:newViewController animated:YES completion:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setToolbarHidden:NO];
    
 /*   UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Document" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem = anotherButton;
  */
  //  [anotherButton release];

    
    // [self.navigationController setNavigationBarHidden:YES];
    // [self toast:@"FSDSDFS"];
    cbDisplayVideoInterstitial=0;
    _dataSource= [NSMutableArray arrayWithObjects:
                  @"Admob Banner"
                  ,@"Admob Interstitial"
                  ,@"Chartboost Interstitial"
                  ,@"Chartboost Video"
                  ,@"Chartboost Rewarded Video"
                  ,@"Chartboost MoreApps"
                  
                  ,@"Vungle Video"
                  ,@"AdColony Video"
                  //,@"Flurry Video"
                  
                  ,@"Inmobi Banner"
                  ,@"Inmobi Interstitial"
                  
                  ,@"Revmob Banner"
                  ,@"Revmob Interstitial"
                  ,@"Revmob AdLink"
                  ,@"Revmob Popup"
                  ,nil];
    // adType=kAdmob;
    CGRect adFrame=[self getBannerSize:self.interfaceOrientation];
    [self loadBannerAdmob:adFrame];
    // [self createAd:adType];
    
    /*  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     [self.tableView selectRowAtIndexPath:indexPath
     animated:NO
     scrollPosition:UITableViewScrollPositionMiddle];
     */
    
    /*
     NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
     [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
     */
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
    
    [Chartboost  cacheInterstitial:CBLocationLevelComplete];
    [Chartboost  cacheRewardedVideo:CBLocationLevelComplete];
    [Chartboost  cacheMoreApps:CBLocationHomeScreen];
    
    [self loadInterstitialAdmob];
    
    [self loadBannerInmob:adFrame];
    [self removeBannerInmob];
    
    [self loadInterstitialInmobi];
    [self resizeTable];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;//
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNo = indexPath.row;
    [self createAd:rowNo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

-(void)resizeTable
{
    return;
    CGRect tableFrame = self.tableView.frame;
    NSLog(@"tableFrame.size.height=%f",tableFrame.size.height);
    tableFrame.size.height -= [self getBannerHeight];
    //bannerView_.frame.size.height;
    
    self.tableView.frame = tableFrame;
    [self.tableView setFrame:tableFrame];
    NSLog(@"tableFrame.size.height=%f",tableFrame.size.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* static NSString *CellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     UIFont *cellFont = [UIFont fontWithName:@"Verdana" size:12.0];
     cell.textLabel.text=@"D";// [self getRowData:indexPath.section];
     cell.textLabel.font = cellFont;
     cell.textLabel.numberOfLines=0;
     */
    /* UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
     if (cell == nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] ;
     cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
     cell.textLabel.numberOfLines = 0;
     cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
     cell.textLabel.text=@"fsd";//
     }
     */
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    cell.textLabel.text = [self.dataSource objectAtIndex:(NSUInteger)indexPath.row];//[mutArr objectAtIndex:indexPath.section];
    // NSLog(@"%@",cell.textLabel.text);
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png" ]];
    
    /*  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
     
     if (!cell) {
     cell = [UITableViewCell  initWithCode:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell" ];
     }
     //  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
     
     // Configure the cell...
     */
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:cellText
     attributes:@
     {
     NSFontAttributeName: cellFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height + 20;
}



/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //#ifdef
    
    [self setAd: toInterfaceOrientation];
    
    //#endif
}

-(void) setAd:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect frame =[self getBannerSize:toInterfaceOrientation];
    bannerInmob.frame= frame;
    bannerAdmob.frame = frame;
    [self resizeTable];
}

//higher than width allways
-(CGFloat) getBannerHeight
{
    return isPad?GAD_SIZE_728x90.height:GAD_SIZE_320x50.height;
}

-(CGFloat) getBannerWidth
{
    return isPad?GAD_SIZE_728x90.width:GAD_SIZE_320x50.width;
}

-(void) printCGRect:(CGRect) rc namePrint:(NSString*) name
{
    NSLog(@"!!! %@ rc(%f,%f,%f,%f)",name,rc.origin.x,rc.origin.y,rc.size.width,rc.size.height);
}

-(CGRect)getViewRect
{
    return self.navigationController.view.frame;
}

-(CGRect) getBannerSize:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect rcTmp;
    rcTmp.size=GAD_SIZE_728x90;
    // [self printCGRect:rcTmp namePrint:@" GAD_SIZE_728x90 " ];
    
    //水平,
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        //无论怎么翻转,view.frame的width和height值都是不变的,width都比height小,以立着的为准
        //           GAD_SIZE_728x90也是一样                            大
        [self printCGRect:[self getViewRect] namePrint:@" UIInterfaceOrientationIsLandscape self.view.frame" ];
        CGRect rc=CGRectMake(([self getViewRect].size.height -   [self getBannerWidth]) / 2,  [self getViewRect].size.width -
                             [self getBannerHeight],
                             [self getBannerWidth],
                             [self getBannerHeight]
                             );
        
        [self printCGRect:rc namePrint:@"UIInterfaceOrientationIsLandscape adbanner" ];
        return rc;
    }
    else//竖着放,
    {
        [self printCGRect:[self getViewRect] namePrint:@" Port self.view.frame" ];
        CGRect rc= CGRectMake(([self getViewRect].size.width -   [self getBannerWidth]) / 2,  [self getViewRect].size.height -
                              [self getBannerHeight],
                              [self getBannerWidth],
                              [self getBannerHeight]
                              );
        [self printCGRect:rc namePrint:@"UIInterfaceOrientationIsLandscape adbanner" ];
        return  rc;
        
    }
    
}


-(void) loadBannerAdmob :(CGRect)adFrame
{
    // NSDate *start = [NSDate date];
    // do stuff...
    /* CFTimeInterval timeNow=CACurrentMediaTime();
     CFTimeInterval elapsedTime =timeNow  - timeLast;
     timeLast=timeNow;
     // NSTimeInterval timeInterval = [timeLast timeIntervalSinceNow];
     NSLog(@"elapsedTime=%f",elapsedTime);
     if(elapsedTime<3)
     {
     NSLog(@"!!! ### loadBannerAdmob too much times!");
     return;
     }
     */
    
    NSLog(@"!!! loadBannerAdmob");
    bannerAdmob = [[GADBannerView alloc]init];
    [bannerAdmob setDelegate:self];
    
    [bannerAdmob setFrame:adFrame];
    bannerAdmob.adUnitID =MY_BANNER_UNIT_ID;
    
    bannerAdmob.rootViewController = self;//self.viewController;
    [[self getView] addSubview:bannerAdmob];
    
    // Initiate a generic request to load it with an ad.
    //[GADRequest request].testing = YES;
    
    //   [GADRequest request].testDevices = [NSArray arrayWithObjects:MY_BANNER_UNIT_ID, nil];
    
    [bannerAdmob loadRequest:[GADRequest request]];
}

-(void) loadBannerInmob :(CGRect)adFrame
{
    NSLog(@"!!! loadBannerInmob");
    
    // CGRect adFrame = CGRectMake((viewFrame.size.width - adSize.width) / 2, 70, adSize.width, adSize.height);
    
    bannerInmob = [[IMBanner alloc] initWithFrame:adFrame
                                            appId:BANNER_APP_ID
                                           adSize:isPad?11:15 ];
    
    [bannerInmob setDelegate:self];
    [bannerInmob loadBanner];
    
    // [adView ]
    
}
-(void) loadInterstitialAdmob
{
    /*
     if (_admobIntersOK) {
     NSLog(@"!!!!!!!!!!! loadInterstitial _admobIntersOK has already loaded");
     
     return;
     }*/
    
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    
    // Note: Edit SampleConstants.h to update kSampleAdUnitId with your interstitial ad unit id.
    self.interstitial.adUnitID = kAdUnitIDIns;
    [self.interstitial loadRequest:[self request]];
    //   _admobIntersOK=NO;
    //[self.loadingSpinner startAnimating];
    
    //  self.showInterstitialButton.enabled = NO;
}

-(void) loadInterstitialInmobi
{
    inmobInterstitial = [[IMInterstitial alloc] initWithAppId:INTERSTITIAL_APP_ID];
    inmobInterstitial.delegate = self;
    
    //  [activityIndicator startAnimating];
    //   statusLabel.hidden = NO;
    [inmobInterstitial loadInterstitial];
}

-(BOOL) showInterstitialInmob
{
    NSLog(@"inmobi Interstitial state:%d",inmobInterstitial.state);
    BOOL showOK=FALSE;
    if (inmobInterstitial.state==kIMInterstitialStateReady
        //  ||kIMInterstitialStateLoading==inmobInterstitial.state
        ) {
        [self toast:@"inmobi Interstitial"];
        
        [inmobInterstitial presentInterstitialAnimated:YES];
        showOK=TRUE;
    }
    else
    {
        [self toast:@"inmobi Interstitial still downloading..."];
        [self loadInterstitialInmobi];
    }
    
    return showOK;
}

-(BOOL) showInterstitialAdmob
{
    BOOL showOK=FALSE;
    if (self.interstitial !=nil
        && [self.interstitial isReady]
        //&&![self.interstitial hasBeenUsed]
        ) {
        [self toast:@"admob Interstitial"];
        [self.interstitial presentFromRootViewController:self];
        showOK=TRUE;
    }
    else
    {
        [self toast:@"admob Interstitial still downloading..."];
        [self loadInterstitialAdmob];
    }
    
    return showOK;
}

-(void) moreAppCB{
    
    if ([Chartboost  hasMoreApps:CBLocationHomeScreen]) {
        [self toast:@"Chartboost MoreApps displaying"];
        [Chartboost  showMoreApps:CBLocationHomeScreen];
    }
    else
    {
        [self toast:@"Chartboost MoreApps still downloading..."];
           [Chartboost  showMoreApps:CBLocationHomeScreen];
    }
    
    [Chartboost  cacheMoreApps:CBLocationHomeScreen];
    
}

-(BOOL)showCBInterstitial:(CBLocation)location
{
    BOOL bRet=NO;
    if([Chartboost  hasInterstitial:location]) {
        
        [Chartboost  showInterstitial:location];
        [self toast:@"Chartboost Interstitial displaying"];
        bRet=YES;
    }
    else
    {
        [self toast:@"Chartboost Interstitial still downloading..."];
    }
    
    [Chartboost  cacheInterstitial:location];
    return bRet;
}

-(BOOL)showCBInterstitial
{
    BOOL bRet=NO;
    if([Chartboost  hasInterstitial:CBLocationLevelComplete]) {
        
        [Chartboost  showInterstitial:CBLocationLevelComplete];
        [self toast:@"Chartboost Interstitial displaying"];
        bRet=YES;
    }
    else
    {
        [self toast:@"Chartboost Interstitial still downloading..."];
    }
    
    [Chartboost  cacheInterstitial:CBLocationLevelComplete];
    return bRet;
}

-(BOOL) loadChartboost
{
    if (cbDisplayVideoInterstitial%2==0) {
        if(![self showCBInterstitial])
        {
            [self showCBVideo];
        }
    }
    else
    {
        if(![self showCBVideo])
        {
            [self showCBInterstitial];
        }
    }
    
    cbDisplayVideoInterstitial++;
    return NO;
}

-(BOOL)showCBVideo
{
    BOOL bRet=NO;
    if([Chartboost  hasInterstitial:CBLocationMainMenu]) {
        
        [Chartboost  showInterstitial:CBLocationMainMenu];
        [self toast:@"Chartboost Video Interstitial displaying"];
        bRet=YES;
    }
    else
    {
        [self toast:@"Chartboost Video Interstitial still downloading..."];
    }
    
    [Chartboost  cacheInterstitial:CBLocationMainMenu];
    return bRet;
    
}

-(BOOL)showCBVideoReward
{
    
    
    BOOL ret=NO;
    
    if ([Chartboost hasRewardedVideo:CBLocationLevelComplete]) {
        [Chartboost showRewardedVideo:CBLocationLevelComplete];
        NSLog(@"FFUCK");
        [self toast:@"Chartboost Rewarded Video displaying"];
        ret=YES;
    }
    else
    {
        [self toast:@"Chartboost Rewarded Video still downloading..."];
    }
    
    [Chartboost cacheRewardedVideo:CBLocationLevelComplete];
    
    return ret;
}

-(void) toast:(NSString*) str
{
    //[[self getView]  hideToast: [self getView]];
    [[self getView] makeToast:str
                     duration:3.0
                     position:@"centerBottom"
                        title:nil];
    
    // [[self getView] makeToast:str];
}

-(BOOL) isInterstitialDisplaying
{
    return inmobInterstitial.state==kIMInterstitialStateActive;
}



- (GADRequest *)request {
    GADRequest *request = [GADRequest request];
    
    // Make the request for a test ad. Put in an identifier for the simulator as well as any devices
    // you want to receive test ads.
    request.testDevices = @[
                            // TODO: Add your device/simulator test identifiers here. Your device identifier is printed to
                            // the console when the app is launched.
                            GAD_SIMULATOR_ID
                            ];
    return request;
}

#pragma mark GADInterstitialDelegate implementation
//inmob
- (void)interstitialDidReceiveAd:(id)ad
{
    if([ad isKindOfClass:[GADInterstitial class]])
    {
        NSLog(@"!!! admob interstitialDidReceiveAd ");
        //[self interstitialDidReceiveAd:ad];
        //[self toast:@"admob Interstitial still loading..."];
    }
    else
    {//IMInterstitial *)
        //   [self interstitialDidReceiveAd:ad];
        NSLog(@"!!! inmob interstitialDidReceiveAd ok ");
    }
}

// Sent when an interstitial ad request failed
- (void)interstitial:(id)ad didFailToReceiveAdWithError:(id)error
{
    if([ad isKindOfClass:[IMInterstitial class]])
    {//IMInterstitial *
        //IMError *
        NSLog(@"!!! inmob didFailToReceiveAdWithError ");
        //[self interstitialDidReceiveAd:ad];
    }
    else
    {//IMInterstitial *)
        NSLog(@"!!!!!!! admob interstitial error!");
    }
}



/// Called before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(id)ad
{
    NSLog(@"will Dismissed screen");
    if([ad isKindOfClass:[IMInterstitial class]])
    {
        // if(GADInterstitial )
        [self loadInterstitialInmobi];
    }
    else
    {
        [self loadInterstitialAdmob];
    }
}

/// Called just after dismissing an interstitial and it has animated off the screen.
- (void)interstitialDidDismissScreen:(id)ad
{
    NSLog(@"Dismissed screen");
    
}




#pragma mark - Banner Request Notifications
-(void) removeBannerInmob
{
    NSLog(@"!!! removeBannerInmob");
    bannerInmob.hidden=YES;
    
    //  [adView setDelegate:nil];
    //   [adView removeFromSuperview];
    
}

-(void)  removeBannerAdmob
{
    NSLog(@"!!! removeBannerAdmob");
    
    bannerAdmob.hidden=YES;
    
    /*
     [bannerView_ setDelegate:nil];
     [bannerView_ removeFromSuperview];
     _adBanner=nil;
     */
}

//-(void) hideBanner
-(void) showBannerAdmob
{
    bannerAdmob.hidden=NO;
}

-(void) showBannerInmob
{
    bannerInmob.hidden=NO;
}

//-(void) showBanner



#pragma mark GADBannerViewDelegate implementation

// We've received an ad successfully.
//admob banner ok
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    
    // [self showBannerAdmob];
    NSLog(@"!!! admob banner load ok");
    //  bannerType=eAdmob;
    
    
    
}

//admob banner error
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    //NSLog(@"", [error localizedFailureReason]);
    NSString *errorMessage = [NSString stringWithFormat:@"Admob Banner Error: %@", [error localizedDescription]];
    
    [self toast:errorMessage];
    NSLog(@"%@",errorMessage);
    //  [self showBannerInmob];
    //   CGRect adFrame=[self getBannerSize:self.interfaceOrientation];
    //  [self loadBannerInmob:adFrame];
    
}
//end of admob banner
-(UIView*)getView
{
    return self.navigationController.view;
}

// inmob admob ok -Sent when an ad request was successful
- (void)bannerDidReceiveAd:(IMBanner *)banner {
    //[self showBannerInmob];
    
    NSLog(@"!!! inmob banner load ok");
    // [activityIndicator stopAnimating];
    //statusLabel.text = [NSString stringWithFormat:@"Loaded ad successfully."];
    // if (!bannerAdmobOK) {
    
    if(![[self getView].subviews containsObject:bannerInmob])
    {
        [[self getView] addSubview:bannerInmob];
        //  bannerType=eInmob;
        //[self removeBannerAdmob];
        
    }
    // }else {NSLog(@"### admob is displaying so inmob wait!");}
    
    
}

//inmob banner error
// Sent when the ad request failed. Please check the error code and
// localizedDescription for more information on wy this occured
- (void)banner:(IMBanner *)banner didFailToReceiveAdWithError:(IMError *)error {
    //TODO:
    //
    NSLog(@"!!! inmob banner load error");
    
    NSString *errorMessage = [NSString stringWithFormat:@"Inmobi Banner Error code: %ld, message: %@",(long)[error code], [error localizedDescription]];
    NSLog(@"%@", errorMessage);
    [self toast:errorMessage];
    // [self showBannerAdmob];
    //[self loadBannerAdmob:[self getBannerSize:self.interfaceOrientation]];
    
    //[activityIndicator stopAnimating];
    // statusLabel.text = errorMessage;
}

#pragma mark Banner Interaction Notifications

// Called when the banner is tapped or interacted with by the user
// Optional data is available to publishers to act on when using
// monetization platform to render promotional ads.
-(void)bannerDidInteract:(IMBanner *)banner withParams:(NSDictionary *)dictionary {
    NSLog(@"Interaction with Banner happened");
}

// Sent just before presenting the user a full screen view, in response to
// tapping on an ad.  Use this opportunity to stop animations, time sensitive
// interactions, etc.
- (void)bannerWillPresentScreen:(IMBanner *)banner {
    NSLog(@"Preparing to present screen");
}

// Sent just before dismissing a full screen view.
- (void)bannerWillDismissScreen:(IMBanner *)banner {
    NSLog(@"Preparing to dismiss screen");
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:
- (void)bannerDidDismissScreen:(IMBanner *)banner {
    NSLog(@"Dismissed screen");
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).
- (void)bannerWillLeaveApplication:(IMBanner *)banner {
    NSLog(@"Preparing to leave application");
}
//end of banner

-(BOOL)showVungleAdAdvance
{
    BOOL ret=NO;
    if ([[VungleSDK sharedSDK] isCachedAdAvailable]) {
        
        VungleSDK* sdk = [VungleSDK sharedSDK];
        
        // Dict to set custom ad options
        NSDictionary* options = @{@"orientations": @(UIInterfaceOrientationMaskLandscape),
                                  @"incentivized": @(NO),
                                  //  @"userInfo": @{@"user": @"developer"},
                                  @"showClose": @(YES)};
        [sdk playAd:self withOptions:options];
        [self toast:@"Vungle Video displaying"];
        ret=YES;
    }
    else {
        [self toast:@"Vungle Video still downloading..."];
        NSLog(@"@@@");
        
    }
    // Pass in dict of options, play ad
    
    return ret;
}

- (BOOL)showVungleAd
{
    if ([[VungleSDK sharedSDK] isCachedAdAvailable]) {
        // _showAdButton.enabled = NO;
        // _showAdWithOptionsButton.enabled = NO;
        
        VungleSDK* sdk = [VungleSDK sharedSDK];
        [sdk playAd:self];
        [self toast:@"Vungle Video displaying"];
        return YES;
        // When an ad has been cached, enable buttons
    } else {
        [self toast:@"Vungle Video still downloading..."];
        NSLog(@"@@@");
        
    }
    
    return NO;
    // Play a Vungle ad (with default options)
    
}

-(BOOL) showAdColonyZone:(NSString*)zone
{
    NSLog(@"Status:%d",[AdColony zoneStatusForZone:zone]);
    if([AdColony zoneStatusForZone:zone]==ADCOLONY_ZONE_STATUS_ACTIVE)
    {
        
        [AdColony playVideoAdForZone:zone withDelegate:nil];
        return YES;
    }
    else
    {
        NSLog(@"NOOO!!!!!");
    }
    
    
    return NO;
}

-(BOOL)showAdColony
{
    if(![self showAdColonyZone:ADCOLONY_ID_ZONE1])
    {
        if(![self showAdColonyZone:ADCOLONY_ID_ZONE2])
        {
            [self toast:@"AdColony Video still downloading..."];
            return NO;
        }
    }
    
    [self toast:@"AdColony Video displaying"];
    return YES;
}

//end of video


- (void)basicUsageShowFullscreen {
    [[RevMobAds session] showFullscreen];
}

- (void)basicUsageShowBanner {
    [[RevMobAds session] showBanner];
}

- (void)basicUsageHideBanner {
    [[RevMobAds session] hideBanner];
}

- (void)basicUsageShowPopup {
    [[RevMobAds session] showPopup];
}

- (void)basicUsageOpenAdLink {
    [[RevMobAds session] openAdLinkWithDelegate:self];
}


@end
