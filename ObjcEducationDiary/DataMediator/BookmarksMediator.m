//
//  BookmarksMediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 29.03.2021.
//

#import "BookmarksMediator.h"
#import "Bookmark.h"
#import "BookmarkCoreData+CoreDataClass.h"
#import "CoreDataManager.h"

@implementation BookmarksMediator

- (instancetype)init {
    if ((self = [super init])) {
        self.path = @"bookmarks";
        self.modelClass = [Bookmark class];
    }
    return self;
}

- (void)saveToDB:(id)objects :(void(^)(NSError*))completionBlock {
    if ([objects isKindOfClass:[NSMutableArray<Bookmark *> class]]) {
        for (Bookmark *bookmark in objects) {
            BookmarkCoreData *bookmarkCD = [[BookmarkCoreData alloc] initWithContext:[CoreDataManager.sharedInstance context]];
            [bookmark mapToCoreData:bookmarkCD];
        }
        [CoreDataManager.sharedInstance saveItems:^(NSError * _Nullable error) {
            completionBlock(error);
        }];
    }
}

- (void)fetchFromDB:(void (^)(id _Nullable, NSError * _Nullable))completionBlock {
    NSLog(@"fetched from DB");
    [CoreDataManager.sharedInstance fetch:@"BookmarkCoreData" :^(id _Nullable objects, NSError * _Nullable error) {
        if (error) {
            completionBlock(nil, error);
        } else {
            NSMutableArray<Bookmark *> *bookmarks = NSMutableArray.new;
            
            for (BookmarkCoreData *bookmarkObject in objects) {
                [bookmarks addObject:[[Bookmark alloc] initWithCD:bookmarkObject]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(bookmarks, nil);
            });
        }
    }];
}

- (void)deleteFromDB:(id)object :(void (^)(NSError * _Nonnull))completionBlock {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookmarkCoreData"];
    request.predicate = [NSPredicate predicateWithFormat:@"sid == %@", [object sid]];
    
    NSManagedObjectContext *moc = [CoreDataManager.sharedInstance context];
    NSError *error = nil;
    BookmarkCoreData *bookmarkCD = [moc executeFetchRequest:request error:&error].firstObject;
    [CoreDataManager.sharedInstance deleteItem:bookmarkCD :^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

- (void)updateInDB:(id)object :(void (^)(NSError * _Nonnull))completionBlock {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"BookmarkCoreData"];
    Bookmark *bookmark;
    if ([object isKindOfClass:[Bookmark class]]) {
        bookmark = object;
        request.predicate = [NSPredicate predicateWithFormat:@"sid == %@", [object sid]];
    }
    
    NSManagedObjectContext *moc = [CoreDataManager.sharedInstance context];
    NSError *error = nil;
    BookmarkCoreData *bookmarkCD = [moc executeFetchRequest:request error:&error].firstObject;
    [bookmark mapToCoreData:bookmarkCD];
    [CoreDataManager.sharedInstance saveItems:^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

- (void)createInDB:(id)object :(void (^)(NSError * _Nonnull))completionBlock {
    BookmarkCoreData *bookmarkCD = [[BookmarkCoreData alloc] initWithContext:[CoreDataManager.sharedInstance context]];
    
    if ([object isKindOfClass:[Bookmark class]]) {
        [object mapToCoreData:bookmarkCD];
    }
    [CoreDataManager.sharedInstance saveItems:^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

- (void)deleteEntitiesFromDB:(void (^)(NSError * _Nonnull))completionBlock {
    [CoreDataManager.sharedInstance resetAllRecords:@"BookmarkCoreData" :^(NSError * _Nullable error) {
        completionBlock(error);
    }];
}

@end
