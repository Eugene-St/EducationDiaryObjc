//
//  CoreDataManager.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 06.04.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^completion)(id _Nullable, NSError * _Nullable);
typedef void(^errorCompletionBlock)(NSError * _Nullable);

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSManagedObjectContext *context;

+ (id)sharedInstance;
- (void)saveContext;
- (void)deleteItem:(id)item completion:(errorCompletionBlock)completion;
- (void)saveItems:(errorCompletionBlock)completion;
- (void)resetAllRecords:(NSString *)entity completion:(errorCompletionBlock)completion;
- (void)fetch:(NSString*)entity completion:(completion)completion;

@end

NS_ASSUME_NONNULL_END
