//
//  ViewController.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate> {
    NSString *html;
    NSMutableData* responseData;
    UIAlertView *loadingAlert;
}

@property (nonatomic, retain) NSString* html;
@property (nonatomic, retain) NSMutableData* responseData;
@property (weak, nonatomic) IBOutlet UITextField *termTextField;
@property (nonatomic, retain) UIAlertView *loadingAlert;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)grabURLInBackground:(id)sender;
- (IBAction)searchButton:(id)sender;
-(void)search;
-(void)showAlert;
-(void)dismissAlert;
- (void)registerForKeyboardNotifications;

@end
