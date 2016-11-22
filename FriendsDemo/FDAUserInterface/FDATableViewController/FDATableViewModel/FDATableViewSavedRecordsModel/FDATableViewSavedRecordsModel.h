//
//  FDATableViewSavedRecordsModel.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 22/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDATableControllerAbstractModel.h"

@class FDAFriend;

@protocol FDATableViewSavedRecordsModelDelegate <NSObject>

@required - (void) FDA_friendDidSelected:(FDAFriend*)friendForEditing;

@end


@interface FDATableViewSavedRecordsModel : FDATableControllerAbstractModel 

@property (nonatomic, weak) id<FDATableViewSavedRecordsModelDelegate> delegate;

@end
