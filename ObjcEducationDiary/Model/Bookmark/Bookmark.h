//
//  Bookmark.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "BookmarkCoreData+CoreDataClass.h"

//@class Bookmark;

NS_ASSUME_NONNULL_BEGIN

@interface Bookmark : NSObject<Model>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *sid;

- (void)mapToCoreData:(BookmarkCoreData *)bookmarkCD;
- (id)initWithCD:(BookmarkCoreData *)bookmarkCD;

@end

NS_ASSUME_NONNULL_END
