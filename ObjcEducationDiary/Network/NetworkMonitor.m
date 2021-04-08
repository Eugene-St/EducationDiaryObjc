//
//  NetworkMonitor.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 08.04.2021.
//

#import "NetworkMonitor.h"

@implementation NetworkMonitor

/*
- (BOOL)isInternetReachable
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;

    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags;

    if(reachability == NULL)
        NSLog(@"Someone broke the internet :(");
        return false;

    if (!(SCNetworkReachabilityGetFlags(reachability, &flags)))
        NSLog(@"Someone broke the internet :(");
        return false;

    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
        // if target host is not reachable
        NSLog(@"Someone broke the internet :(");
        return false;

    BOOL isReachable = false;

    if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
    {
        NSLog(@"Yayyy, we have the interwebs!");
        
        // if target host is reachable and no connection is required
        //  then we'll assume (for now) that your on Wi-Fi
        isReachable = true;
    }


    if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
         (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
    {
        // ... and the connection is on-demand (or on-traffic) if the
        //     calling application is using the CFSocketStream or higher APIs

        if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
        {
            // ... and no [user] intervention is needed
            
            NSLog(@"Yayyy, we have the interwebs!");
            isReachable = true;
        }
    }

    if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
    {
        // ... but WWAN connections are OK if the calling application
        //     is using the CFNetwork (CFSocketStream?) APIs.
        NSLog(@"Yayyy, we have the interwebs!");
        isReachable = true;
    }
    return isReachable;
}
*/


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
    
    // Internet is reachable
    _internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:@"InternetAppeared" object:nil];
            NSLog(@"Yayyy, we have the interwebs!");
            self.isInternetReachable = true;
        });
    };

    // Internet is not reachable
    _internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSNotificationCenter.defaultCenter postNotificationName:@"InternetDisappeared" object:nil];
            NSLog(@"Someone broke the internet :(");
            self.isInternetReachable = false;
        });
    };

    [_internetReachableFoo startNotifier];
}


/*
- (BOOL)connected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}
*/

@end
