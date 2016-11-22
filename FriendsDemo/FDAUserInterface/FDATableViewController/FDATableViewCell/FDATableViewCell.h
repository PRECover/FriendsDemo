//
//  FDATableViewCell.h
//  FriendsDemo
//
//  Created by Sergey Dokukin on 21/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDATableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *userPhoto;
@property (nonatomic, weak) IBOutlet UILabel *name;

@end
