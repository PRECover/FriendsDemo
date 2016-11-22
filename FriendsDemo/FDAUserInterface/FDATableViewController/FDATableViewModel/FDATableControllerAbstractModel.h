//
//  FDATableControllerAbstractModel.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 22/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FDATableControllerAbstractModel : NSObject <UITableViewDataSource, UITableViewDelegate>

- (instancetype) initWithTableView:(UITableView*)tableView;
- (void) loadData;
- (void) saveBeforeDissapearing;

@end
