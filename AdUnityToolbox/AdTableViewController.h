

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADInterstitialDelegate.h"
#import "InMobi.h"
#import "IMBanner.h"
#import "IMBannerDelegate.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"

#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>


@class GADBannerView;
@class GADRequest;
@class GADInterstitial;

enum kAdType
{
    kAdmob,
    kAdmobInter,
    
    kCB,
    kCBVideo,
    kCBVideoReward,
    kCBMoreGames,
   
    kVungle,
    kAdColony,
   // kFlurryVideo,
    
    kInmobi,
    kInmobiInter,
    
    kRevmob,
    kRevmobInter,
    kRevmobAdLink,
    kRevmobPopup,

    
    

    kiAd,
};

@interface AdTableViewController : UITableViewController<GADBannerViewDelegate,GADInterstitialDelegate,IMBannerDelegate,IMInterstitialDelegate>{
    
    GADBannerView *bannerAdmob;//实例变量 bannerView_是一个view
   // GADInterstitial *interstitial;
    
    
    IMBanner *bannerInmob;
    IMInterstitial *inmobInterstitial;//inmob
    
    int cbDisplayVideoInterstitial;
    
     enum kAdType adType;
    
}


@property(nonatomic, strong) GADInterstitial *interstitial;
@end
