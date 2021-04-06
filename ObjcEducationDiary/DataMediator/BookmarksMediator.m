//
//  BookmarksMediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 29.03.2021.
//

#import "BookmarksMediator.h"
#import "Bookmark.h"

@implementation BookmarksMediator

- (instancetype)init {
    if ((self = [super init])) {
        self.path = @"bookmarks";
        self.modelClass = [Bookmark class];
    }
    return self;
}

@end
