//
//  FDATableViewCell.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 21/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDATableViewCell.h"

@implementation FDATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.name.textColor = [UIColor whiteColor];

    // Initialization code
}

-(void)layoutIfNeeded {
    [super layoutIfNeeded];
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.height / 2;
    self.userPhoto.clipsToBounds = YES;
    self.userPhoto.layer.borderWidth = 3;
    self.userPhoto.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
