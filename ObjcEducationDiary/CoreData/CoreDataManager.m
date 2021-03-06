//
//  CoreDataManager.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 06.04.2021.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

+ (id)sharedInstance {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (!self) return nil;
    [self persistentContainer];
    _context = _persistentContainer.viewContext;
    NSLog(@"context %@", _context);
    return self;
}

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ObjcEducationDiary"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    return _persistentContainer;
}

- (void)saveContext {
    NSError *error = nil;
    if ([_context hasChanges] && ![_context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)deleteItem:(id)item completion:(errorCompletionBlock)completion {
    [_context deleteObject:item];
    NSError *error;
    if (![self.context save:&error]) {
        completion(error);
    }
}

- (void)saveItems:(errorCompletionBlock)completion {
    if (_context.hasChanges) {
        NSError *error;
        if (![self.context save:&error]) {
            completion(error);
        }
    }
}

- (void)fetch:(NSString *)entity completion:(completion)completion {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:_context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entityDescription;
    NSError *error = nil;
    NSArray* objects = [_context executeFetchRequest:request error:&error];
    if (error) {
        completion(nil, error);
    } else {
        completion(objects, nil);
    }
}

- (void)resetAllRecords:(NSString *)entity completion:(errorCompletionBlock)completion {
    NSFetchRequest<NSFetchRequestResult> *deleteFetch = [NSFetchRequest<NSFetchRequestResult> fetchRequestWithEntityName:entity];
    NSBatchDeleteRequest *deleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:deleteFetch];
    NSError *error;
    [_context executeRequest:deleteRequest error:&error];
    if (![self.context save:&error]) {
        completion(error);
    }
}

@end
