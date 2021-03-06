//
//  FDASavedDataManager.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSFetchedResultsController.h>

@class FDAFriend;
@class NSManagedObjectContext;

@interface FDASavedDataManager : NSObject

+ (FDASavedDataManager*) sharedInstance;

- (NSManagedObjectContext*) backgroundContext;
- (void) saveMainContext;

@end


@interface FDASavedDataManager (FriendsDataManagment)

- (BOOL) insertNewFriendWithFirstName:(NSString*)firstName
                             lastName:(NSString*)lastName
                                eMail:(NSString*)mail
                          phoneNumber:(NSString*)phone
                             andPhoto:(NSData*)photoBinary;

- (BOOL) deleteFriend:(FDAFriend*)friendForDeleting;
- (NSFetchedResultsController*)savedFriendsController;
- (NSFetchRequest*) friendsFetchRequest;

@end
