//
//  Bookmark.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Bookmark.h"

@implementation Bookmark

- (id)initWithDictionary:(NSDictionary*) jsonObject {
    self = [super init];
    if (self) {
        NSString *name = jsonObject[@"name"];
        if (name && [name isKindOfClass:NSString.class]) {
            self.name = name;
        }
        NSString *text = jsonObject[@"text"];
        if (text && [text isKindOfClass:NSString.class]) {
            self.text = text;
        }
        NSString *sid = jsonObject[@"id"];
        if (sid && [sid isKindOfClass:NSString.class]) {
            self.sid = sid;
        }
    }
    
    return self;
}

- (id)initWithCD:(BookmarkCoreData *)bookmarkCD {
    self = [super init];
    if (!self) return nil;
    _sid = bookmarkCD.sid;
    _name = bookmarkCD.name;
    _text = bookmarkCD.text;
    
    return self;
}

- (NSData * _Nullable)mapJSONToDataWithError:(NSError *__autoreleasing *)error {
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
                                                             error:error];
        return jsonData;
    }
    else {
        *error = [NSError errorWithDomain:@"Failed to serialize model" code:100 userInfo:nil];
    }
    
    return nil;
}

- (void)mapToCoreData:(BookmarkCoreData *)bookmarkCD {
    bookmarkCD.name = _name;
    bookmarkCD.sid = _sid;
    bookmarkCD.text = _text;
}

@end
