//
//  Mediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Mediator.h"
#import "NetworkManager.h"

@implementation Mediator

- (id)parseJSON:(NSData *)data {
    NSError *errr;
    
    NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errr];
    
    if (errr) {
        NSLog(@"Failed to serialize into JSON, %@", errr);
        return nil;
    }
    
    return objectJson;
};

- (void)fetchData: (void (^)(id _Nonnull, NSError * _Nonnull))completionBlock {
    
    [NetworkManager getRequest: @"bookmarks.json"
                              :^(NSData * _Nonnull dat, NSError * _Nonnull err) {

        NSData *decodedData = [self parseJSON:dat];
        completionBlock(decodedData, nil);

    }];
}
    
@end


