//
//  NetworkMonitor.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 08.04.2021.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMonitor : NSObject

@property (nonatomic, assign) BOOL isInternetReachable;
@property (nonatomic, strong) Reachability *internetReachableFoo;

- (void)internetIsAvailable;
+ (id)sharedInstance;

@end

NS_ASSUME_NONNULL_END
