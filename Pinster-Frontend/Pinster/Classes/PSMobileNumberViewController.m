//
//  PSMobileNumberViewController.m
//  Pinster
//
//  Created by Mobiledev on 20/06/14.
//  Copyright (c) 2014 SINGULARITY LABS, INC. All rights reserved.
//

#import "PSMobileNumberViewController.h"

@interface PSMobileNumberViewController ()
@property (nonatomic, strong) NSMutableArray *countryList;
@property (nonatomic, strong) NSDictionary *countryDict;
@end

@implementation PSMobileNumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setTitleView:[PSUtility getHeaderLabelWithText:@"Phone Number"]];
    [self loadAllPhoneCodes];
}
-(void)loadAllPhoneCodes {
    self.countryDict = @{
                         @"Abkhazia"                                     : @"+7 940",
                         @"Afghanistan"                                  : @"+93",
                         @"Albania"                                      : @"+355",
                         @"Algeria"                                      : @"+213",
                         @"American Samoa"                               : @"+1 684",
                         @"Andorra"                                      : @"+376",
                         @"Angola"                                       : @"+244",
                         @"Anguilla"                                     : @"+1 264",
                         @"Antigua and Barbuda"                          : @"+1 268",
                         @"Argentina"                                    : @"+54",
                         @"Armenia"                                      : @"+374",
                         @"Aruba"                                        : @"+297",
                         @"Ascension"                                    : @"+247",
                         @"Australia"                                    : @"+61",
                         @"Australian External Territories"              : @"+672",
                         @"Austria"                                      : @"+43",
                         @"Azerbaijan"                                   : @"+994",
                         @"Bahamas"                                      : @"+1 242",
                         @"Bahrain"                                      : @"+973",
                         @"Bangladesh"                                   : @"+880",
                         @"Barbados"                                     : @"+1 246",
                         @"Barbuda"                                      : @"+1 268",
                         @"Belarus"                                      : @"+375",
                         @"Belgium"                                      : @"+32",
                         @"Belize"                                       : @"+501",
                         @"Benin"                                        : @"+229",
                         @"Bermuda"                                      : @"+1 441",
                         @"Bhutan"                                       : @"+975",
                         @"Bolivia"                                      : @"+591",
                         @"Bosnia and Herzegovina"                       : @"+387",
                         @"Botswana"                                     : @"+267",
                         @"Brazil"                                       : @"+55",
                         @"British Indian Ocean Territory"               : @"+246",
                         @"British Virgin Islands"                       : @"+1 284",
                         @"Brunei"                                       : @"+673",
                         @"Bulgaria"                                     : @"+359",
                         @"Burkina Faso"                                 : @"+226",
                         @"Burundi"                                      : @"+257",
                         @"Cambodia"                                     : @"+855",
                         @"Cameroon"                                     : @"+237",
                         @"Canada"                                       : @"+1",
                         @"Cape Verde"                                   : @"+238",
                         @"Cayman Islands"                               : @"+ 345",
                         @"Central African Republic"                     : @"+236",
                         @"Chad"                                         : @"+235",
                         @"Chile"                                        : @"+56",
                         @"China"                                        : @"+86",
                         @"Christmas Island"                             : @"+61",
                         @"Cocos-Keeling Islands"                        : @"+61",
                         @"Colombia"                                     : @"+57",
                         @"Comoros"                                      : @"+269",
                         @"Congo"                                        : @"+242",
                         @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                         @"Cook Islands"                                 : @"+682",
                         @"Costa Rica"                                   : @"+506",
                         @"Ivory Coast"                                  : @"+225",
                         @"Croatia"                                      : @"+385",
                         @"Cuba"                                         : @"+53",
                         @"Curacao"                                      : @"+599",
                         @"Cyprus"                                       : @"+537",
                         @"Czech Republic"                               : @"+420",
                         @"Denmark"                                      : @"+45",
                         @"Diego Garcia"                                 : @"+246",
                         @"Djibouti"                                     : @"+253",
                         @"Dominica"                                     : @"+1 767",
                         @"Dominican Republic"                           : @"+1 809",
                         @"Dominican Republic"                           : @"+1 829",
                         @"Dominican Republic"                           : @"+1 849",
                         @"East Timor"                                   : @"+670",
                         @"Easter Island"                                : @"+56",
                         @"Ecuador"                                      : @"+593",
                         @"Egypt"                                        : @"+20",
                         @"El Salvador"                                  : @"+503",
                         @"Equatorial Guinea"                            : @"+240",
                         @"Eritrea"                                      : @"+291",
                         @"Estonia"                                      : @"+372",
                         @"Ethiopia"                                     : @"+251",
                         @"Falkland Islands"                             : @"+500",
                         @"Faroe Islands"                                : @"+298",
                         @"Fiji"                                         : @"+679",
                         @"Finland"                                      : @"+358",
                         @"France"                                       : @"+33",
                         @"French Antilles"                              : @"+596",
                         @"French Guiana"                                : @"+594",
                         @"French Polynesia"                             : @"+689",
                         @"Gabon"                                        : @"+241",
                         @"Gambia"                                       : @"+220",
                         @"Georgia"                                      : @"+995",
                         @"Germany"                                      : @"+49",
                         @"Ghana"                                        : @"+233",
                         @"Gibraltar"                                    : @"+350",
                         @"Greece"                                       : @"+30",
                         @"Greenland"                                    : @"+299",
                         @"Grenada"                                      : @"+1 473",
                         @"Guadeloupe"                                   : @"+590",
                         @"Guam"                                         : @"+1 671",
                         @"Guatemala"                                    : @"+502",
                         @"Guinea"                                       : @"+224",
                         @"Guinea-Bissau"                                : @"+245",
                         @"Guyana"                                       : @"+595",
                         @"Haiti"                                        : @"+509",
                         @"Honduras"                                     : @"+504",
                         @"Hong Kong SAR China"                          : @"+852",
                         @"Hungary"                                      : @"+36",
                         @"Iceland"                                      : @"+354",
                         @"India"                                        : @"+91",
                         @"Indonesia"                                    : @"+62",
                         @"Iran"                                         : @"+98",
                         @"Iraq"                                         : @"+964",
                         @"Ireland"                                      : @"+353",
                         @"Israel"                                       : @"+972",
                         @"Italy"                                        : @"+39",
                         @"Jamaica"                                      : @"+1 876",
                         @"Japan"                                        : @"+81",
                         @"Jordan"                                       : @"+962",
                         @"Kazakhstan"                                   : @"+7 7",
                         @"Kenya"                                        : @"+254",
                         @"Kiribati"                                     : @"+686",
                         @"North Korea"                                  : @"+850",
                         @"South Korea"                                  : @"+82",
                         @"Kuwait"                                       : @"+965",
                         @"Kyrgyzstan"                                   : @"+996",
                         @"Laos"                                         : @"+856",
                         @"Latvia"                                       : @"+371",
                         @"Lebanon"                                      : @"+961",
                         @"Lesotho"                                      : @"+266",
                         @"Liberia"                                      : @"+231",
                         @"Libya"                                        : @"+218",
                         @"Liechtenstein"                                : @"+423",
                         @"Lithuania"                                    : @"+370",
                         @"Luxembourg"                                   : @"+352",
                         @"Macau SAR China"                              : @"+853",
                         @"Macedonia"                                    : @"+389",
                         @"Madagascar"                                   : @"+261",
                         @"Malawi"                                       : @"+265",
                         @"Malaysia"                                     : @"+60",
                         @"Maldives"                                     : @"+960",
                         @"Mali"                                         : @"+223",
                         @"Malta"                                        : @"+356",
                         @"Marshall Islands"                             : @"+692",
                         @"Martinique"                                   : @"+596",
                         @"Mauritania"                                   : @"+222",
                         @"Mauritius"                                    : @"+230",
                         @"Mayotte"                                      : @"+262",
                         @"Mexico"                                       : @"+52",
                         @"Micronesia"                                   : @"+691",
                         @"Midway Island"                                : @"+1 808",
                         @"Micronesia"                                   : @"+691",
                         @"Moldova"                                      : @"+373",
                         @"Monaco"                                       : @"+377",
                         @"Mongolia"                                     : @"+976",
                         @"Montenegro"                                   : @"+382",
                         @"Montserrat"                                   : @"+1664",
                         @"Morocco"                                      : @"+212",
                         @"Myanmar"                                      : @"+95",
                         @"Namibia"                                      : @"+264",
                         @"Nauru"                                        : @"+674",
                         @"Nepal"                                        : @"+977",
                         @"Netherlands"                                  : @"+31",
                         @"Netherlands Antilles"                         : @"+599",
                         @"Nevis"                                        : @"+1 869",
                         @"New Caledonia"                                : @"+687",
                         @"New Zealand"                                  : @"+64",
                         @"Nicaragua"                                    : @"+505",
                         @"Niger"                                        : @"+227",
                         @"Nigeria"                                      : @"+234",
                         @"Niue"                                         : @"+683",
                         @"Norfolk Island"                               : @"+672",
                         @"Northern Mariana Islands"                     : @"+1 670",
                         @"Norway"                                       : @"+47",
                         @"Oman"                                         : @"+968",
                         @"Pakistan"                                     : @"+92",
                         @"Palau"                                        : @"+680",
                         @"Palestinian Territory"                        : @"+970",
                         @"Panama"                                       : @"+507",
                         @"Papua New Guinea"                             : @"+675",
                         @"Paraguay"                                     : @"+595",
                         @"Peru"                                         : @"+51",
                         @"Philippines"                                  : @"+63",
                         @"Poland"                                       : @"+48",
                         @"Portugal"                                     : @"+351",
                         @"Puerto Rico"                                  : @"+1 787",
                         @"Puerto Rico"                                  : @"+1 939",
                         @"Qatar"                                        : @"+974",
                         @"Reunion"                                      : @"+262",
                         @"Romania"                                      : @"+40",
                         @"Russia"                                       : @"+7",
                         @"Rwanda"                                       : @"+250",
                         @"Samoa"                                        : @"+685",
                         @"San Marino"                                   : @"+378",
                         @"Saudi Arabia"                                 : @"+966",
                         @"Senegal"                                      : @"+221",
                         @"Serbia"                                       : @"+381",
                         @"Seychelles"                                   : @"+248",
                         @"Sierra Leone"                                 : @"+232",
                         @"Singapore"                                    : @"+65",
                         @"Slovakia"                                     : @"+421",
                         @"Slovenia"                                     : @"+386",
                         @"Solomon Islands"                              : @"+677",
                         @"South Africa"                                 : @"+27",
                         @"South Georgia and the South Sandwich Islands" : @"+500",
                         @"Spain"                                        : @"+34",
                         @"Sri Lanka"                                    : @"+94",
                         @"Sudan"                                        : @"+249",
                         @"Suriname"                                     : @"+597",
                         @"Swaziland"                                    : @"+268",
                         @"Sweden"                                       : @"+46",
                         @"Switzerland"                                  : @"+41",
                         @"Syria"                                        : @"+963",
                         @"Taiwan"                                       : @"+886",
                         @"Tajikistan"                                   : @"+992",
                         @"Tanzania"                                     : @"+255",
                         @"Thailand"                                     : @"+66",
                         @"Timor Leste"                                  : @"+670",
                         @"Togo"                                         : @"+228",
                         @"Tokelau"                                      : @"+690",
                         @"Tonga"                                        : @"+676",
                         @"Trinidad and Tobago"                          : @"+1 868",
                         @"Tunisia"                                      : @"+216",
                         @"Turkey"                                       : @"+90",
                         @"Turkmenistan"                                 : @"+993",
                         @"Turks and Caicos Islands"                     : @"+1 649",
                         @"Tuvalu"                                       : @"+688",
                         @"Uganda"                                       : @"+256",
                         @"Ukraine"                                      : @"+380",
                         @"United Arab Emirates"                         : @"+971",
                         @"United Kingdom"                               : @"+44",
                         @"United States"                                : @"+1",
                         @"Uruguay"                                      : @"+598",
                         @"U.S. Virgin Islands"                          : @"+1 340",
                         @"Uzbekistan"                                   : @"+998",
                         @"Vanuatu"                                      : @"+678",
                         @"Venezuela"                                    : @"+58",
                         @"Vietnam"                                      : @"+84",
                         @"Wake Island"                                  : @"+1 808",
                         @"Wallis and Futuna"                            : @"+681",
                         @"Yemen"                                        : @"+967",
                         @"Zambia"                                       : @"+260",
                         @"Zanzibar"                                     : @"+255",
                         @"Zimbabwe"                                     : @"+263"
                         };
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES];
    self.countryList = [NSMutableArray arrayWithArray:[[self.countryDict allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDesc]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isEditingNumber) {
        self.lblHelpText.text =@"Enter the new number that you like to register";
    }
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [PSUtility getBackBarButtonWithSelecter:@selector(backCLicked) withTarget:self];
    NSMutableDictionary *objUser = [PSUtility getValueFromSession:kUserDetailsKey];
    if([objUser valueForKey:kMobileKey] != nil && [[objUser valueForKey:kMobileKey] length] > 0) {
        if([[[objUser valueForKey:kMobileKey] componentsSeparatedByString:@"-"] count] == 2) {
            [self.btnCountryCode setTitle:[[[objUser valueForKey:kMobileKey] componentsSeparatedByString:@"-"] objectAtIndex:0] forState:UIControlStateNormal];
            self.txtPhoneNumber.text = [[[objUser valueForKey:kMobileKey] componentsSeparatedByString:@"-"] objectAtIndex:1];
        } else {
            self.txtPhoneNumber.text = [[[objUser valueForKey:kMobileKey] componentsSeparatedByString:@"-"] objectAtIndex:0];
        }
        [self.pickerCoun reloadAllComponents];
        for(NSString *key in [self.countryDict allKeys]) {
            if([[self.countryDict valueForKey:key] isEqualToString:[[[objUser valueForKey:kMobileKey] componentsSeparatedByString:@"-"] objectAtIndex:0]]) {
                [self.pickerCoun selectRow:[self.countryList indexOfObject:key] inComponent:0 animated:YES];
                break;
            }
        }

    } else {
        
        NSLocale *locale = [NSLocale currentLocale];
        NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
        [self getCountryCodeFromCuntryName:country];
        [self.pickerCoun reloadAllComponents];
        [self.pickerCoun selectRow:[self.countryList indexOfObject:country] inComponent:0 animated:YES];
    }

}

-(void)backCLicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [textField becomeFirstResponder];
//    return YES;
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)btnProcedClicked:(id)sender{
    if(![PSUtility isValidData:self.txtPhoneNumber.text]) {
        [PSUtility showAlert:@"Error" withMessage:@"Please Enter Mobile Number"];
        return;
    }
    NSMutableDictionary *objUser = [NSMutableDictionary dictionaryWithDictionary:[PSUtility getValueFromSession:kUserDetailsKey]];
    [objUser setValue:[NSString stringWithFormat:@"%@-%@",self.btnCountryCode.titleLabel.text,self.txtPhoneNumber.text] forKey:kMobileKey];
    [PSUtility saveSessionValue:objUser withKey:kUserDetailsKey];
    [self.txtPhoneNumber resignFirstResponder];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[WSHelper sharedInstance] getArrayFromPutURL:kGenerateVerificationCodeApi parmeters:@{kUser_IdKey: [objUser valueForKey:kUserIdKey], kMobileKey:[NSString stringWithFormat:@"%@-%@",self.btnCountryCode.titleLabel.text,self.txtPhoneNumber.text]} completionHandler:^(id result, NSString *url, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(!error) {
            if([PSUtility isTrue:[result valueForKey:kSuccessKey]] && [PSUtility isValidData:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationCodeKey]] && [PSUtility isValidData:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey]]) {
                [objUser setValue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationCodeKey] forKey:kMobileVerificationCodeKey];
                [objUser setValue:[[result valueForKey:KDataKey] valueForKey:kMobileVerificationStatusKey] forKey:kMobileVerificationStatusKey];
                [PSUtility saveSessionValue:objUser withKey:kUserDetailsKey];
                [self.navigationController pushViewController:[PSUtility getViewControllerWithName:@"PSPassCodeViewController"] animated:YES];
            } else {
                [[PSUtility sharedInstance] showCustomAlertWithMessage:[result valueForKey:kMessageKey] onViewController:self withDelegate:nil];
            }
        } else {
            [[PSUtility sharedInstance] showCustomAlertWithMessage:error.localizedDescription onViewController:self withDelegate:nil];
        }
    }];
}

- (NSString *)getCountryCodeFromCuntryName:(NSString *)countryName {
    // Country code
    [self.btnCountryCode setTitle:[self.countryDict objectForKey:countryName] forState:UIControlStateNormal];
    return [self.countryDict objectForKey:countryName];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.countryList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.countryList objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self.btnCountryCode setTitle:[self getCountryCodeFromCuntryName:[self.countryList objectAtIndex:row]] forState:UIControlStateNormal];
}
@end
