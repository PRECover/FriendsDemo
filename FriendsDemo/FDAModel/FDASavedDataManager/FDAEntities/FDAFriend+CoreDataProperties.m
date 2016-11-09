//
//  FDAFriend+CoreDataProperties.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDAFriend+CoreDataProperties.h"

@implementation FDAFriend (CoreDataProperties)

+ (NSFetchRequest<FDAFriend *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FDAFriend"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic phone;
@dynamic eMail;
@dynamic photo;
@dynamic isFriend;

@end
