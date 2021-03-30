//
//  TasksMediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "TasksMediator.h"

@implementation TasksMediator

- (instancetype)init {
    if ((self = [super init])) {
        self.pathForFetch = @"tasks.json";
        self.pathForUpdate = @"tasks/";
    }
    return self;
}

@end
