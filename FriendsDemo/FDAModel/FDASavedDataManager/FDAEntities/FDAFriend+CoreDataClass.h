//
//  FDAFriend+CoreDataClass.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDAFriend : NSManagedObject

- (FDAFriend*) FDA_initWithContext:(NSManagedObjectContext*)context;

@end

NS_ASSUME_NONNULL_END

#import "FDAFriend+CoreDataProperties.h"
