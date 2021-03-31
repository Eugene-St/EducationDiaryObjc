//
//  Bookmark.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Bookmark.h"

@implementation Bookmark

- (id)initWithDictionary:(NSDictionary*) jsonObject :(NSString*) key {
    
    self = [super init];
    if (self) {
        NSString *name = jsonObject[key][@"name"];
        NSString *text = jsonObject[key][@"text"];
        NSString *sid = jsonObject[key][@"id"];
        self.name = name;
        self.text = text;
        self.sid = sid;
    }
    return self;
}

- (NSData *)jsonData {
    
    NSMutableDictionary *bookmark = NSMutableDictionary.new;
    
    if (_name) {
        bookmark[@"name"] = _name;
    }
    
    if (_text) {
        bookmark[@"text"] = _text;
    }
    
    if (_sid) {
        bookmark[@"id"] = _sid;
    }
    
    if ([NSJSONSerialization isValidJSONObject:bookmark]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bookmark
                                                           options:0
                                                             error:nil];
        return jsonData;
    }
    return nil;
}

@end
