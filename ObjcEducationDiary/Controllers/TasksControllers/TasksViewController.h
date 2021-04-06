//
//  TasksViewController.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import <UIKit/UIKit.h>
#import "ControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksViewController : UITableViewController <UIPopoverPresentationControllerDelegate, TaskViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
- (IBAction)addButtonPressed:(UIBarButtonItem *)sender;

@end

NS_ASSUME_NONNULL_END
