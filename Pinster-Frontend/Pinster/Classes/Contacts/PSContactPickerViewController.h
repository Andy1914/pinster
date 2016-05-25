//
//  ContactPickerViewController.h
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PSContactPickerView.h"
#import "PSContactPickerTableViewCell.h"

@interface PSContactPickerViewController : PSParentViewController <UITableViewDataSource, UITableViewDelegate, PSContactPickerDelegate, ABPersonViewControllerDelegate>

@property (nonatomic, strong) PSContactPickerView *contactPickerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSMutableArray *selectedContacts;
@property (nonatomic, strong) NSMutableArray *filteredContacts;
@property (nonatomic, strong) NSMutableDictionary *pinDataDict;

@property (strong, nonatomic) NSString *stringPinName;


-(IBAction)contactTypeClicked:(PSButton *)sender;
@end
