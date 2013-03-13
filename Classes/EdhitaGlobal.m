//
//  EdhitaGlobal.m
//  Edhita
//
//  Created by Tatsuya Tobioka on 13/03/13.
//
//

#import "EdhitaGlobal.h"

@implementation EdhitaGlobal

@end
/*
@implementation UIViewController (Autorotate)
// iOS 6~
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// ~iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}
@end
*/
@implementation UINavigationController (Autorotate)
// iOS 6~
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end

@implementation UISplitViewController (Autorotate)
// iOS 6~
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end

@implementation UITableViewController (Autorotate)
// iOS 6~
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end
