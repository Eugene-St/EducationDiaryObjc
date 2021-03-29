//
//  NetworkManager.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

+(void) fetchDataFromNetwork:(void(^)(NSData *dat, NSError *err))completionBlock;

@end

NS_ASSUME_NONNULL_END
