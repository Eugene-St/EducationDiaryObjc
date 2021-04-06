//
//  TaskCell.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 01.04.2021.
//
#import "TaskCell.h"
#import "Task.h"



@implementation TaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _progressView.backgroundColor = UIColor.greenColor;
    [self addConstraintsToProgressView];
    self.textLabel.numberOfLines = 0;
}

- (void)configure:(TaskViewModel *)taskViewModel {
    
    if ([taskViewModel.task.progress  isEqual: @100]) {
        _progressView.backgroundColor = nil;
        
        NSMutableAttributedString *strikeThrough = [[NSMutableAttributedString alloc] initWithString:taskViewModel.task.taskDescription];
        
        [strikeThrough addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [strikeThrough length])];
        self.textLabel.attributedText = strikeThrough;
        
        taskViewModel.accessoryType = UITableViewCellAccessoryCheckmark;
        taskViewModel.color = [UIColor colorWithRed:70.0/255.0 green:124.0/255.0 blue:36.0/255.0 alpha:1];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        self.tintColor = [UIColor colorWithRed:70.0/255.0 green:124.0/255.0 blue:36.0/255.0 alpha:1];
        
    } else if (taskViewModel.task.progress == nil) {
        _progressView.backgroundColor = nil;
        
        NSMutableAttributedString *regularString = [[NSMutableAttributedString alloc] initWithString:taskViewModel.task.taskDescription];
        
        [regularString addAttribute: UIAccessibilityTextAttributeCustom value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [regularString length])];
        self.textLabel.attributedText = regularString;
        
    } else {
        _progressView.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:124.0/255.0 blue:36.0/255.0 alpha:1];
        
        NSMutableAttributedString *regularString = [[NSMutableAttributedString alloc] initWithString:taskViewModel.task.taskDescription];
        
        [regularString addAttribute: UIAccessibilityTextAttributeCustom value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [regularString length])];
        self.textLabel.attributedText = regularString;
        
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    
    CGFloat multiplier = [taskViewModel.task.progress doubleValue] / 100;
    
    _progressWidth.active = NO;
    _progressWidth = [_progressView.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier:multiplier];
    _progressWidth.active = YES;
    
    [UIView animateWithDuration:1.5 animations:^{
        [self.progressView.superview layoutIfNeeded];
    }];
}

- (void)addConstraintsToProgressView {
    
    _progressView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat initialWidth = 1.0 / 100.0 * self.contentView.bounds.size.width;
    
    CGRect newFrame = self.progressView.frame;
    newFrame.size.width = 0;
    [self.progressView setFrame:newFrame];

    _progressWidth = [_progressView.widthAnchor constraintEqualToConstant:initialWidth];
    _progressWidth.active = YES;
    
    [NSLayoutConstraint activateConstraints:@[
        [_progressView.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor],
        [_progressView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [_progressView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
}

@end
