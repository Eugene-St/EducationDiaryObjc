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
    if ((self = [super init])) {
        self.path = @"tasks";
        self.modelClass = [Task class];
    }
    return self;
}

@end
