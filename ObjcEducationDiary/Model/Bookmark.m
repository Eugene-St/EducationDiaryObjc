//
//  Bookmark.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Bookmark.h"

@implementation Bookmark

- (NSString *)sid {
    return self.identifier;
}

- (id)initWithDictionary:(NSDictionary*) jsonObject :(NSString*) key {
    
    self = [super init];
    if (self) {
            NSString *name = jsonObject[key][@"name"];
            NSString *text = jsonObject[key][@"text"];
            NSString *identifier = jsonObject[key][@"id"];
            self.name = name;
            self.identifier = identifier;
            self.text = text;
    }
    return self;
}

@end
