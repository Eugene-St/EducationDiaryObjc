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
            NSString *taskDescription = jsonObject[@"description"];
            NSString *sid = jsonObject[@"id"];
            NSNumber *progress = jsonObject[@"progress"];
        self.createdOn = createdOn;
        self.progress = progress;
        self.sid = sid;
        self.taskDescription = taskDescription;
    }
    return self;
}

- (NSData *)jsonData {
    
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
                                                             error:nil];
        return jsonData;
    }
    return nil;
}

@end
