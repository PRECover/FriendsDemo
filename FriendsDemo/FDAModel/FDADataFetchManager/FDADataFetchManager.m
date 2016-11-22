//
//  FDADataFetchManager.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDADataFetchManager.h"
#import <AFNetworking/AFNetworking.h>

//url https://randomuser.me/api?results=20


@implementation FDADataFetchManager

- (AFURLSessionManager* ) p_urlSessionManagerWithSerializer: (AFHTTPResponseSerializer*)serializer {
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    manager.responseSerializer = serializer;
    
    return manager;
}

- (void) fetchUsersFromRemoteWithCompletion:(FDAFriendsFetchCompletion)completion {
    AFURLSessionManager *manager = [self p_urlSessionManagerWithSerializer:[AFJSONResponseSerializer serializer]];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:@"https://randomuser.me/api"
                                                                         parameters:@{@"results":@20}
                                                                              error:nil];
    
    NSURLSessionTask *fetchingTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                
                                                    if([responseObject[@"results"] isKindOfClass:[NSArray class]]){
                                                        completion(responseObject[@"results"]);
                                                    }
                                                    
                                                }];
    [fetchingTask resume];
    
}

- (void) downloadUserPhotoFromURL:(NSString*)photoURLstring withCompletion:(FDAImageDownloadingCompletion)completion{
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"src/jpg"];
    AFURLSessionManager *manager = [self p_urlSessionManagerWithSerializer:serializer];
   
    NSURL *photoURL = [NSURL URLWithString:photoURLstring];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
    
    NSURLSessionDataTask *imageDataDownloading = [manager dataTaskWithRequest:request
                                                            completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                                                                if([responseObject isKindOfClass:[NSData class]]){
                                                                    completion(responseObject);
                                                                }
                                                                
                                                            }];
    [imageDataDownloading resume];
    
}


@end

