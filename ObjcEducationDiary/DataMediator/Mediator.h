//
//  Mediator.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import <Foundation/Foundation.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mediator : NSObject

@property (strong, nonatomic) NSString *pathForFetch;
@property (strong, nonatomic) NSString *pathForUpdate;

- (void)fetchData:(void(^)(id object, NSError *err))completionBlock;

- (void)deleteData:(id<Model>) model
                  :(void(^)(id, NSError*))completionBlock;

- (void)createNewData:(id<Model>) model
                     :(void(^)(id, NSError*))completionBlock;

- (instancetype)initWithPathForUpdate:(NSString*)pathForUpdate pathForFetch:(NSString*)pathForFetch;

@end

NS_ASSUME_NONNULL_END
