//
//  ControllerDelegate.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 05.04.2021.
//

#ifndef TaskViewControllerDelegate_h
#define TaskViewControllerDelegate_h
#import "Task.h"


#endif /* ControllerDelegate_h */

@protocol TaskViewControllerDelegate <NSObject>

- (void)onTaskUpdated:(Task *)task;

@end
