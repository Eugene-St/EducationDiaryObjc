//
//  Task.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "Task.h"

@implementation Task

- (NSString *)sid {
    return self.identifier;
}

- (id)initWithDictionary:(NSDictionary*) jsonObject :(NSString*) key {
    
    self = [super init];
    if (self) {
            NSNumber *createdOn = jsonObject[key][@"createdOn"];
            NSString *taskDescription = jsonObject[key][@"description"];
            NSString *identifier = jsonObject[key][@"id"];
            NSNumber *progress = jsonObject[key][@"progress"];
        self.createdOn = createdOn;
        self.progress = progress;
        self.identifier = identifier;
        self.taskDescription = taskDescription;
    }
    return self;
}

@end
