//
//  Task.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import <Foundation/Foundation.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<Model>

@property (nonatomic, strong) NSNumber *createdOn;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSNumber *progress;
@property (nonatomic, strong) NSString *sid;

@end

NS_ASSUME_NONNULL_END
