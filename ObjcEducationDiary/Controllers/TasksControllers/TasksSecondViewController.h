//
//  TasksSecondViewController.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 02.04.2021.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "ControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksSecondViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (strong, nonatomic) Task *task;
@property (nonatomic, weak) id <TaskViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
