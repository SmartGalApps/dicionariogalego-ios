//
//  OptionsViewController.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController {
    NSArray *theOptions;
    NSArray *theOptionsLinks;
    NSString *selected;
    NSString *selectedLink;
    NSString *html;
    UIAlertView *loadingAlert;
}

@property (nonatomic, retain) NSString *html;
@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSString *selectedLink;
@property (nonatomic, retain) NSArray *theOptions;
@property (nonatomic, retain) NSArray *theOptionsLinks;
@property (nonatomic, retain) UIAlertView *loadingAlert;

@property (weak, nonatomic) IBOutlet UIPickerView *options;
- (IBAction)search:(id)sender;
- (IBAction)grabURLInBackground:(id)sender;
-(void)showAlert;
-(void)dismissAlert;
@end