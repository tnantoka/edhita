/**
 * AdMobDelegateProtocol.h
 * AdMob iPhone SDK publisher code.
 *
 * Defines the AdMobDelegate protocol.
 */
#import <UIKit/UIKit.h>
@class AdMobView;

// Constant for use with testDevices method.
#define ADMOB_SIMULATOR_ID @"Simulator"


@protocol AdMobDelegate<NSObject>


@required

#pragma mark -
#pragma mark required methods

// Use this to provide a publisher id for an ad request. Get a publisher id
// from http://www.admob.com.  adView will be nil for interstitial requests.
- (NSString *)publisherIdForAd:(AdMobView *)adView;

// Return the current view controller (AdMobView should be part of its view heirarchy).
// Make sure to return the root view controller (e.g. a UINavigationController, not
// the UIViewController attached to it).  If there is no UIViewController return nil.
// adView will be nil for interstitial requests.
- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView;


@optional

#pragma mark -
#pragma mark optional notification methods

// Sent when an ad request loaded an ad; this is a good opportunity to add
// this view to the hierachy, if it has not yet been added.
// Note that this will only ever be sent once per AdMobView, regardless of whether
// new ads are subsequently requested in the same AdMobView.
- (void)didReceiveAd:(AdMobView *)adView;

// Sent when a AdMobView successfully makes a subsequent ad request (via requestFreshAd).
// For example an AdView object that shows three ads in its lifetime will see the following
// methods called:  didReceiveAd:, didReceiveRefreshedAd:, and didReceiveRefreshedAd:.
- (void)didReceiveRefreshedAd:(AdMobView *)adView;

// Sent when an ad request failed to load an ad.
// Note that this will only ever be sent once per AdMobView, regardless of whether
// new ads are subsequently requested in the same AdMobView.
- (void)didFailToReceiveAd:(AdMobView *)adView;

// Sent when subsequent AdMobView ad requests fail (via requestFreshAd).
- (void)didFailToReceiveRefreshedAd:(AdMobView *)adView;


// Sent just before presenting the user a full screen view, such as a canvas page or an embedded webview,
// in response to clicking on an ad. Use this opportunity to stop animations, time sensitive interactions, etc.
- (void)willPresentFullScreenModalFromAd:(AdMobView *)adView;

// Sent just after presenting the user a full screen view, such as a canvas page or an embedded webview,
// in response to clicking on an ad.
- (void)didPresentFullScreenModalFromAd:(AdMobView *)adView;

// Sent just before dismissing a full screen view.
- (void)willDismissFullScreenModalFromAd:(AdMobView *)adView;

// Sent just after dismissing a full screen view. Use this opportunity to
// restart anything you may have stopped as part of -willPresentFullScreenModal:.
- (void)didDismissFullScreenModalFromAd:(AdMobView *)adView;

// Send just before the application will close because the user clicked on an ad.
// Clicking on any ad will either call this or willPresentFullScreenModal.
// The normal UIApplication applicationWillTerminate: delegate method will be called
// after this.
- (void)applicationWillTerminateFromAd:(AdMobView *)adView;


#pragma mark optional appearance control methods

// Specifies the ad background color, for tile+text ads.
// Defaults to [UIColor colorWithRed:0.443 green:0.514 blue:0.631 alpha:1], which is a chrome-y color.
// Note that the alpha channel in the provided color will be ignored and treated as 1.
// We recommend against using a white or very light color as the background color, but
// if you do, be sure to implement primaryTextColor and secondaryTextColor.
// Grayscale colors won't function correctly here. Use e.g. [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
// instead of [UIColor colorWithWhite:0 alpha:1] or [UIColor blackColor].
- (UIColor *)adBackgroundColorForAd:(AdMobView *)adView;

// Specifies the primary text color for ads.
// Defaults to [UIColor whiteColor].
- (UIColor *)primaryTextColorForAd:(AdMobView *)adView;

// Specifies the secondary text color for ads.
// Defaults to [UIColor whiteColor].
- (UIColor *)secondaryTextColorForAd:(AdMobView *)adView;


#pragma mark optional test ad methods

// Test ads are returned to these devices.  Device identifiers are the same used to register
// as a development device with Apple.  To obtain a value open the Organizer 
// (Window -> Organizer from Xcode), control-click or right-click on the device's name, and
// choose "Copy Device Identifier".  Alternatively you can obtain it through code using
// [UIDevice currentDevice].uniqueIdentifier.
//
// For example:
//    - (NSArray *)testDevices {
//      return [NSArray arrayWithObjects:
//              ADMOB_SIMULATOR_ID,                             // Simulator
//              //@"28ab37c3902621dd572509110745071f0101b124",  // Test iPhone 3GS 3.0.1
//              //@"8cf09e81ef3ec5418c3450f7954e0e95db8ab200",  // Test iPod 2.2.1
//              nil];
//    }
- (NSArray *)testDevices;

// If implemented, lets you specify the action type of the test ad. Defaults to @"url" (web page).
// Does nothing if testDevices is not implemented or does not map to the current device.
// Acceptable values are @"url", @"app", @"movie", @"call", @"canvas".  For interstitials
// use "video_int".
//
// Normally, the adservers restricts ads appropriately (e.g. no click to call ads for iPod touches).
// However, for your testing convenience, they will return any type requested for test ads.
- (NSString *)testAdActionForAd:(AdMobView *)adView;


#pragma mark optional targeting info methods

// If your application uses CoreLocation you can provide the current coordinates to help
// provide more relevant ads to your users.  Note it is against Apple's policy to use 
// CoreLocation just for serving ads.
//
// For example:
//    - (double)locationLatitude {
//      return myCLLocationManager.location.coordinate.latitude;
//    }
//    - (double)locationLongitude {
//      return myCLLocationManager.location.coordinate.longitude;
//    }
//    - (NSDate *)locationTimestamp {
//      return myCLLocationManager.location.timestamp;
//    }
- (double)locationLatitude;
- (double)locationLongitude;
- (NSDate *)locationTimestamp;

// The following functions, if implemented, provide extra information
// for the ad request. If you happen to have this information, providing it will
// help select better targeted ads and will improve monetization.
//
// Keywords and search terms should be provided as a space separated string
// like "iPhone monetization San Mateo". We strongly recommend that
// you NOT hard code keywords or search terms.
//
// Keywords are used to select better ads; search terms _restrict_ the available
// set of ads. Note, then, that providing a search string may seriously negatively
// impact your fill rate; we recommend using it only when the user is submitting a
// free-text search request and you want to _only_ display ads relevant to that search.
// In those situations, however, providing a search string can yield a significant
// monetization boost.
//
// For all of these methods, if the information is not available at the time of
// the call, you should return nil.
- (NSString *)postalCode; // user's postal code, e.g. "94401"
- (NSString *)areaCode; // user's area code, e.g. "415"
- (NSDate *)dateOfBirth; // user's date of birth
- (NSString *)gender; // user's gender (e.g. @"m" or @"f")
- (NSString *)keywords; // keywords the user has provided or that are contextually relevant, e.g. @"twitter client iPhone"
- (NSString *)searchString; // a search string the user has provided, e.g. @"Jasmine Tea House San Francisco"


#pragma mark -
#pragma mark deprecated methods

// The following methods were deprecated in favor of new methods that accept an AdMobView parameter

- (NSString *)publisherId;
- (UIViewController *)currentViewController;
- (void)willPresentFullScreenModal;
- (void)didPresentFullScreenModal;
- (void)willDismissFullScreenModal;
- (void)didDismissFullScreenModal;
- (void)applicationWillTerminateFromAd;
- (UIColor *)adBackgroundColor;
- (UIColor *)primaryTextColor;
- (UIColor *)secondaryTextColor;
- (NSString *)testAdAction;

// The following methods were defined in previous AdMob SDKs but are now ignored

- (BOOL)useGraySpinner DEPRECATED_ATTRIBUTE;
- (BOOL)mayAskForLocation DEPRECATED_ATTRIBUTE; // implement the location* methods instead
- (id)location DEPRECATED_ATTRIBUTE; // implement the location* methods instead
- (BOOL)useTestAd DEPRECATED_ATTRIBUTE; // implement the testDevices method instead

@end
