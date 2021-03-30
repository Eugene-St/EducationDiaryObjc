//
//  BookmarksMediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 29.03.2021.
//

#import "BookmarksMediator.h"

@implementation BookmarksMediator

- (instancetype)init {
    if ((self = [super init])) {
        self.pathForFetch = @"bookmarks.json";
        self.pathForUpdate = @"bookmarks/";
    }
    return self;
}

@end
