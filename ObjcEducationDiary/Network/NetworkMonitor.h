//
//  NetworkMonitor.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 08.04.2021.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <netinet/in.h>
#import <netinet6/in6.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMonitor : NSObject

//- (BOOL)isInternetReachable;
@property (strong, nonatomic) Reachability *internetReachableFoo;
- (void)internetIsAvailable;
+ (id)sharedInstance;
- (BOOL)connected;

@end

NS_ASSUME_NONNULL_END
