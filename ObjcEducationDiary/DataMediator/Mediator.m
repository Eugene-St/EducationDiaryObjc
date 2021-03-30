//
//  Mediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Mediator.h"
#import "NetworkManager.h"

@implementation Mediator

// init
- (instancetype)initWithPathForUpdate:(NSString *)pathForUpdate pathForFetch:(NSString *)pathForFetch {
    self = [super init];
    
    if (self) {
        _pathForUpdate = pathForUpdate;
        _pathForFetch = pathForFetch;
    }
    return self;
}


// parse
- (id)parseJSON:(NSData *)data {
    NSError *errr;
    
    NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errr];
    
    if (errr) {
        NSLog(@"Failed to serialize into JSON, %@", errr);
        return nil;
    }
    
    return objectJson;
};

- (void)fetchData:(void (^)(id _Nonnull, NSError * _Nonnull))completionBlock {
    [self fetchDataFromNetwork:completionBlock];
}

// private Fetch from Network
- (void)fetchDataFromNetwork: (void(^)(id, NSError*))completionBlock {
    [NetworkManager getRequest:_pathForFetch :^(NSData * _Nonnull dat, NSError * _Nonnull err) {
        [self recognizeResult:dat :err :^(NSData *dat, NSError *err) {
            completionBlock(dat,err);
        }];
    }];
}

- (void)recognizeResult: (NSData*)data :(NSError*)error :(void(^)(NSData *dat, NSError *err))completionBlock {
    if (data != nil) {
        
        NSData *decodedData;
        
        if ((decodedData = [self parseJSON:data])) {
            completionBlock(decodedData, nil);
        } else {
            completionBlock(nil, error);
        }
    }
}

// deleteData
- (void)deleteData:(id<Model>)model :(void (^)(id _Nonnull, NSError * _Nonnull))completionBlock {
    [NetworkManager deleteRequest:_pathForUpdate :model.sid :^(id _Nonnull obj, NSError * _Nonnull err) {
        NSLog(@"Hello");
    }];
}

    
@end


