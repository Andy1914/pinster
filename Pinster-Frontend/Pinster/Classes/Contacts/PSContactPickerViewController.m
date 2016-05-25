//
//  ContactPickerViewController.m
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import "PSContactPickerViewController.h"
#import "PSContactDetailViewController.h"
#import "PSNotAContactViewController.h"
#import "PSNotAPinsterUserContactViewController.h"

#import "PSPinModel.h"

#import <AddressBook/AddressBook.h>
#import "PSContact.h"
#import "DoAlertView.h"
#import "PSMyPinsViewController.h"



UIBarButtonItem *barButton;

@interface PSContactPickerViewController ()
{
    UIButton *checkboxButton;
  
    PSContact *user;
    
    PSPinModel *pinModel;
    
    IBOutlet UITextView *textViewMessage;
    
    IBOutlet UIView *viewTapToMessage, *viewShare;
    
    IBOutlet UISwitch *switchAcccessShare;
    
    IBOutlet UILabel *labelShare;
}

- (IBAction) buttonCloseTapMessage:(id)sender;

- (IBAction) buttonOkShare:(id)sender;


@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@property (nonatomic, strong) DoAlertView *alertView;
@property (nonatomic, strong) NSMutableArray *facebookContacts;
@property (nonatomic, strong) NSMutableArray *groupsList, *arrayFriendIds;
@end

//#define kKeyboardHeight 216.0
#define kKeyboardHeight 0.0

@implementation PSContactPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CFErrorRef error;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayFriendIds = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    //    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
    if(self.pinDataDict != nil) {
        //        barButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
        //        barButton.enabled = FALSE;
        
        self.navigationItem.rightBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"done-btn.png" withSelectedImage:@"done-btn.png" alignmentLeft:YES withSelecter:@selector(done:) withTarget:self];
        
        self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"cancel-btn.png" withSelectedImage:@"cancel-btn.png" alignmentLeft:NO withSelecter:@selector(backCLicked) withTarget:self];
    } else {
        self.navigationItem.leftBarButtonItem = [PSUtility getBarButtonWithNormalImage:@"menu.png" withSelectedImage:@"menu.png" alignmentLeft:NO withSelecter:@selector(openRightMenu) withTarget:self];
    }
    
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Contact List"]];
    
    // Fill the rest of the view with the table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 85+64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height-85-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PSContactPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
    [self.view addSubview:self.tableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromGetURL:kGetGroups parmeters:@{kUser_IdKey: [PSUtility getCurrentUserId]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(error == nil) {
            if([(NSArray *)[result objectForKey:KDataKey] count] > 0) {
                if(self.contacts == nil)
                    self.contacts = [NSMutableArray new];
                self.groupsList = [result objectForKey:KDataKey];
                for(NSDictionary *groupData in self.groupsList) {
                    PSContact *contactObj = [[PSContact alloc] init];
                    [contactObj setFirstName:[groupData valueForKey:@"name"]];
                    [contactObj setFullName:[groupData valueForKey:@"name"]];
                    [contactObj setRecordId:[[groupData valueForKey:@"id"] longLongValue]];
//                    [self.arrayFriendIds addObject:[groupData valueForKey:@"id"]];
//                    [contactObj setFriendIds:[groupData valueForKey:@"id"]];
                    [contactObj setIsGroup:YES];
                    [self.contacts addObject:contactObj];
                }
                [self.tableView reloadData];
                
            }
        } else {
            
        }
        [self fetchLocalCOntacts];
    }];
    [switchAcccessShare setOnImage:[UIImage imageNamed:@"green-btn.png"]];
    
    [switchAcccessShare addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - IBActions

- (void)setState:(id)sender
{
    BOOL state = [sender isOn];
    NSString *rez = state == YES ? @"YES" : @"NO";
    
    if ([rez isEqualToString:@"YES"])
    {
        [switchAcccessShare setOnTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green-btn.png"]]];
        
        labelShare.text = [NSString stringWithFormat:@"Receiver(s) will be able to share %@ with others", _stringPinName];
        
        [self.pinDataDict setValue:@"1" forKey:@"is_shareable"];
    }
    else
    {
        switchAcccessShare.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"red-btn.png"]];
        switchAcccessShare.layer.cornerRadius = 16.0;
        labelShare.text = [NSString stringWithFormat:@"Receiver(s) will not be able to share %@ with others", _stringPinName];
        
        [self.pinDataDict setValue:@"0" forKey:@"is_shareable"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isshareable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) buttonCloseTapMessage:(id)sender
{
//    textViewMessage.text = @"Tap to enter the message...";
    
    [viewTapToMessage removeFromSuperview];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:viewShare];
}

- (IBAction) buttonOkShare:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isshareable"])
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isshareable"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        labelShare.text = [NSString stringWithFormat:@"Receiver(s) will be able to share %@ with others", pinModel.pinName];
        
        [self.pinDataDict setValue:@"1" forKey:@"is_shareable"];
    }
    [viewShare removeFromSuperview];
    
    [self sharePinLater];
}

- (void)fetchLocalCOntacts {
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            // TODO: Show alert
            [self openSessionofFBUsingSDK];
        }
    });
}

- (void)openRightMenu {
    [appDelegate openRightMenu];
}

-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    if(self.contacts == nil)
        self.contacts = [NSMutableArray new];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
        NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            PSContact *contact = [[PSContact alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);
            
            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            // Set Contact properties
            contact.firstName = firstName;
            contact.lastName = lastName;
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            
            
            contact.phone = [self getMobilePhoneProperty:phonesRef];
            
            /*
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            
           
            for(CFIndex i=0;i<ABMultiValueGetCount(phonesRef);i++) {
                
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phonesRef, i);
                NSString *phoneNumber = (__bridge NSString *) phoneNumberRef;
                [phoneNumbers addObject:phoneNumber];
                
                NSLog(@"All numbers %@", phoneNumbers);
                contact.phone=phoneNumber;
                
                
            }
            
            */
            if(contact.phone != nil && ![contact.phone isKindOfClass:[NSNull class]] && ([contact.firstName length] != 0 || [contact.lastName length] != 0) )
            {
                if(phonesRef) {
                    CFRelease(phonesRef);
                }
                
                // Get image if it exists
                NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
                contact.image = [UIImage imageWithData:imgData];
                if (!contact.image) {
                    contact.image = [UIImage imageNamed:@"user-icon.png"];
                }
                contact.fullName = [PSContact setfullNameFromcontact:contact];
                [mutableContacts addObject:contact];
            }
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        [self.contacts addObjectsFromArray:mutableContacts];
        //  self.contacts = [NSMutableArray arrayWithArray:mutableContacts];
        self.selectedContacts = [NSMutableArray array];
        self.filteredContacts = self.contacts;
        
        NSLog(@"%@",self.filteredContacts);
        NSLog(@"%@",self.selectedContacts);
        
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
    [self openSessionofFBUsingSDK];
}

- (void) refreshContacts
{
    for (PSContact* contact in self.contacts)
    {
        [self refreshContact: contact];
    }
    [self.tableView reloadData];
}

- (void) refreshContact:(PSContact*)contact
{
    
    ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, (ABRecordID)contact.recordId);
    contact.recordId = ABRecordGetRecordID(contactPerson);
    
    // Get first and last names
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
    
    // Set Contact properties
    contact.firstName = firstName;
    contact.lastName = lastName;
    
    // Get mobile number
    ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
    
    NSLog(@"phonesRef =%@",phonesRef);
    
    contact.phone = [self getMobilePhoneProperty:phonesRef];
    
     NSLog(@"contact.phone  =%@",contact.phone );
    if(phonesRef) {
        CFRelease(phonesRef);
    }
    
    // Get image if it exists
    NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
    contact.image = [UIImage imageWithData:imgData];
    if (!contact.image) {
        contact.image = [UIImage imageNamed:@"user-icon.png"];
    }
}

- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++)
    {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshContacts];
    });
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)contactTypeClicked:(PSButton *)sender {
    if (sender.tag == 101) {
        ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getContactsFromAddressBook];
                });
            } else {
                //  TODO: Show alert
            }
        });
    } else {
        //        [self openSessionofFBUsingSDK];
        [self openFriendsDialog];
    }
}
#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the desired contact from the filteredContacts array
    PSContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Get the UI elements in the cell;
    UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *mobilePhoneNumberLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    
    // Assign values to to US elements
    contactNameLabel.text = [contact fullName];
    mobilePhoneNumberLabel.text = contact.phone;
    NSLog(@"group ids = %lld", contact.recordId);
    //    if(contact.image) {
    //        contactImage.image = contact.image;
    //    } else
    if(contact.isGroup) {
        contactImage.image = [UIImage imageNamed:@"group-list-icon.png"];
    } else {
        contactImage.image = [UIImage imageNamed:@"user-icon.png"];
    }
    // Set the checked state for the contact selection checkbox
        UIImage *image;
        if ([self.selectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
            image = [UIImage imageNamed:@"check-icon.png"];
        } else {
            //cell.accessoryType = UITableViewCellAccessoryNone;
            image = [UIImage imageNamed:@"uncheck-icon.png"];
        }
        checkboxImageView.image = image;
        if(self.pinDataDict == nil) {
            [checkboxImageView setHidden:YES];
        } else {
            [checkboxImageView setHidden:NO];
        }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    user = [self.filteredContacts objectAtIndex:indexPath.row];
    NSLog(@"Ids = %lld", user.recordId);
//    [self.pinDataDict setValue:[self.arrayFriendIds objectAtIndex:indexPath.row] forKey:@"friend_ids"];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

//    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@%@",kCheckUserExistsApi,kCheckUserExists] parmeters:[NSDictionary dictionaryWithObject:user.phone!=nil?user.phone:@"" forKey:@"mobile_number"] completionHandler:^(id result, NSString *url, NSError *error) {
    
  //  user.phone = [user.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
//   NSString *pureNumbers = [[user.phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
//    
//    user.phone = pureNumbers;

   // user.phone = [user.phone substringToIndex:[user.phone length] - 1];
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@", user.phone];
    
    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@",kCheckUserExists] parmeters:[NSDictionary dictionaryWithObjectsAndKeys:user.phone, @"mobile_number", [PSUtility getCurrentUserId], @"id", nil] completionHandler:^(id result, NSString *url, NSError *error)
     {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
        if(!error)
        {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]])
            {
                //Checking on string as web-service does not have a status.
                if ([[result valueForKey:kMessageKey] isEqualToString:@"User doesn't exists"])
                {
                    PSNotAPinsterUserContactViewController *detailController = [[PSNotAPinsterUserContactViewController alloc] initWithNibName:@"PSNotAPinsterUserContactViewController" bundle:nil];
                    
                    detailController.contact = user;
                    
                    [self.navigationController pushViewController:detailController animated:YES];
                }
//                else if ([[result valueForKey:@"user"] valueForKey:@"pins_shared_with_me"] > 0)
//                {
//                    [self.arrayFriendIds addObject:[[result objectForKey:@"user"] objectForKey:@"id"]];
//                    
//                    if(self.pinDataDict == nil)
//                    {
//                        return;
//                    }
//                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//                    
//                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    
//                    // This uses the custom cellView
//                    // Set the custom imageView
//                    //        PSContact  *user = [self.filteredContacts objectAtIndex:indexPath.row];
//                    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
//                    UIImage *image;
//                    
//                    if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
//                        //cell.accessoryType = UITableViewCellAccessoryNone;
//                        [self.selectedContacts removeObject:user];
//                        //        [self.contactPickerView removeContact:user];
//                        // Set checkbox to "unselected"
//                        image = [UIImage imageNamed:@"uncheck-icon.png"];
//                    } else {
//                        // Contact has not been selected, add it to PSContactPickerView
//                        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                        [self.selectedContacts addObject:user];
//                        //        [self.contactPickerView addContact:user withName:user.fullName];
//                        // Set checkbox to "selected"
//                        image = [UIImage imageNamed:@"check-icon.png"];
//                    }
//                    
//                    //    // Enable Done button if total selected contacts > 0
//                    if(self.selectedContacts.count > 0) {
//                        barButton.enabled = TRUE;
//                    }
//                    else
//                    {
//                        barButton.enabled = FALSE;
//                    }
//                    //
//                    //    // Update window title
//                    self.title = [NSString stringWithFormat:@"Add Contacts (%lu)", (unsigned long)self.selectedContacts.count];
//                    //
//                    //    // Set checkbox image
//                    checkboxImageView.image = image;
//                    //    // Reset the filtered contacts
//                    self.filteredContacts = self.contacts;
//                }
                else
                {
                    if ([[result valueForKey:@"is_friend"] integerValue] == 1)
                    {
                        [self.arrayFriendIds addObject:[[result objectForKey:@"user"] objectForKey:@"id"]];
                        
                        if(self.pinDataDict == nil) {
                            return;
                        }
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        
                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        // This uses the custom cellView
                        // Set the custom imageView
                        //        PSContact  *user = [self.filteredContacts objectAtIndex:indexPath.row];
                        UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
                        UIImage *image;
                        
                        if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
                            //cell.accessoryType = UITableViewCellAccessoryNone;
                            [self.selectedContacts removeObject:user];
                            //        [self.contactPickerView removeContact:user];
                            // Set checkbox to "unselected"
                            image = [UIImage imageNamed:@"uncheck-icon.png"];
                        } else {
                            // Contact has not been selected, add it to PSContactPickerView
                            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                            [self.selectedContacts addObject:user];
                            //        [self.contactPickerView addContact:user withName:user.fullName];
                            // Set checkbox to "selected"
                            image = [UIImage imageNamed:@"check-icon.png"];
                        }
                        
                        //    // Enable Done button if total selected contacts > 0
                        if(self.selectedContacts.count > 0) {
                            barButton.enabled = TRUE;
                        }
                        else
                        {
                            barButton.enabled = FALSE;
                        }
                        //
                        //    // Update window title
                        self.title = [NSString stringWithFormat:@"Add Contacts (%lu)", (unsigned long)self.selectedContacts.count];
                        //
                        //    // Set checkbox image
                        checkboxImageView.image = image;
                        //    // Reset the filtered contacts
                        self.filteredContacts = self.contacts;
                    }
                    else
                    {
                        PSNotAContactViewController *detailController = [[PSNotAContactViewController alloc] initWithNibName:@"PSNotAContactViewController" bundle:nil];
                        
                        detailController.stringPhoneNo = user.phone;
                        
                        [self.navigationController pushViewController:detailController animated:YES];
                        
                        [self.arrayFriendIds addObject:[[result objectForKey:@"user"] objectForKey:@"id"]];
                        if(self.pinDataDict == nil) {
                            return;
                        }
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                        
                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        // This uses the custom cellView
                        // Set the custom imageView
                        //        PSContact  *user = [self.filteredContacts objectAtIndex:indexPath.row];
                        UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
                        UIImage *image;
                        
                        if ([self.selectedContacts containsObject:user]){ // contact is already selected so remove it from ContactPickerView
                            //cell.accessoryType = UITableViewCellAccessoryNone;
                            [self.selectedContacts removeObject:user];
                            //        [self.contactPickerView removeContact:user];
                            // Set checkbox to "unselected"
                            image = [UIImage imageNamed:@"uncheck-icon.png"];
                        } else {
                            // Contact has not been selected, add it to PSContactPickerView
                            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
                            [self.selectedContacts addObject:user];
                            //        [self.contactPickerView addContact:user withName:user.fullName];
                            // Set checkbox to "selected"
                            image = [UIImage imageNamed:@"check-icon.png"];
                        }
                        
                        //    // Enable Done button if total selected contacts > 0
                        if(self.selectedContacts.count > 0) {
                            barButton.enabled = TRUE;
                        }
                        else
                        {
                            barButton.enabled = FALSE;
                        }
                        //
                        //    // Update window title
                        self.title = [NSString stringWithFormat:@"Add Contacts (%lu)", (unsigned long)self.selectedContacts.count];
                        //
                        //    // Set checkbox image
                        checkboxImageView.image = image;
                        //    // Reset the filtered contacts
                        self.filteredContacts = self.contacts;
                    }
//                    [[WSHelper sharedInstance] getArrayFromGetURL:[NSString stringWithFormat:@"%@",kCheckPinsterUserOrNot] parmeters:[NSDictionary dictionaryWithObjectsAndKeys:[PSUtility getCurrentUserId], @"from_user_id", [[result valueForKey:@"user"] valueForKey:@"id"], @"to_user_id", nil] completionHandler:^(id result, NSString *url, NSError *error)
//                     {
//                         
//                     }];
                }
            }
            else
            {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        }
        else
        {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
    
    // If contact is already my friend.
//        PSContactDetailViewController *detailController = [[PSContactDetailViewController alloc] initWithNibName:@"PSContactDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:detailController animated:YES];
    
    
    
    //    // Hide Keyboard
        //    [self.contactPickerView resignKeyboard];
    
    //    // Refresh the tableview
        [self.tableView reloadData];
    
}

#pragma mark - PSContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"firstName", textViewText, @"lastName", textViewText];
        self.filteredContacts = [NSMutableArray arrayWithArray:[self.contacts filteredArrayUsingPredicate:predicate]];
    }
    [self.tableView reloadData];
}

- (void)contactPickerDidRemoveContact:(id)contact {
    [self.selectedContacts removeObject:contact];
    
    NSUInteger index = [self.contacts indexOfObject:contact];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    // Enable Done button if total selected contacts > 0
    if(self.selectedContacts.count > 0) {
        barButton.enabled = TRUE;
    }
    else
    {
        barButton.enabled = FALSE;
    }
    
    // Set unchecked image
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    image = [UIImage imageNamed:@"uncheck-icon.png"];
    checkboxImageView.image = image;
    
    // Update window title
    self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
}

- (void)removeAllContacts:(id)sender
{
    //    [self.contactPickerView removeAllContacts];
    [self.selectedContacts removeAllObjects];
    self.filteredContacts = self.contacts;
    [self.tableView reloadData];
}
#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

// This opens the apple contact details view: ABPersonViewController
//TODO: make a PSContactPickerDetailViewController
- (IBAction)viewContactDetail:(UIButton*)sender {
    ABRecordID personId = (ABRecordID)sender.tag;
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    view.addressBook = self.addressBookRef;
    view.personViewDelegate = self;
    view.displayedPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, personId);
    [self.navigationController pushViewController:view animated:YES];
}

// TODO: send contact object
- (void)done:(id)sender
{
    PSCustomAlertView *customAlert;
    
    if (self.selectedContacts.count > 1)
    {
        customAlert = [[PSCustomAlertView alloc] initWithTitle:@"Do you want to share the Pin/Snap with these contacts ?" delegate:self isDoubleButton:YES ofOption:1];
    }
    else if (self.selectedContacts.count == 0)
    {
        customAlert = [[PSCustomAlertView alloc] initWithTitle:@"Please select at least one contact." delegate:self isDoubleButton:YES ofOption:1];
    }
    else
    {
        customAlert = [[PSCustomAlertView alloc] initWithTitle:@"Do you want to share the Pin/Snap with this contact ?" delegate:self isDoubleButton:YES ofOption:1];
    }
    [[[UIApplication sharedApplication] keyWindow] addSubview:customAlert];
}

#pragma mark - PSCustomAlertView delegates
-(void)customAlertYesButtonPressed:(PSCustomAlertView *)customAlertView {
    [customAlertView removeFromSuperview];
    //[self uploadPinDetailsToServer];
    if (self.selectedContacts.count > 1)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isGroup == YES"];
        NSArray *filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
        if([filtedFbArray count] > 0) {
            NSString *tempGroupString = [[[filtedFbArray valueForKeyPath:@"recordId"] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempGroupString] forKey:@"group_ids"];
        }
        if([filtedFbArray count] > 0) {
//            [self uploadPinDetailsToServer];
//            [self sharePinLater];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to create a group, with these selected contacts ?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];//
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alert textFieldAtIndex:0];
            [textField setPlaceholder:@"Enter Group Name"];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to create a group, with these selected contacts ?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];//
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alert textFieldAtIndex:0];
            [textField setPlaceholder:@"Enter Group Name"];
            [alert show];
        }
    }
    else if (self.selectedContacts.count == 0)
    {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
//                                 forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.shadowImage = [UIImage new];
//        self.navigationController.navigationBar.translucent = YES;
        
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
        
//        [[[UIApplication sharedApplication] keyWindow] addSubview:viewTapToMessage];
//        [self.navigationController.navigationBar sendSubviewToBack:self.view];
//        self.navigationController.navigationBar.clipsToBounds = NO;
//        self.navigationController.navigationBar.translucent = YES;
//        viewTapToMessage.backgroundColor = [UIColor clearColor];
//       [self.view addSubview:viewTapToMessage];
    }
    else
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:viewTapToMessage];
    }
}

#pragma mark - UITextView Delegate

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            [viewTapToMessage removeFromSuperview];
            [self.pinDataDict setValue:textViewMessage.text forKey:@"message"];
            labelShare.text = [NSString stringWithFormat:@"Receiver(s) will be able to share %@ with others", _stringPinName];
            [switchAcccessShare setOnTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green-btn.png"]]];
            [[[UIApplication sharedApplication] keyWindow] addSubview:viewShare];
//            [self.view addSubview:viewShare];
            return NO;
        }
    if ([textViewMessage.text isEqualToString:@"Tap to enter the message..."])
    {
        textViewMessage.text = nil;
    }
    else
    {
        textViewMessage.textColor = [UIColor blackColor];
    }
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if(![PSUtility isValidData:[textField text]])
        {
            //[PSUtility showAlert:@"Error" withMessage:@"Please enter Email Id"];
            PSCustomAlertView *alertView = [[PSCustomAlertView alloc] initWithMessage:@"Please enter Group Name"];
            [self.view addSubview:alertView];
            return;
        }
        [self.pinDataDict setValue:textField.text forKey:@"groupname"];
        [self performSelector:@selector(addTapMessage) withObject:nil afterDelay:1.0f];
    }
    else
    {
        [self performSelector:@selector(addTapMessage) withObject:nil afterDelay:1.0f];
    }
//    [self uploadPinDetailsToServer];
    
}

-(void)addTapMessage {
    [[[UIApplication sharedApplication] keyWindow] addSubview:viewTapToMessage];
}
-(void)customAlertNoButtonPressed:(PSCustomAlertView *)customAlertView {
    [customAlertView removeFromSuperview];
}
#pragma mark facebook functions
- (void)openSessionofFBUsingSDK
{
    if (FBSession.activeSession.isOpen)
    {
        [self getFBFriendsDetailUsingSDK];
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error)
         {
             if (error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                     message:error.localizedDescription
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 [self sortAllContacts];
             }
             else if (FB_ISSESSIONOPENWITHSTATE(state))
             {
                 [self getFBFriendsDetailUsingSDK];
             }
         }];
    }
}

- (void)getFBFriendsDetailUsingSDK
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSArray *arrObjs = [NSArray arrayWithObjects:@"id,first_name,last_name", @"5000", nil];
    NSArray *arrKeys = [NSArray arrayWithObjects:@"fields", @"limit", nil];
    NSDictionary *dicParams = [NSDictionary dictionaryWithObjects:arrObjs forKeys:arrKeys];
    
    FBRequest *loadFriends = [FBRequest requestWithGraphPath:@"me/friends"
                                                  parameters:dicParams
                                                  HTTPMethod:@"GET"];
    
    [loadFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        dLog(@"Result = %@", result);
        if (!error) {
            [self.facebookContacts removeAllObjects];
            self.facebookContacts = nil;
            self.facebookContacts = [NSMutableArray new];
            [self checkFriendsListInNextPage:result];
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self sortAllContacts];
        }
    }];
}

- (void)checkFriendsListInNextPage:(id)friendsData {
    if(friendsData == nil) {
        [self sortAllContacts];
        return;
    }
    [self.facebookContacts addObjectsFromArray:[friendsData objectForKey:@"data"]];
    if([[[friendsData objectForKey:@"paging"] objectForKey:@"next"] length] > 0) {
        [self getNextPageFriends:[[friendsData objectForKey:@"paging"] objectForKey:@"next"] completionHandler:^(NSMutableArray *arrayResult, NSError *error) {
            dLog(@"Error: %@",error);
            if(error) {
                [self checkFriendsListInNextPage:nil];
                [self sortAllContacts];
            } else {
                [self checkFriendsListInNextPage:arrayResult];
            }
            
        }];
    } else {
        //        [self contactsSearchByFacebookId];
        if(self.contacts == nil)
            self.contacts = [NSMutableArray new];
        for(NSDictionary *friendData in self.facebookContacts) {
            PSContact *contactObj = [[PSContact alloc] init];
            [contactObj setFirstName:[friendData valueForKey:@"first_name"]];
            [contactObj setLastName:[friendData valueForKey:@"last_name"]];
            [contactObj setRecordId:[[friendData valueForKey:@"id"] longLongValue]];
            [contactObj setFriendIds:[friendData valueForKey:@"id"]];
            contactObj.fullName = [PSContact setfullNameFromcontact:contactObj];
            [contactObj setIsFBContact:YES];
            if([[contactObj.fullName stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0) {
                [self.contacts addObject:contactObj];
            }
            
        }
        [self sortAllContacts];
        
    }
    
}

- (void)getNextPageFriends:(NSString *)url completionHandler:(void (^)(NSMutableArray *arrayResult, NSError *error))block {
    [[WSHelper sharedInstance] getArrayFromGetURL:url parmeters:nil completionHandler:^(NSMutableArray *arrayResult, NSString *url, NSError *error) {
        block(arrayResult,error);
    }];
}


- (void)openFriendsDialog {
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:nil
     message:[NSString stringWithFormat:@"%@ has invited you to join Pinster",[objUser objectForKey:kNameKey]]
     title:@"Pinster"
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);
                 }
             }
         }
     }];
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}
#pragma mark - webservice calls



- (void)uploadPinDetailsToServer {
    if([[self.pinDataDict allKeys] count] == 1) {
        [self sharePinLater];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFBContact == YES"];
    NSArray *filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSString *tempFBString = [[[filtedFbArray valueForKeyPath:@"recordId"] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempFBString] forKey:@"friend_uids"];
    }
    predicate = [NSPredicate predicateWithFormat:@"isGroup == YES"];
    filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSString *tempGroupString = [[[filtedFbArray valueForKeyPath:@"recordId"] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempGroupString] forKey:@"group_ids"];
    }
    
    predicate = [NSPredicate predicateWithFormat:@"isFBContact == NO AND isGroup == NO"];
    filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSString *tempPhString = [[[self formatePhonrNumbers:[filtedFbArray valueForKeyPath:@"phone"]] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempPhString] forKey:@"friend_mobile_numbers"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.pinDataDict setValue:[PSUtility getCurrentUserId] forKey:@"user_id"];
    
    
    
    if([[appDelegate currentPinDetails] valueForKey:@"snapImage"] != nil) {
        [[WSHelper sharedInstance] uploadFileWithURL:kAddPinApi withMethod:@"POST" withParmeters:self.pinDataDict mediaData:UIImageJPEGRepresentation([PSUtility scaleImage:((UIImage *)[[appDelegate currentPinDetails] valueForKey:@"snapImage"]) toSize:CGSizeMake(620, 1136)], 1.0) withKey:@"shared_picture" completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self handleCompletionSharing:result withError:error];
        }];
    } else {
        [[WSHelper sharedInstance] getArrayFromPostURL:kAddPinApi parmeters:self.pinDataDict completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self handleCompletionSharing:result withError:error];
        }];
    }
    
    
    
}
- (void)handleCompletionSharing:(id)result withError:(NSError *)error {
    if(!error) {
        if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
            [PSUtility saveSessionValue:@{@"old_lat": [self.pinDataDict objectForKey:PIN_LAT],@"old_long": [self.pinDataDict objectForKey:PIN_LANG]} withKey:@"OLD_LOCATION_DETAILS"];
            [[appDelegate subNavigationController] popToRootViewControllerAnimated:NO];
            PSMyPinsViewController *pinsVc =  [[PSMyPinsViewController alloc] initWithNibName:@"PSMyPinsViewController" bundle:[NSBundle mainBundle]];
            pinsVc.isMyPinsOnly = YES;
            [[appDelegate subNavigationController] setViewControllers:[NSArray arrayWithObject:pinsVc]];
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
        }
    } else {
        [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
    }
}

- (void)sharePinLater {
    [self.pinDataDict setValue:[PSUtility getCurrentUserId] forKey:@"user_id"];
    
//    [self.pinDataDict setValue:@"1" forKey:@"friend_ids"];
    NSString * result = [self.arrayFriendIds componentsJoinedByString:@","];
    
    [self.pinDataDict setValue:result forKey:@"friend_ids"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFBContact == YES"];
    NSArray *filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSString *tempFBString = [[[filtedFbArray valueForKeyPath:@"recordId"] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempFBString] forKey:@"friend_uids"];
    }
    predicate = [NSPredicate predicateWithFormat:@"isGroup == YES"];
    filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSString *tempGroupString = [[[filtedFbArray valueForKeyPath:@"recordId"] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempGroupString] forKey:@"group_ids"];
    }
    
    predicate = [NSPredicate predicateWithFormat:@"isFBContact == NO AND isGroup == NO"];
    filtedFbArray = [self.selectedContacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSString *tempPhString = [[[self formatePhonrNumbers:[filtedFbArray valueForKeyPath:@"phone"]] componentsJoinedByString:@","] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

//        [self.pinDataDict setValue:[NSString stringWithFormat:@"%@",tempPhString] forKey:@"friend_mobile_numbers"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    /*
    if (self.arrayFriendIds.count > 1)
    {
        [[WSHelper sharedInstance] getArrayFromPutURL:kAddPinLaterApiForGroup parmeters:self.pinDataDict completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error) {
                if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                }
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
            }
        }];
    }
    else
    {*/
//        [[WSHelper sharedInstance] getArrayFromPutURL:kAddPinLaterApi parmeters:self.pinDataDict completionHandler:^(id result, NSString *url, NSError *error) {
    [[WSHelper sharedInstance] getArrayFromPutURL:kAddPinLaterApi parmeters:self.pinDataDict completionHandler:^(id result, NSString *url, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(!error) {
                if([PSUtility isTrue:[result valueForKey:kSuccessKey]]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:0 forKey:@"pinsshared"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSUserDefaults *objdefault =[NSUserDefaults standardUserDefaults];
                    NSMutableArray *nameArray = [[objdefault objectForKey:@"pinssh"] mutableCopy];
                    
                    if(!nameArray)
                        nameArray = [@[] mutableCopy];
                    [nameArray addObject:@"1"];
                    
                    [objdefault setObject:nameArray forKey:@"pinssh"];
                    
                    [objdefault synchronize];
                    
                    int totalPins = 0;
                    for (int i = 0; i < [nameArray count]; i++)
                    {
                        totalPins = totalPins + [[nameArray objectAtIndex:i] intValue];
                    }
                    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:totalPins] forKey:@"pinsshared"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                } else {
                    [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
                }
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
            }
        }];
//    }
}

- (NSMutableArray *)formatePhonrNumbers:(NSArray *)phoneNumbers {
    NSMutableArray *phoneArray = [NSMutableArray new];
    for (NSString *phoneNumber in phoneNumbers) {
        NSMutableString *strippedString = [NSMutableString
                                           stringWithCapacity:phoneNumber.length];
        
        NSScanner *scanner = [NSScanner scannerWithString:phoneNumber];
        NSCharacterSet *numbers = [NSCharacterSet
                                   characterSetWithCharactersInString:@"0123456789"];
        
        while ([scanner isAtEnd] == NO) {
            NSString *buffer;
            if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
                [strippedString appendString:buffer];
                
            } else {
                [scanner setScanLocation:([scanner scanLocation] + 1)];
            }
        }
        [phoneArray addObject:strippedString];
    }
    return phoneArray;
}
- (void)sortAllContacts {
    NSMutableArray *groupArray ;
    NSMutableArray *nonGroupArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isGroup == YES"];
    NSArray *filtedFbArray = [self.contacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        groupArray = [NSMutableArray arrayWithArray:[filtedFbArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]]];
        dLog(@"g names: %@",[groupArray valueForKeyPath:@"fullName"]);
    }
    predicate = [NSPredicate predicateWithFormat:@"isGroup == NO"];
    filtedFbArray = [self.contacts filteredArrayUsingPredicate:predicate];
    if([filtedFbArray count] > 0) {
        NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        nonGroupArray = [NSMutableArray arrayWithArray:[filtedFbArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]]];
        dLog(@"non g names: %@",[nonGroupArray valueForKeyPath:@"fullName"]);
    }
    [self.contacts removeAllObjects];
    if([groupArray count] >0)
        [self.contacts addObjectsFromArray:groupArray];
    if([nonGroupArray count] >0)
        [self.contacts addObjectsFromArray:nonGroupArray];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.tableView reloadData];
    
    dLog(@"All names: %@",[nonGroupArray valueForKeyPath:@"fullName"]);
}
@end
