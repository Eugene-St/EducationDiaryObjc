//
//  Model.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 29.03.2021.
//

#ifndef Model_h
#define Model_h


#endif /* Model_h */

@protocol Model
- (NSString *) sid;
- (id)initWithDictionary:(NSDictionary*) jsonObject : (NSString*) key;
// + 2 метода для маппинга в кор дату

@end
