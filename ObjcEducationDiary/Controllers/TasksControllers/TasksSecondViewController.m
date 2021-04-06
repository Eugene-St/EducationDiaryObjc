//
//  TasksSecondViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 02.04.2021.
//

#import "TasksSecondViewController.h"
#import "Task.h"
#import "TasksMediator.h"
#import "Alert.h"
#import "ControllerDelegate.h"

@interface TasksSecondViewController ()
@property (strong, nonatomic) TasksMediator *mediator;
//@property (nonatomic, weak) id <TaskViewControllerDelegate> delegate;
@end

@implementation TasksSecondViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mediator = TasksMediator.new;
//    _saveButton.enabled = NO;
    [self loadData];
//    [_descriptionTextField becomeFirstResponder];
}

- (IBAction)progressSliderPressed:(UISlider *)sender {
    _progressSlider.value = sender.value;
    _progressLabel.text = [@(ceil(sender.value)) stringValue];
    
    if ((_task) && ([_descriptionTextField hasText])) {
        _saveButton.enabled = YES;
    }
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (!_task) {
        [self createNewTask];
    } else {
        [self updateTask];
    }
}

- (void)createNewTask {
    Task *task = Task.new;
    NSNumber *timeStamp = [NSNumber numberWithInt:NSDate.timeIntervalSinceReferenceDate];
    task.progress = @(ceil(_progressSlider.value));
    task.createdOn = timeStamp;
    task.sid = [NSString stringWithFormat: @"%@", timeStamp];
    task.taskDescription = _descriptionTextField.text;
    
    [_mediator createNewData:task :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"created");
            [self.delegate saveData:task];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)updateTask {
    Task *task = Task.new;
    task.createdOn = _task.createdOn;
    task.taskDescription = _descriptionTextField.text;
    task.sid = _task.sid;
    task.progress = @(ceil(_progressSlider.value));
    
    [_mediator createNewData:task :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"updated");
            NSLog(@"passed data : task %@", task.taskDescription);
            NSLog(@"passed data : sid %@", task.sid);
            [self.delegate saveData:task];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)loadData {
    if (_task) {
        _descriptionTextField.text = _task.taskDescription;
        _progressSlider.value = [_task.progress floatValue];
        _progressLabel.text = [_task.progress stringValue];
    } else {
        _progressSlider.value = 0;
        _progressLabel.text = @"0";
    }
}

@end
