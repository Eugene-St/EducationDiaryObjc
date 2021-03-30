//
//  BookmarksViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 22.03.2021.
//

#import "BookmarksViewController.h"
#import "Bookmark.h"
#import "Mediator.h"
#import "BookmarksMediator.h"

#import "NetworkManager.h"

@interface BookmarksViewController ()

@property (strong, nonatomic) NSMutableArray<Bookmark *> *bookmarks;
@property (strong, nonatomic) BookmarksMediator *mediator;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData {
    _mediator = BookmarksMediator.new;
    self.bookmarks = NSMutableArray.new;
    
    [_mediator fetchData:^(id  _Nonnull object, NSError * _Nonnull err) {
        
        for ( NSString *key in [object allKeys]) {
            Bookmark *bookmark = Bookmark.new;
            bookmark = [bookmark initWithDictionary:object :key];
            [self.bookmarks addObject:bookmark];
        }
        
        [self.tableView reloadData];
    }];
}

// private methods

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookmarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"bookmarkCell" forIndexPath:indexPath];
    
    Bookmark *bookmark = self.bookmarks[indexPath.row];
    
    cell.textLabel.text = bookmark.name;
    cell.detailTextLabel.text = bookmark.text;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"Deleted row");
        
        
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
