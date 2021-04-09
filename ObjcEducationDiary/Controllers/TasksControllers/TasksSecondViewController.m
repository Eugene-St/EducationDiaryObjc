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

#pragma mark - Interface
@interface TasksSecondViewController ()

#pragma mark - Properties
@property (strong, nonatomic) TasksMediator *mediator;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@end

#pragma mark - Implementation
@implementation TasksSecondViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    _mediator = TasksMediator.new;
    _saveButton.enabled = NO;
    [self loadData];
    [_descriptionTextField becomeFirstResponder];
}

#pragma mark - IBActions
- (IBAction)progressSliderPressed:(UISlider *)sender {
    _progressSlider.value = sender.value;
    _progressLabel.text = [@(ceil(sender.value)) stringValue];
    if ((_task) && (_descriptionTextField.text.length > 0)) {
        _saveButton.enabled = YES;
    }
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (!_task) {
        [self createNewTask];
    }
    else {
        [self updateTask];
    }
}

#pragma mark - Private methods
#pragma mark - Create new task
- (void)createNewTask {
    Task *task = Task.new;
    NSNumber *timeStamp = [NSNumber numberWithInt:NSDate.timeIntervalSinceReferenceDate];
    task.progress = @(ceil(_progressSlider.value));
    task.createdOn = timeStamp;
    task.sid = [NSString stringWithFormat: @"%@", timeStamp];
    task.taskDescription = _descriptionTextField.text;
    __weak typeof(self) weakSelf = self;
    [_mediator createNewData:task :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [weakSelf.delegate fetchDataFromSecondVC:task];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Update task
- (void)updateTask {
    Task *task = Task.new;
    task.createdOn = _task.createdOn;
    task.taskDescription = _descriptionTextField.text;
    task.sid = _task.sid;
    task.progress = @(ceil(_progressSlider.value));
    __weak typeof(self) weakSelf = self;
    [_mediator createNewData:task :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [weakSelf.delegate fetchDataFromSecondVC:task];
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - Load data
- (void)loadData {
    if (_task) {
        _descriptionTextField.text = _task.taskDescription;
        _progressSlider.value = [_task.progress floatValue];
        _progressLabel.text = [_task.progress stringValue];
    }
    else {
        _progressSlider.value = 0;
        _progressLabel.text = @"0";
    }
}

#pragma mark - UITextFieldDelegate methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    if (_task) {
        [self updateTask];
    }
    else {
        [self createNewTask];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 0) {
        _saveButton.enabled = YES;
    }
    else {
        _saveButton.enabled = NO;
    }
    return YES;
}

@end
