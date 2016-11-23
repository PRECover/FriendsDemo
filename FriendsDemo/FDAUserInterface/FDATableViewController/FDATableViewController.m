//
//  FDATableViewController.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 21/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDATableViewController.h"
#import "FDAEditViewController.h"
#import "FDATableViewSavedRecordsModel.h"
#import "FDATableFetchModel.h"

@interface FDATableViewController () <FDATableViewSavedRecordsModelDelegate>

@property (nonatomic, weak, readwrite) IBOutlet UITableView *usersTable;
@property (nonatomic, strong) FDATableControllerAbstractModel* model;

@property (nonatomic, strong) FDAFriend* friendForEditing;

@end

@implementation FDATableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _type = FDATableControllerSavedType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupTableView];
    [self.model loadData];

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.model loadData];
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.model saveBeforeDissapearing];
}

- (void) setupTableView {
    self.usersTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.usersTable.separatorColor = [UIColor whiteColor];
    
    self.usersTable.backgroundColor = [UIColor colorWithRed:0.518 green:0.016 blue:0.314 alpha:1.00];
}

- (void) setupNavigationBar {
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemAction:)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
}

#pragma mark Logic setups

- (void) setupData {
    switch (self.type) {
        case FDATableControllerSearcType:{
            self.model = [[FDATableFetchModel alloc] initWithTableView:self.usersTable];
            self.title = @"Searching";
            
            break;
        }
        
        case FDATableControllerSavedType:{
            FDATableViewSavedRecordsModel* model = [[FDATableViewSavedRecordsModel alloc] initWithTableView:self.usersTable];
            model.delegate = self;
            self.model = model;
            self.title = @"Friends";
            [self setupNavigationBar];
            
            break;
        }
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchItemAction:(UIBarButtonItem*)sender {
    FDATableViewController* friendSearchTable = [self.storyboard instantiateViewControllerWithIdentifier:@"FDATableViewController"];
    friendSearchTable.type = FDATableControllerSearcType;
    
    [self.navigationController pushViewController:friendSearchTable animated:YES];
    
}

#pragma mark FDATableViewSavedRecordsModelDelegate protocol implementation

- (void) FDA_friendDidSelected:(FDAFriend *)friendForEditing{
    self.friendForEditing = friendForEditing;
    [self performSegueWithIdentifier:@"showFriendDetail" sender:self];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[FDAEditViewController class]]){
        FDAEditViewController *editViewController = segue.destinationViewController;
        editViewController.friendForEditing = self.friendForEditing;
        self.friendForEditing = nil;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
