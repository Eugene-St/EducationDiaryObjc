//
//  Mediator.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import <UIKit/UIKit.h>
#import "Model.h"
#import "NetworkMonitor.h"

NS_ASSUME_NONNULL_BEGIN

@interface Mediator : NSObject

@property (strong, nonatomic) NSString *path;
@property (assign, nonatomic) Class modelClass;
- (void)fetchData:(void(^)(id object, NSError *err))completionBlock;
- (void)deleteData:(id<Model>)model :(void(^)(id, NSError*))completionBlock;
- (void)createNewData:(id<Model>)model :(void(^)(id, NSError*))completionBlock;
- (void)updateData:(id<Model>)model :(void(^)(id, NSError*))completionBlock;
- (instancetype)initWithPath:(NSString*)path modelCLass:(Class)modelCLass;

- (void)saveToDB:(id)objects :(void(^)(NSError*))completionBlock;
- (void)createInDB:(id)object :(void(^)(NSError*))completionBlock;
- (void)updateInDB:(id)object :(void(^)(NSError*))completionBlock;
- (void)fetchFromDB :(void(^)(id, NSError*))completionBlock;
- (void)deleteFromDB:(id)object :(void(^)(NSError*))completionBlock;
- (void)deleteEntitiesFromDB:(void(^)(NSError*))completionBlock;

//- (BOOL)networkIsAvailable;

@end

NS_ASSUME_NONNULL_END
