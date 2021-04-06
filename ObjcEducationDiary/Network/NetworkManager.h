//
//  NetworkManager.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^completion)(id, NSError*);

@interface NetworkManager : NSObject

+ (void) getRequest: (NSString *)path :(void(^)(NSData *dat, NSError *err))completionBlock;
+ (void) deleteRequest:(NSString *)path :(NSString *) identificator :(completion)completionBlock;
+ (void) putRequest:(NSString *)path :(NSString *) identificator :(NSDictionary *) body :(completion)completionBlock;
+ (void)patchRequest:(NSString *)path :(NSString *) identificator :(NSDictionary *) body :(completion)completionBlock;

@end

NS_ASSUME_NONNULL_END
