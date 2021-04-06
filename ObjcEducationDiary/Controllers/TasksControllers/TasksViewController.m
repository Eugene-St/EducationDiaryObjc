//
//  TasksViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "TasksViewController.h"
#import "Task.h"
#import "Alert.h"
#import "TaskCell.h"
#import "TasksMediator.h"
#import "TaskViewModel.h"
#import "TasksSecondViewController.h"

#pragma mark - Interface
@interface TasksViewController ()

@property (strong, nonatomic) NSMutableArray<Task *> *tasks;
@property (strong, nonatomic) NSMutableArray<TaskViewModel *> *taskViewModels;
@property (strong, nonatomic) TasksMediator *mediator;

@end

#pragma mark - Implementation
@implementation TasksViewController

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    _mediator = TasksMediator.new;
    self.taskViewModels = NSMutableArray.new;
    [self loadData];
    
    UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    [self.tableView addGestureRecognizer:longGestureRecognizer];
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _taskViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    TaskViewModel *model = _taskViewModels[indexPath.row];
    [cell configure:model];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TaskViewModel *model = _taskViewModels[indexPath.row];
        __weak typeof(self) weakSelf = self;
        
        [_mediator deleteData:model.task :^(id _Nonnull result, NSError * _Nonnull error) {
            if (error) {
                [Alert errorAlert:error];
            
            } else {
                [weakSelf.taskViewModels removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    [self presentTasksSecondVCPopOver:_taskViewModels[indexPath.row].task with:indexPath];
}

#pragma mark - IBAction
- (void)addButtonPressed:(UIBarButtonItem *)sender {
    [self presentTasksSecondVCPopOver:nil with:nil];
}

#pragma mark - Private methods
#pragma mark - Load data
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    
    [_mediator fetchData:^(id  _Nonnull tasks, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
        
        } else {
            for (Task *task in tasks) {
                TaskViewModel *model = [[TaskViewModel alloc]initWithTask:task];
                [weakSelf.taskViewModels addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - Pull to refresh
- (void)refreshTable {
    [_taskViewModels removeAllObjects];
    [self loadData];
    [refreshControl endRefreshing];
}

#pragma mark - Long press gesture recognizer
- (void)longPressed: (UILongPressGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
        
        if (indexPath) {
            TaskViewModel *taskModel = _taskViewModels[indexPath.row];
            taskModel.task.progress = @100;
            __weak typeof(self) weakSelf = self;
            
            [_mediator updateData:taskModel.task :^(id _Nonnull response, NSError * _Nonnull error) {
                if (error) {
                    [Alert errorAlert:error];
                
                } else {
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
        }
    }
}

#pragma mark - PopoverVC presentation
- (void)presentTasksSecondVCPopOver:(Task * _Nullable)task with:(NSIndexPath * _Nullable)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TasksSecondViewController *taskSecondVC = [storyboard instantiateViewControllerWithIdentifier:@"tasksPopVC"];
    taskSecondVC.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popController = [taskSecondVC popoverPresentationController];
    taskSecondVC.delegate = self;
    popController.delegate = self;
    
    if (indexPath) {
        popController.sourceView = [self.tableView cellForRowAtIndexPath:indexPath];
        taskSecondVC.task = task;
        [self presentViewController:taskSecondVC animated:YES completion:nil];
    
    } else {
        popController.barButtonItem = self.addButton;
        [self presentViewController:taskSecondVC animated:YES completion:nil];
    }
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}

#pragma mark - Controller delegate
- (void)fetchDataFromSecondVC:(Task *)task {
    NSUInteger newIndex = [_taskViewModels indexOfObjectPassingTest:^BOOL(TaskViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        return (*stop = ([obj.key isEqualToString:task.sid]));
    }];
    
    if (newIndex != NSNotFound) {
        _taskViewModels[newIndex].task = task;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    } else {
        TaskViewModel *newTaskModel = [[TaskViewModel alloc]initWithTask:task];
        [_taskViewModels insertObject:newTaskModel atIndex:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
