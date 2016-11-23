//
//  FriendsDemoTests.m
//  FriendsDemoTests
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <CoreData/CoreData.h>
#import "FDASavedDataManager.h"
#import "FDAFriend+CoreDataClass.h"

@interface FriendsDemoTests : XCTestCase

@property (strong, nonatomic) NSDictionary* friendData;

@end

@implementation FriendsDemoTests

- (void)setUp {
    [super setUp];

    self.friendData = @{@"firstName":@"Pedro",@"lastName":@"Testio",@"phone":@"+3227261632",@"email":@"testMail@example.com"};
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void) testFriendInserting {
    NSData* testPhotoData = [[NSData alloc] init];
    XCTAssert([[FDASavedDataManager sharedInstance] insertNewFriendWithFirstName:self.friendData[@"firstName"]
                                                                        lastName:self.friendData[@"lastName"]
                                                                           eMail:self.friendData[@"email"]
                                                                     phoneNumber:self.friendData[@"phone"]
                                                                        andPhoto:testPhotoData], @"Data inserting");
  
}

- (void) testFriendFetching {
    NSArray *fetchedFriends = [self fetchFriendsData];
    XCTAssert([fetchedFriends count], @"Fetching filed");
    XCTAssert([fetchedFriends count] > 1, @"Wrong friends count");
    
    
    XCTAssert([[fetchedFriends lastObject] isKindOfClass:[FDAFriend class]], @"Wrong class");
    
}

- (NSArray*) fetchFriendsData {
    NSFetchRequest *fetchRequest = [[FDASavedDataManager sharedInstance] friendsFetchRequest];
    NSManagedObjectContext* context = [[FDASavedDataManager sharedInstance] backgroundContext];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;

}

- (void) testCorrectingInput {
    FDAFriend* testFriend = [[self fetchFriendsData] lastObject];
    BOOL isCorrect = YES;
    
    if (![testFriend.firstName isEqualToString:self.friendData[@"firstName"]]) { isCorrect = NO; }
    if (![testFriend.lastName isEqualToString:self.friendData[@"lastName"]]) { isCorrect = NO; }
    if (![testFriend.phone isEqualToString:self.friendData[@"phone"]]) { isCorrect = NO; }
    if (![testFriend.eMail isEqualToString:self.friendData[@"email"]]) { isCorrect = NO; }
    
    XCTAssert(isCorrect, @"Data correcting");
    
}
- (void) testDataDeleting {
    FDAFriend* testFriend = [[self fetchFriendsData] lastObject];
    XCTAssert([[FDASavedDataManager sharedInstance] deleteFriend:testFriend], @"Friend deleting");
    
}



@end
