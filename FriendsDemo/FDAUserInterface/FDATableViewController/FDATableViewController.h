//
//  FDATableViewController.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 21/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDATableControllerAbstractModel.h"

typedef enum : NSUInteger {
    FDATableControllerSavedType = 0,
    FDATableControllerSearcType
} FDATableViewControllerType;

@interface FDATableViewController : UIViewController

@property (nonatomic, assign) FDATableViewControllerType type;

@end
