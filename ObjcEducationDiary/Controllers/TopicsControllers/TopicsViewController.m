//
//  TopicsViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 30.03.2021.
//

#import "TopicsViewController.h"
#import "Alert.h"
#import "ObjcEducationDiary-Swift.h"

@interface TopicsViewController ()

@property (strong, nonatomic) NSMutableArray<Topic *> *topic;
@property (strong, nonatomic) NSMutableArray<TopicViewModel *> *topicViewModels;
@property (strong, nonatomic) TopicsMediator *mediator;

@end

@implementation TopicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mediator = TopicsMediator.new;
    self.topicViewModels = NSMutableArray.new;
    [self loadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topicViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"topicCell" forIndexPath:indexPath];
    TopicViewModel *model = _topicViewModels[indexPath.row];
    [cell configureWithTopicModel:model];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TopicViewModel *model = _topicViewModels[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        [_mediator deleteData:model.topic :^(id _Nonnull result, NSError * _Nonnull error) {
            if (error) {
                [Alert errorAlert:error];
            }
            else {
                [weakSelf.topicViewModels removeObjectAtIndex:indexPath.row];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"TopicDetails" sender:indexPath];
}

#pragma mark - Private methods
- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [_mediator fetchData:^(id  _Nonnull topics, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
        }
        else {
            for (Topic *topic in topics) {
                TopicViewModel *model = [[TopicViewModel alloc] initWithTopic:topic key:topic.sid];
                [weakSelf.topicViewModels addObject:model];
            }
            [weakSelf.tableView reloadData];
        }
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
