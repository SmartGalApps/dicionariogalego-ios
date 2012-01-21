//
//  DefineViewController.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"

@interface DefineViewController : UIViewController <ParserDelegate> {
    NSString *term;
    NSString *html;
    NSString *termToDefine;
    NSArray *options;
    NSArray *optionsLinks;
}

@property (nonatomic, retain) NSArray* options;
@property (nonatomic, retain) NSArray* optionsLinks;
@property (nonatomic, retain) NSString* termToDefine;
@property (nonatomic, retain) NSString* term;
@property (nonatomic, retain) NSString* html;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)grabURLInBackground:(id)sender;

@end
