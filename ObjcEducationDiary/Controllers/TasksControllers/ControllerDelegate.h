//
//  ControllerDelegate.h
//  ObjcEducationDiary
//
//  Created by Eugene St on 05.04.2021.
//

#ifndef ControllerDelegate_h
#define ControllerDelegate_h
#import "Task.h"


#endif /* ControllerDelegate_h */

@protocol TaskViewControllerDelegate <NSObject>
- (void)saveData:(Task *)task;
@end
