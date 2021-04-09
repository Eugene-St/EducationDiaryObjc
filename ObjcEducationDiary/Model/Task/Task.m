//
//  Task.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "Task.h"

@implementation Task

- (id)initWithDictionary:(NSDictionary*) jsonObject {
    self = [super init];
    if (self) {
        NSNumber *createdOn = jsonObject[@"createdOn"];
        if (createdOn && [createdOn isKindOfClass:NSNumber.class]) {
            self.createdOn = createdOn;
        }
        NSString *taskDescription = jsonObject[@"description"];
        if (taskDescription && [taskDescription isKindOfClass:NSString.class]) {
            self.taskDescription = taskDescription;
        }
        NSString *sid = jsonObject[@"id"];
        if (sid && [sid isKindOfClass:NSString.class]) {
            self.sid = sid;
        }
        NSNumber *progress = jsonObject[@"progress"];
        if (progress && [progress isKindOfClass:NSNumber.class]) {
            self.progress = progress;
        }
    }
    
    return self;
}

- (id)initWithCD:(TaskCoreData *)taskCD {
    self = [super init];
    if (!self) return nil;
    _sid = taskCD.sid;
    _progress = [NSNumber numberWithInt:taskCD.progress];
    _taskDescription = taskCD.taskDescription;
    _createdOn = [NSNumber numberWithInt:taskCD.createdOn];
    
    return self;
}

- (NSData *)mapJSONToDataWithError:(NSError *__autoreleasing *)error {
    NSMutableDictionary *task = NSMutableDictionary.new;
    if (_createdOn) {
        task[@"createdOn"] = _createdOn;
    }
    if (_taskDescription) {
        task[@"description"] = _taskDescription;
    }
    if (_sid) {
        task[@"id"] = _sid;
    }
    if (_progress) {
        task[@"progress"] = _progress;
    }
    if ([NSJSONSerialization isValidJSONObject:task]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:task
                                                           options:0
                                                             error:error];
        return jsonData;
    }
    else {
        *error = [NSError errorWithDomain:@"Failed to serialize model" code:100 userInfo:nil];
    }
    
    return nil;
}

- (void)mapToCoreData:(TaskCoreData *)taskCD {
    taskCD.createdOn = [_createdOn intValue];
    taskCD.progress = [_progress intValue];
    taskCD.sid = _sid;
    taskCD.taskDescription = _taskDescription;
}

@end
