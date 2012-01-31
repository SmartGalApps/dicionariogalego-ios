//
//  ViewController.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@interface ViewController : UIViewController <UITextFieldDelegate, ParserDelegate>

@property (nonatomic, retain) NSArray* options;
@property (nonatomic, retain) NSArray* optionsLinks;
@property (nonatomic, retain) NSString* definitionInHtml;

@property (weak, nonatomic) IBOutlet UITextField *termTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoPortada;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)grabURLInBackground:(id)sender;
- (IBAction)searchButton:(id)sender;

-(void)search;

@end
