//
//  BookmarksViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 22.03.2021.
//

#import "BookmarksViewController.h"
#import "Bookmark.h"
#import "Mediator.h"

@interface BookmarksViewController ()

@property (strong, nonatomic) NSMutableArray<Bookmark *> *bookmarks;
@property (strong, nonatomic) Mediator *mediator;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

// private methods
-(void)loadData {
    self.bookmarks = NSMutableArray.new;
    _mediator = Mediator.new;
    
    [_mediator fetchData:^(id  _Nonnull object, NSError * _Nonnull err) {
        NSLog(@"Fetched data: %@", object);
        
        for ( NSString *key in [object allKeys]) {
            Bookmark *bookmark = Bookmark.new;
            NSString *name = object[key][@"name"];
            NSString *text = object[key][@"text"];
            NSString *identifier = object[key][@"id"];
            
            bookmark.name = name;
            bookmark.text = text;
            bookmark.identifier = identifier;
            
            [self.bookmarks addObject:bookmark];
        };
        
        self.tableView.reloadData;
        
    }];
}

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
