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

typedef void(^completion)(id _Nullable, NSError * _Nullable);
typedef void(^errorCompletionBlock)(NSError * _Nullable);

@interface Mediator : NSObject

@property (strong, nonatomic) NSString *path;
@property (assign, nonatomic) Class modelClass;

- (instancetype)initWithPath:(NSString*)path modelCLass:(Class)modelCLass;
- (void)fetchData:(completion)completionBlock;
- (void)deleteData:(id<Model>)model :(completion)completionBlock;
- (void)createNewData:(id<Model>)model :(completion)completionBlock;
- (void)updateData:(id<Model>)model :(completion)completionBlock;
- (void)saveToDB:(id)objects :(errorCompletionBlock)completionBlock;
- (void)createInDB:(id)object :(errorCompletionBlock)completionBlock;
- (void)updateInDB:(id)object :(errorCompletionBlock)completionBlock;
- (void)fetchFromDB :(completion)completionBlock;
- (void)deleteFromDB:(id)object :(errorCompletionBlock)completionBlock;
- (void)deleteEntitiesFromDB:(errorCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
