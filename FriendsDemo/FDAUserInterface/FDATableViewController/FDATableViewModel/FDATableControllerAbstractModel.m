//
//  FDATableControllerAbstractModel.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 22/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDATableControllerAbstractModel.h"

@implementation FDATableControllerAbstractModel

- (instancetype) initWithTableView:(UITableView*)tableView {
    NSAssert(NO, @"Abstract method for owerriding");
    
    return nil;
}

- (void) loadData {
    NSAssert(NO, @"Abstract method for owerriding");
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSAssert(NO, @"Abstract method for owerriding");
   
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSAssert(NO, @"Abstract method for owerriding");
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert(NO, @"Abstract method for owerriding");
   
    return nil;
}

- (void)saveBeforeDissapearing {
    NSAssert(NO, @"Abstract method for owerriding");
    
}


@end
