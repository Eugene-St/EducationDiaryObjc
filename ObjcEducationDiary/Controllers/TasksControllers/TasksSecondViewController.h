//
//  TasksSecondViewController.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 02.04.2021.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksSecondViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) id <TaskViewControllerDelegate> delegate;
@property (nonatomic, strong) Task *task;

@end

NS_ASSUME_NONNULL_END
