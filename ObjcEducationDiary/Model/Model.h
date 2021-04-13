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

@property (nonatomic, strong) NSString * _Nullable sid;

- (id _Nullable)initWithDictionary:(NSDictionary * _Nonnull)jsonObject;
- (NSData * _Nullable)mapJSONToDataWithError:(NSError *_Nullable*_Nonnull)error;

@end
