//
//  DefineViewController.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefineViewController : UIViewController {
    NSString *term;
    NSString *html;
}

@property (nonatomic, retain) NSString* term;
@property (nonatomic, retain) NSString* html;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
