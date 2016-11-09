//
//  FDAFriend+CoreDataProperties.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDAFriend+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FDAFriend (CoreDataProperties)

+ (NSFetchRequest<FDAFriend *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *eMail;
@property (nullable, nonatomic, retain) NSData *photo;
@property (nonatomic) BOOL isFriend;

@end

NS_ASSUME_NONNULL_END
