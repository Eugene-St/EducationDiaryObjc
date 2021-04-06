//
//  TaskCell.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 01.04.2021.
//

#import <UIKit/UIKit.h>
#import "TaskViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskCell : UITableViewCell

@property (nonatomic) NSLayoutConstraint *progressWidth;
@property (weak, nonatomic) IBOutlet UIView *progressView;
- (void)configure:(TaskViewModel *)taskViewModel;

@end

NS_ASSUME_NONNULL_END
