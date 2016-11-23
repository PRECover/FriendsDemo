//
//  FDAEditViewController.m
//  FriendsDemo
//
//  Created by Sergey Dokukin on 21/11/2016.
//  Copyright © 2016 CuriousIT LLC. All rights reserved.
//

#import "FDAEditViewController.h"
#import "FDASavedDataManager.h"
#import "FDAFriend+CoreDataProperties.h"

@interface FDAEditViewController ()
<
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate
>

@property (nonatomic, weak) IBOutlet UIImageView *userPhotoImage;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *mailTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *photPlaceholder;

@property (nonatomic, weak) UITextField *activeTextField;

@end

@implementation FDAEditViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    [self setupNavigationBar];
    [self setupViews];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupViews {
    [self.view layoutIfNeeded];
    [self p_setupData];
    [self setupTextFields];
    [self setupContentViews];
    [self setupImageView];
    
}

- (void) setupContentViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed:0.518 green:0.016 blue:0.314 alpha:1.00];
    self.contentView.layer.cornerRadius = 18;
    self.contentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:viewTap];
}

- (void) setupImageView {
    self.userPhotoImage.layer.cornerRadius = self.userPhotoImage.frame.size.height / 2;
    self.userPhotoImage.clipsToBounds = YES;
    self.userPhotoImage.layer.borderWidth = 3;
    self.userPhotoImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.photPlaceholder.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(p_userPhotoTapAction:)];

    [self.photPlaceholder addGestureRecognizer:photoTap];

}

- (void) setupTextFields {
    self.firstNameTextField.keyboardType = UIKeyboardTypeDefault;
    self.lastNameTextField.keyboardType = UIKeyboardTypeDefault;
    self.phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    self.mailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.mailTextField.delegate =self;

}

- (void) setupNavigationBar {
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                               target:self
                                                                               action:@selector(p_editFriendRecord:)];
  
    self.navigationItem.rightBarButtonItem = editItem;
    
}

- (void) p_setupData {
    self.title = @"Details";
    self.userPhotoImage.image = [UIImage imageWithData:self.friendForEditing.photo];
    self.firstNameTextField.text = [self.friendForEditing.firstName capitalizedString];
    self.lastNameTextField.text = [self.friendForEditing.lastName capitalizedString];
    self.phoneTextField.text = self.friendForEditing.phone;
    self.mailTextField.text = self.friendForEditing.eMail;
    
}



- (BOOL) p_isRecordChanged {
    BOOL isChanged = NO;
   
    if(![self.firstNameTextField.text isEqualToString:self.friendForEditing.firstName]) { isChanged = YES; }
    if(![self.lastNameTextField.text isEqualToString:self.friendForEditing.lastName]) { isChanged = YES; }
    if(![self.phoneTextField.text isEqualToString:self.friendForEditing.phone]) { isChanged = YES; }
    if(![self.mailTextField.text isEqualToString:self.friendForEditing.eMail]) { isChanged = YES; }
   
    NSData* imageData = UIImagePNGRepresentation(self.userPhotoImage.image);
    if(![imageData isEqual:self.friendForEditing.photo]) { isChanged = YES; }
    
    return isChanged;
    
}

- (void) p_userPhotoTapAction:(UIImageView*)sender{
    UIImagePickerController *photoLibrayController = [[UIImagePickerController alloc] init];
    photoLibrayController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoLibrayController.delegate = self;
    [self presentViewController:photoLibrayController animated:YES completion:nil];
    
}

- (void) p_editFriendRecord:(UIBarButtonItem*)sender {
    if ([self p_isRecordChanged]) {
        self.friendForEditing.firstName = self.firstNameTextField.text;
        self.friendForEditing.lastName = self.lastNameTextField.text;
        self.friendForEditing.phone = self.phoneTextField.text;
        self.friendForEditing.eMail = self.mailTextField.text;
        self.friendForEditing.photo = UIImagePNGRepresentation(self.userPhotoImage.image);
        
        [[FDASavedDataManager sharedInstance] saveMainContext];
    }
    
}

#pragma mark UIImagePickerControllerDelegate protocol implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedPhoto = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.userPhotoImage.image = selectedPhoto;
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark Keyboard handling

- (void) registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets oldContentInsets = self.scrollView.contentInset;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake( oldContentInsets.top,
                                                  oldContentInsets.left,
                                                  kbSize.height,
                                                  oldContentInsets.right );
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint textFieldFakePoint = CGPointMake(_activeTextField.frame.origin.x,
                                             _activeTextField.frame.size.height/2);
    
    if ((!CGRectContainsPoint(aRect, textFieldFakePoint) )||(!CGRectContainsPoint(aRect, _activeTextField.frame.origin))){
        [self.scrollView scrollRectToVisible:_activeTextField.frame animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    _activeTextField = textField;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    _activeTextField = nil;
}


@end
