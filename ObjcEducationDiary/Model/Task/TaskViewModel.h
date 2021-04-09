//
//  TaskViewModel.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import <UIKit/UIKit.h>

@class Task;

NS_ASSUME_NONNULL_BEGIN

@interface TaskViewModel : NSObject

@property (nonatomic, strong) Task *task;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;
@property (nonatomic, strong) UIColor *color;

- (id)initWithTask:(Task*)task;

@end

NS_ASSUME_NONNULL_END
