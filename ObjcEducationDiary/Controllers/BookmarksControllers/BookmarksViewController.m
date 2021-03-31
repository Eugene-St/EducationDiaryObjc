//
//  BookmarksViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 22.03.2021.
//

#import "BookmarksViewController.h"
#import "Bookmark.h"
#import "BookmarksMediator.h"

@interface BookmarksViewController ()

@property (strong, nonatomic) NSMutableArray<Bookmark *> *bookmarks;
@property (strong, nonatomic) BookmarksMediator *mediator;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
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

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        Bookmark* bookmark = _bookmarks[indexPath.row];
        
        [_mediator deleteData:bookmark :^(id _Nonnull result, NSError * _Nonnull error) {
            
            if (error == nil) {
                [self.bookmarks removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                NSLog(@"removed");
            }
        }];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// IBActions
- (void)addButtonPressed:(UIBarButtonItem *)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Add bookmark" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Ok pressed");

        
        [self createNewData:ac];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel pressed");
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textTextField) {
        textTextField.keyboardType = UIKeyboardTypeAlphabet;
        textTextField.placeholder = @"text - required";
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull nameTextField) {
        nameTextField.keyboardType = UIKeyboardTypeAlphabet;
        nameTextField.placeholder = @"name - optional";
    }];
    
    [ac addAction:cancelAction];
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)createNewData: (UIAlertController *)alertController {
    
    Bookmark *bookmark = Bookmark.new;
    
    bookmark.name = alertController.textFields.firstObject.text;
    bookmark.text = alertController.textFields.lastObject.text;
    NSNumber *timeStamp = [NSNumber numberWithInt:NSDate.timeIntervalSinceReferenceDate];
    bookmark.sid = [NSString stringWithFormat: @"%@", timeStamp];
    
    [_mediator createNewData:bookmark :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error == nil) {
            [_bookmarks insertObject:bookmark atIndex:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void)loadData {
    _mediator = BookmarksMediator.new;
    self.bookmarks = NSMutableArray.new;
    
    [_mediator fetchData:^(id  _Nonnull object, NSError * _Nonnull err) {
        
        for ( NSString *key in [object allKeys]) {
            Bookmark *bookmark = Bookmark.new;
            bookmark = [bookmark initWithDictionary:object :key];
            [self.bookmarks addObject:bookmark];
            
            NSLog(@"name %@", bookmark.name);
            NSLog(@"id %@", bookmark.sid);
            NSLog(@"text %@", bookmark.text);
        }
        
        [self.tableView reloadData];
    }];
}

@end