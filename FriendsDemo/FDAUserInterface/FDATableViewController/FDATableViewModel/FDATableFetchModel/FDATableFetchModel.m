//
//  FDATableFetchModel.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 22/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDATableFetchModel.h"
#import "FDADataFetchManager.h"
#import "FDASavedDataManager.h"
#import "FDATableViewCell.h"
#import "FDAFriend+CoreDataClass.h"

@interface FDATableFetchModel ()

@property (strong, nonatomic) FDADataFetchManager *fetchManager;

@property (strong, nonatomic) NSMutableArray *loadedRecords;
@property (strong, nonatomic) NSMutableSet *checkedUsers;
@property (nonatomic, weak) UITableView* tableView;

@end

@implementation FDATableFetchModel{
    NSCache *_cache;
}

#pragma mark Abstract model methods owerriding

- (instancetype)initWithTableView:(UITableView*)tableView
{
    self = [self init];
    if (self) {
        _tableView = tableView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [NSCache new];
        _cache.countLimit = 50;
        _cache.totalCostLimit = 100 * 1024 * 1024;
    
        _fetchManager = [FDADataFetchManager new];
        _loadedRecords = [NSMutableArray new];
        _checkedUsers = [NSMutableSet new];
    }
    return self;
}

- (void)loadData {
    [self p_loadDataFromRemote];
    
}

- (void) saveBeforeDissapearing {
    [self p_saveCheckedUserAsFriends];
}


#pragma mark UITableViewDelegate protocol implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL isChecked;
    if([self.checkedUsers containsObject:indexPath]) {
        [self.checkedUsers removeObject:indexPath];
        isChecked = NO;
        
    } else {
        [self.checkedUsers addObject:indexPath];
        isChecked = YES;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    
}

#pragma mark UITableViewDataSource protocol implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [self.loadedRecords count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void) p_loadDataFromRemote {
    [self.fetchManager fetchUsersFromRemoteWithCompletion:^(NSArray *fetchedRecords) {
        [self.loadedRecords addObjectsFromArray:fetchedRecords];
        [self.tableView reloadData];
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FDATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDATableViewCell"];
    if (cell == nil) {
        cell = [FDATableViewCell new];
        
    }
    
    [self p_configureCell:cell atIndexPath:indexPath];
   
    if(indexPath.row == [self.loadedRecords count] - 1) { [self p_loadDataFromRemote]; }
    
    return cell;
}


- (void)p_configureCell:(FDATableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* userData = self.loadedRecords[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.accessoryType = [self.checkedUsers containsObject:indexPath]? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    NSString *firstName = userData[@"name"][@"first"];
    NSString *lastName = userData[@"name"][@"last"];
    
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [firstName capitalizedString], [lastName capitalizedString]];
    
    UIImage* emptyPhoto = [UIImage imageNamed:@"noPhoto"];
    cell.userPhoto.image = emptyPhoto;
    
    [self.fetchManager downloadUserPhotoFromURL:userData[@"picture"][@"medium"] withCompletion:^(NSData *data) {
        
        [_cache setObject:data forKey:userData[@"picture"][@"medium"]];
        UIImage *image = [UIImage imageWithData:data];
        cell.userPhoto.image = image;
        
        
    }];
}

- (NSData*) p_cachedPhotoForURLwithString:(NSString*)urlString andIndexPath:(NSIndexPath*)indexPath {
    NSData *photoData = [_cache objectForKey:urlString];
    if (!photoData) {
        NSDictionary* userData = self.loadedRecords[indexPath.row];
        NSURL *photoURL = [NSURL URLWithString:userData[@"picture"][@"medium"]];
        return [NSData dataWithContentsOfURL:photoURL];
    }
    else {
        return photoData;
    }
}

- (void) p_saveCheckedUserAsFriends {
    for (NSIndexPath *indexPath in self.checkedUsers) {
        NSDictionary* userData = self.loadedRecords[indexPath.row];
        NSData *photo = [self p_cachedPhotoForURLwithString:userData[@"picture"][@"medium"] andIndexPath:indexPath];

        if(![[FDASavedDataManager sharedInstance] insertNewFriendWithFirstName:userData[@"name"][@"first"]
                                                                  lastName:userData[@"name"][@"last"]
                                                                     eMail:userData[@"email"]
                                                               phoneNumber:userData[@"phone"]
                                                                      andPhoto:photo]){
            NSLog(@"user not inserted - %@", userData);
        };
    
    }
    
}


@end
