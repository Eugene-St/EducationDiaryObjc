//
//  TasksViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "TasksViewController.h"
#import "Task.h"
#import "TasksMediator.h"
#import "TaskViewModel.h"

@interface TasksViewController ()

@property (strong, nonatomic) NSMutableArray<Task *> *tasks;
@property (strong, nonatomic) NSMutableArray<TaskViewModel *> *taskViewModels;
@property (strong, nonatomic) TasksMediator *mediator;

@end

@implementation TasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _taskViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    TaskViewModel *model = _taskViewModels[indexPath.row];
    cell.textLabel.text = model.task.taskDescription;
    
    return cell;
}

- (void)loadData {
    _mediator = TasksMediator.new;
    self.taskViewModels = NSMutableArray.new;
    
    [_mediator fetchData:^(id  _Nonnull object, NSError * _Nonnull err) {
        
        for ( NSString *key in [object allKeys]) {
            Task *task = Task.new;
            TaskViewModel *model = TaskViewModel.new;
            task = [task initWithDictionary:object :key];
            model = [model initWithTask:task :key];
            [self.taskViewModels addObject:model];
        }
        [self.tableView reloadData];
    }];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        TaskViewModel *model = _taskViewModels[indexPath.row];
        [_mediator deleteData:model.task :^(id _Nonnull result, NSError * _Nonnull error) {
            [self.taskViewModels removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
