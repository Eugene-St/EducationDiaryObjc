//
//  NetworkMonitor.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 08.04.2021.
//

#import "NetworkMonitor.h"

@implementation NetworkMonitor

+ (id)sharedInstance {
    static NetworkMonitor *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)internetIsAvailable {
    _internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    __weak typeof(self) weakSelf = self;
    // Internet is reachable
    _internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:@"InternetAppeared" object:nil];
            weakSelf.isInternetReachable = true;
        });
    };
    
    // Internet is not reachable
    _internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:@"InternetDisappeared" object:nil];
            weakSelf.isInternetReachable = false;
        });
    };
    [_internetReachableFoo startNotifier];
}

@end
