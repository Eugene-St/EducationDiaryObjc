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

@interface CoreDataManager : NSObject

@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSManagedObjectContext *context;

+ (id)sharedInstance;
- (void)saveContext;
- (void)deleteItem:(id)item :(void(^)(NSError * _Nullable))completion;
- (void)saveItems:(void(^)(NSError * _Nullable))completion;
- (void)resetAllRecords:(NSString *)entity :(void(^)(NSError * _Nullable))completion;
- (void)fetch:(NSString*)entity :(void(^)(id _Nullable, NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
