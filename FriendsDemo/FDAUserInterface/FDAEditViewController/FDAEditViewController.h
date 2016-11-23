//
//  FDAEditViewController.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 21/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FDAFriend;

@interface FDAEditViewController : UIViewController

@property (nonatomic, strong, readwrite) FDAFriend* friendForEditing;

@end
