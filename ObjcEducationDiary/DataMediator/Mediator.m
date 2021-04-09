//
//  Mediator.m
//  ObjcEducationDiary
//
//  Created by Eugene St on 26.03.2021.
//

#import "Mediator.h"
#import "NetworkManager.h"
#import "CoreDataManager.h"

#pragma mark - Implementation
@implementation Mediator

- (instancetype)initWithPath:(NSString *)path modelCLass:(Class)modelCLass {
    self = [super init];
    if (self) {
        _path = path;
        _modelClass = modelCLass;
    }
    
    return self;
}

#pragma mark - Parse JSON
- (id)parseJSON:(NSData *)data {
    NSError *errr;
    NSDictionary *objectJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errr];
    NSMutableArray<Model> *objects = [[NSMutableArray<Model> alloc] init];
    for ( NSString *key in [objectJson allKeys]) {
        id modelClass = [[_modelClass alloc] initWithDictionary:objectJson[key]];
        [objects addObject:modelClass];
    }
    if (errr) {
        return nil;
    }
    
    return objects;
};

#pragma mark - Fetch data
- (void)fetchData:(completion)completionBlock {
    if ([NetworkMonitor.sharedInstance isInternetReachable]) {
        [self fetchDataFromNetwork:completionBlock];
    }
    else {
        [self fetchFromDB:completionBlock];
    }
}

- (void)fetchDataFromNetwork: (void(^)(id, NSError*))completionBlock {
    __weak typeof(self) weakSelf = self;
    [NetworkManager getRequest:_path commpletionBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        [weakSelf recognizeResult:data error:error :completionBlock];
    }];
}

- (void)recognizeResult:(NSData*)data error:(NSError*)error :(void(^)(NSData *dat, NSError *err))completionBlock {
    if (error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, error);
        });
    }
    else {
        NSData *decodedData;
        if ((decodedData = [self parseJSON:data])) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(decodedData, nil);
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deleteEntitiesFromDB:^(NSError * _Nonnull error) {
                    completionBlock(nil, error);
                }];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveToDB:decodedData :^(NSError * _Nonnull error) {
                    completionBlock(nil, error);
                }];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
    }
}

#pragma mark - Delete data
- (void)deleteData:(id<Model>)model :(completion)completionBlock {
    [NetworkManager deleteRequest:_path identificator:model.sid commpletionBlock:^(id _Nullable object, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(object, nil);
            });
            [self deleteFromDB:model :^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
            }];
        }
    }];
}

#pragma mark - Create new data
- (void)createNewData:(id<Model>)model :(completion)completionBlock {
    NSError *dataError = nil;
    NSData *data = [model mapJSONToDataWithError:&dataError];
    if (dataError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, dataError);
            return;
        });
    }
    
    [NetworkManager putRequest:_path identificator:model.sid data:data commpletionBlock:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
            [self createInDB:model :^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
            }];
        }
    }];
}

#pragma mark - Update data
- (void)updateData:(id<Model>)model :(completion)completionBlock {
    NSError *dataError = nil;
    NSData *data = [model mapJSONToDataWithError:&dataError];
    if (dataError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(nil, dataError);
            return;
        });
    }
    
    [NetworkManager patchRequest:_path identificator:model.sid data:data commpletionBlock:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, error);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(response, nil);
            });
            [self updateInDB:model :^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, error);
                });
            }];
        }
    }];
}

- (void)saveToDB:(id)objects :(errorCompletionBlock)completionBlock {}
- (void)createInDB:(id)object :(errorCompletionBlock)completionBlock {}
- (void)updateInDB:(id)object :(errorCompletionBlock)completionBlock {}
- (void)fetchFromDB:(completion)completionBlock {}
- (void)deleteFromDB:(id)object :(errorCompletionBlock)completionBlock {}
- (void)deleteEntitiesFromDB:(errorCompletionBlock)completionBlock {}

@end


