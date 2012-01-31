//
//  OptionsViewController.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@interface OptionsViewController : UIViewController <ParserDelegate>

@property (nonatomic, retain) NSString *html;
@property (nonatomic, retain) NSString *selected;
@property (nonatomic, retain) NSString *selectedLink;
@property (nonatomic, retain) NSArray *theOptions;
@property (nonatomic, retain) NSArray *theOptionsLinks;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIPickerView *options;

- (IBAction)search:(id)sender;

@end
