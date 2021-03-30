//
//  TaskViewModel.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "TaskViewModel.h"

@class Task;

@implementation TaskViewModel

- (id)initWithTask:(Task*) task :(NSString*) key {
    
    self = [super init];
    if (self) {
        self.task = task;
        self.key = key;
    }
    return self;
}

@end
