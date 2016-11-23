//
//  FDATableViewSavedRecordsModel.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 22/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDATableViewSavedRecordsModel.h"
#import "FDATableViewCell.h"
#import "FDASavedDataManager.h"
#import "FDAFriend+CoreDataProperties.h"

@interface FDATableViewSavedRecordsModel () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* friendsController;
@property (nonatomic, weak) UITableView *tableView;

@end


@implementation FDATableViewSavedRecordsModel

#pragma mark Abstract model methods owerriding

- (instancetype)initWithTableView:(UITableView*)tableView{
    self = [self init];
    if (self){
        _tableView = tableView;
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }

    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _friendsController = [[FDASavedDataManager sharedInstance] savedFriendsController];
        _friendsController.delegate = self;
        
    }
    return self;
}

- (void)loadData {
    NSError *error;
    if(![self.friendsController performFetch:&error]){
        
        NSLog(@"Unresloved error! %@", [error userInfo]);
        abort();
        
    }
}

- (void)saveBeforeDissapearing {
    //empty implementation
    
}

#pragma mark UITableViewDataSource protocol implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friendsController.fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FDATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDATableViewCell"];
    if (cell == nil) {
        cell = [FDATableViewCell new];
        
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (void)configureCell:(FDATableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    FDAFriend *friend = self.friendsController.fetchedObjects[indexPath.row];
    UIImage *photo = [UIImage imageWithData:friend.photo];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text = [NSString stringWithFormat:@"%@ %@", [friend.firstName capitalizedString], [friend.lastName capitalizedString]];
    cell.userPhoto.image = photo;
    
}

#pragma mark UITableViewDelegate protocol implementation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.delegate){
        FDAFriend* friend = self.friendsController.fetchedObjects[indexPath.row];
        [self.delegate FDA_friendDidSelected:friend];
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FDAFriend* friend = self.friendsController.fetchedObjects[indexPath.row];
        [[FDASavedDataManager sharedInstance] deleteFriend:friend];
        
    }
}

#pragma mark NSFetchedResultsControllerDelegate protocol implementation

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];

}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
}



@end
