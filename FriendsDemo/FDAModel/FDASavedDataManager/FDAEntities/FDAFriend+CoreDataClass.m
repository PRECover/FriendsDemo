//
//  FDAFriend+CoreDataClass.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDAFriend+CoreDataClass.h"

@implementation FDAFriend

- (FDAFriend*) FDA_initWithContext:(NSManagedObjectContext*)context{
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"FDAFriend" inManagedObjectContext:context];
    
    return [[FDAFriend alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
}

@end
