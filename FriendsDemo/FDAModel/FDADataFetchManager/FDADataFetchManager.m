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

- (AFURLSessionManager* ) p_urlSessionManagerWithContentTypes: (NSSet*)contentTypes {
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = contentTypes;
    manager.responseSerializer = serializer;
    
    return manager;
}

- (void) fetchUsersFromRemoteWithCompletion:(FDAFriendsFetchCompletion)completion {
    AFURLSessionManager *manager = [self p_urlSessionManagerWithContentTypes:[NSSet setWithObjects:@"application/json", nil]];
    NSURL *apiURL = [NSURL URLWithString:@"https://randomuser.me/api?results=20"];
    NSURLRequest *request = [NSURLRequest requestWithURL:apiURL];
    
    NSURLSessionTask *fetchingTask = [manager dataTaskWithRequest:request
                                                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                
                                                    if([responseObject isKindOfClass:[NSArray class]]){
                                                        completion(responseObject);
                                                    }
                                                    
                                                }];
    [fetchingTask resume];
    
}

- (void) downloadUserPhotoFromURL:(NSString*)photoURLstring withCompletion:(FDAImageDownloadingCompletion)completion{
    AFURLSessionManager *manager = [self p_urlSessionManagerWithContentTypes:[NSSet setWithObjects:@"src/jpg", nil]];
   
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

