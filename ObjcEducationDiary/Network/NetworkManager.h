//
//  NetworkManager.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 25.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^completion)(id _Nullable, NSError * _Nullable);

@interface NetworkManager : NSObject

+ (void)getRequest:(NSString *)path
  commpletionBlock:(completion)completionBlock;
+ (void)deleteRequest:(NSString *)path
        identificator:(NSString *)identificator
     commpletionBlock:(completion)completionBlock;
+ (void)putRequest:(NSString *)path
     identificator:(NSString *)identificator
              data:(NSData *)data
  commpletionBlock:(completion)completionBlock;
+ (void)patchRequest:(NSString *)path
       identificator:(NSString *)identificator
                data:(NSData *)data
    commpletionBlock:(completion)completionBlock;

@end

NS_ASSUME_NONNULL_END
