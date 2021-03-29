//
//  Mediator.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Mediator : NSObject

- (void) fetchData: (void(^)(id object, NSError *err))completionBlock;

@end

NS_ASSUME_NONNULL_END
