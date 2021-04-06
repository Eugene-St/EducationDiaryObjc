//
//  BookmarksViewController.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 22.03.2021.
//

#import "BookmarksViewController.h"
#import "Bookmark.h"
#import "Alert.h"
#import "BookmarksMediator.h"

@interface BookmarksViewController ()
@property (strong, nonatomic) NSMutableArray<Bookmark *> *bookmarks;
@property (strong, nonatomic) BookmarksMediator *mediator;
@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    UILongPressGestureRecognizer *longGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressed:)];
    [self.tableView addGestureRecognizer:longGestureRecognizer];
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
            }
        }];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// IBActions
- (void)addButtonPressed:(UIBarButtonItem *)sender {
    [self showAlert:@"Add bookmark" :@"Please enter Bookmark name and text" :nil];
}

// alert
- (void)showAlert: (NSString *)title :(NSString *)message :(Bookmark * _Nullable)bookmark {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (bookmark) {
            [self updateBookmark:bookmark :ac];
        } else {
            [self createNewBookmark:ac];
        }
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull nameTextField) {
        nameTextField.keyboardType = UIKeyboardTypeAlphabet;
        nameTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        nameTextField.placeholder = @"name - optional";
        nameTextField.text = bookmark.name;
        
        if (bookmark) {
            [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:nameTextField queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
                
                NSUInteger textCount = [[nameTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]length];
                BOOL textIsNotEmpty = textCount > 0;
                okAction.enabled = textIsNotEmpty;
                
            }];
        }
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textTextField) {
        textTextField.keyboardType = UIKeyboardTypeAlphabet;
        textTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textTextField.placeholder = @"text - required";
        textTextField.text = bookmark.text;
        
        [NSNotificationCenter.defaultCenter addObserverForName:UITextFieldTextDidChangeNotification object:textTextField queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
            
            NSUInteger textCount = [[textTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet]length];
            BOOL textIsNotEmpty = textCount > 0;
            okAction.enabled = textIsNotEmpty;
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:cancelAction];
    okAction.enabled = NO;
    [ac addAction:okAction];
    [self presentViewController:ac animated:YES completion:nil];
}

// long press gesture recognize
- (void)longPressed: (UILongPressGestureRecognizer*) sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [sender locationInView:self.tableView];
        
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPoint];
        
        if (indexPath) {
            Bookmark *bookmark = _bookmarks[indexPath.row];
            [self showAlert:@"Edit bookmark" :@"You may edit the bookmark" :bookmark];
        }
    }
}

// create new bookmark
- (void)createNewBookmark: (UIAlertController *)ac {
    
    Bookmark *bookmark = Bookmark.new;
    bookmark.name = ac.textFields.firstObject.text;
    bookmark.text = ac.textFields.lastObject.text;
    NSNumber *timeStamp = [NSNumber numberWithInt:NSDate.timeIntervalSinceReferenceDate];
    bookmark.sid = [NSString stringWithFormat: @"%@", timeStamp];
    
    __weak typeof(self) weakSelf = self;
    [_mediator createNewData:bookmark :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
        } else {
            [weakSelf.bookmarks insertObject:bookmark atIndex:0];
            [weakSelf.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void)updateBookmark:(Bookmark *)bookmark :(UIAlertController *)ac {
    Bookmark *newBookmark = Bookmark.new;
    newBookmark.name = ac.textFields.firstObject.text;
    newBookmark.text = ac.textFields.lastObject.text;
    newBookmark.sid = bookmark.sid;
    
    __weak typeof(self) weakSelf = self;
    [_mediator updateData:newBookmark :^(id _Nonnull response, NSError * _Nonnull error) {
        if (error) {
            [Alert errorAlert:error];
        } else {
            NSUInteger newIndex = [weakSelf.bookmarks indexOfObject:bookmark];
            weakSelf.bookmarks[newIndex] = newBookmark;
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

// load data
- (void)loadData {
    _mediator = BookmarksMediator.new;
    self.bookmarks = NSMutableArray.new;
    
    __weak typeof(self) weakSelf = self;
    [_mediator fetchData:^(id  _Nonnull object, NSError * _Nonnull err) {
        if (err) {
            [Alert errorAlert:err];
        } else {
            for ( NSString *key in [object allKeys]) {
                Bookmark *bookmark = Bookmark.new;
                bookmark = [bookmark initWithDictionary:object[key]];
                [weakSelf.bookmarks addObject:bookmark];
            }
            
            [weakSelf.tableView reloadData];
        }
    }];
}

@end
