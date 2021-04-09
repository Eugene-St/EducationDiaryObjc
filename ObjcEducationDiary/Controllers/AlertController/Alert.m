//
//  Alert.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 02.04.2021.
//

#import "Alert.h"

@implementation Alert

+ (void)errorAlert:(NSError *)error {
    NSString *newMessage = [NSString stringWithFormat:@"We cannot proceed%@", error];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:newMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:okAction];
    UIViewController *rootViewController = UIApplication.sharedApplication.windows.firstObject.rootViewController;
    UINavigationController *navigationController;
    UITabBarController *tabBarController;
    if ([rootViewController isKindOfClass:[navigationController class]]) {
        rootViewController = navigationController.viewControllers.firstObject;
    }
    if ([rootViewController isKindOfClass:[tabBarController class]]) {
        rootViewController = tabBarController.selectedViewController;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [rootViewController presentViewController:ac animated:YES completion:nil];
    });
}
@end
