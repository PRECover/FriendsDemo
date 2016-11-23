//
//  FDASavedDataManager.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 09/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FDASavedDataManager.h"
#import "FDAFriend+CoreDataClass.h"

@interface FDASavedDataManager()

@property (strong, nonatomic, readwrite) NSManagedObjectContext *mainContext;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *writeContext;
@property (strong, nonatomic, readwrite) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation FDASavedDataManager

#pragma mark Main methods implementation

+ (FDASavedDataManager*) sharedInstance {
    static FDASavedDataManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


/*
 
 For write operations the best solution is the use of temporary concurrency contexts.
 Thus in our main lengthy operation context is frozen, which in turn will prevent freezing interface.
 Once the context is saved, it will notify the parent about changes in the contest (in this case it mainContext).
 
 */

- (NSManagedObjectContext*) backgroundContext{
    NSManagedObjectContext *tmpContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    tmpContext.parentContext = self.mainContext;
    
    return tmpContext;
}

- (void)saveMainContext {
    NSManagedObjectContext *managedObjectContext = self.mainContext;
    if (managedObjectContext != nil) {
        [managedObjectContext performBlock:^{
            NSError *error = nil;
            if(![managedObjectContext save:&error]){
                NSLog(@"Main context cannt saving. Unresloved error.");
                return;
            }
            
            [self p_writeToDisk];
            
        }];
        
    }
    
}

- (void) p_writeToDisk{
    if(_writeContext != nil ){
        [_writeContext performBlock:^{
            NSError *error = nil;
            if([_writeContext hasChanges] && ![_writeContext save:&error]){
                NSLog(@"Unexcepted error");
                abort();
            }
        }];
    }
}

#pragma mark CoreData stack initialization

@synthesize mainContext = _mainContext;
@synthesize writeContext = _writeContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FriendsDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self p_applicationDocumentsDirectory] URLByAppendingPathComponent:@"FriendsDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_mainContext != nil) {
        return _mainContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    _writeContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_writeContext setPersistentStoreCoordinator:coordinator];
    
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainContext setParentContext:_writeContext];
    
    
    return _mainContext;
}

- (NSURL *)p_applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "CUR.iPurse" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

#pragma mark FriendsDataManagment category implementation

@implementation FDASavedDataManager(FriendsDataManagment)

- (BOOL) insertNewFriendWithFirstName:(NSString*)firstName
                             lastName:(NSString*)lastName
                                eMail:(NSString*)mail
                          phoneNumber:(NSString*)phone
                             andPhoto:(NSData*)photoBinary{
    
    NSManagedObjectContext* backgroundContext = [self backgroundContext];
    
    
    [backgroundContext performBlock:^{
        
        
        FDAFriend *newFriend = [[FDAFriend alloc] FDA_initWithContext:backgroundContext];
        
        newFriend.firstName = firstName;
        newFriend.lastName = lastName;
        newFriend.eMail = mail;
        newFriend.phone = phone;
        newFriend.photo = photoBinary;
        newFriend.isFriend = YES;
        
        NSError *savingError;
        if(![backgroundContext save:&savingError]){
            //handle error
            NSLog(@"Saving error. Object %@ was not saved", newFriend);
            abort();
        }
        
        [self saveMainContext];

    }];
    
    return YES;
    
}

- (BOOL) deleteFriend:(FDAFriend*)friendForDeleting{
    NSManagedObjectContext* backgroundContext = [self backgroundContext];
    
    FDAFriend *friend = [backgroundContext objectWithID:friendForDeleting.objectID];
    friend.isFriend = false;
    
    [backgroundContext performBlock:^{
        NSError *savingError;
        if(![backgroundContext save:&savingError]){
            //handle error
            NSLog(@"Editing error. Changes in object %@ was not saved", friend);
            abort();
        }

        [self saveMainContext];
        
    }];
    
    return YES;
}


- (NSFetchRequest*) friendsFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FDAFriend"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"lastName" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %d", @"isFriend", YES];
    [fetchRequest setPredicate:predicate];
    
    return fetchRequest;
}

- (NSFetchedResultsController*)savedFriendsController{
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:[self friendsFetchRequest]
                                        managedObjectContext:self.mainContext sectionNameKeyPath:nil
                                                   cacheName:@"Cache"];
  
    return theFetchedResultsController;
}

@end

