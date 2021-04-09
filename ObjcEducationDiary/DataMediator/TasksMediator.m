//
//  TasksMediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "TasksMediator.h"
#import "Task.h"

@implementation TasksMediator

- (instancetype)init {
    self = [super initWithPath:@"tasks" modelCLass:[Task class]];
    return self;
}

- (void)saveToDB:(id)objects :(errorCompletionBlock)completionBlock {
    if ([objects isKindOfClass:[NSMutableArray<Task *> class]]) {
        for (Task *task in objects) {
            TaskCoreData *taskCD = [[TaskCoreData alloc] initWithContext:[CoreDataManager.sharedInstance context]];
            [task mapToCoreData:taskCD];
        }
        [CoreDataManager.sharedInstance saveItems:^(NSError * _Nullable error) {
            completionBlock(error);
        }];
    }
}

- (void)fetchFromDB:(completion)completionBlock {
    [CoreDataManager.sharedInstance fetch:@"TaskCoreData" completion:^(id _Nullable objects, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
        }
        else {
            NSMutableArray<Task *> *tasks = NSMutableArray.new;
            for (TaskCoreData *taskObject in objects) {
                [tasks addObject:[[Task alloc] initWithCD:taskObject]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(tasks, nil);
            });
        }
    }];
}

- (void)deleteFromDB:(id)object :(errorCompletionBlock)completionBlock {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskCoreData"];
    request.predicate = [NSPredicate predicateWithFormat:@"sid == %@", [object sid]];
    NSManagedObjectContext *moc = [CoreDataManager.sharedInstance context];
    NSError *error = nil;
    TaskCoreData *taskCD = [moc executeFetchRequest:request error:&error].firstObject;
    [CoreDataManager.sharedInstance deleteItem:taskCD completion:^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

- (void)updateInDB:(id)object :(errorCompletionBlock)completionBlock {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskCoreData"];
    Task *task;
    if ([object isKindOfClass:[Task class]]) {
        task = object;
        request.predicate = [NSPredicate predicateWithFormat:@"sid == %@", [object sid]];
    }
    NSManagedObjectContext *moc = [CoreDataManager.sharedInstance context];
    NSError *error = nil;
    TaskCoreData *taskCD = [moc executeFetchRequest:request error:&error].firstObject;
    [task mapToCoreData:taskCD];
    [CoreDataManager.sharedInstance saveItems:^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

- (void)createInDB:(id)object :(errorCompletionBlock)completionBlock {
    TaskCoreData *taskCD = [[TaskCoreData alloc] initWithContext:[CoreDataManager.sharedInstance context]];
    if ([object isKindOfClass:[Task class]]) {
        [object mapToCoreData:taskCD];
    }
    [CoreDataManager.sharedInstance saveItems:^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

- (void)deleteEntitiesFromDB:(errorCompletionBlock)completionBlock {
    [CoreDataManager.sharedInstance resetAllRecords:@"TaskCoreData" completion:^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

@end
