//
//  AboutViewController.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 31/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController
@synthesize logoApp;
@synthesize mailLink;
@synthesize appName;
@synthesize label;
@synthesize galappsLogo;
@synthesize slogan;
@synthesize attribution;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




-(void) setLandscape
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        logoApp.frame = CGRectMake(104, 16, 69, 69);
        appName.frame = CGRectMake(181, 32, 195, 38);
        label.frame = CGRectMake(100, 86, 280, 21);
        galappsLogo.frame = CGRectMake(115, 111, 250, 62);
        slogan.frame = CGRectMake(111, 168, 258, 21);
        mailLink.frame = CGRectMake(100, 200, 280, 21);
        attribution.frame = CGRectMake(10, 227, 460, 29);
    }
    else
    {
        logoApp.frame = CGRectMake(163, 89, 250, 250);
        appName.frame = CGRectMake(534, 185, 327, 57);
        label.frame = CGRectMake(372, 409, 280, 21);
        galappsLogo.frame = CGRectMake(387, 462, 250, 62);
        slogan.frame = CGRectMake(383, 532, 258, 21);
        mailLink.frame = CGRectMake(372, 593, 280, 21);
        attribution.frame = CGRectMake(294, 660, 460, 29);
    }
}

-(void) setPortrait
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        logoApp.frame = CGRectMake(20, 37, 69, 69);
        appName.frame = CGRectMake(105, 53, 195, 38);
        label.frame = CGRectMake(20, 137, 280, 21);
        galappsLogo.frame = CGRectMake(35, 204, 250, 62);
        slogan.frame = CGRectMake(31, 269, 258, 21);
        mailLink.frame = CGRectMake(20, 324, 280, 21);
        attribution.frame = CGRectMake(33, 379, 255, 29);
    }
    else
    {
        logoApp.frame = CGRectMake(83, 129, 250, 250);
        appName.frame = CGRectMake(359, 212, 327, 57);
        label.frame = CGRectMake(244, 475, 280, 21);
        galappsLogo.frame = CGRectMake(259, 575, 250, 62);
        slogan.frame = CGRectMake(255, 644, 258, 21);
        mailLink.frame = CGRectMake(244, 678, 280, 21);
        attribution.frame = CGRectMake(166, 911, 436, 29);
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        [self setLandscape];
    }
    else
    {
        [self setPortrait];        
    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}



//********** SCREEN TOUCHED **********
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//See if touch was inside the label
	if (CGRectContainsPoint(mailLink.frame, [[[event allTouches] anyObject] locationInView:self.view]))
	{
		//Open webpage
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:contacto@galapps.es"]];
	}
    else 
        
        if (CGRectContainsPoint(attribution.frame, [[[event allTouches] anyObject] locationInView:self.view]))
        {
            //Open webpage
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.edu.xunta.es/diccionarios/index_rag.html"]];
        }
        else 
            if (CGRectContainsPoint(galappsLogo.frame, [[[event allTouches] anyObject] locationInView:self.view]))
            {
                //Open webpage
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://galapps.es"]];
            }
}

- (void)viewDidUnload
{
    [self setMailLink:nil];
    [self setLogoApp:nil];
    [self setAppName:nil];
    [self setLabel:nil];
    [self setGalappsLogo:nil];
    [self setSlogan:nil];
    [self setAttribution:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // Return YES for supported orientations
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        // Return YES for supported orientations
        return YES;
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([self.navigationController interfaceOrientation] == UIInterfaceOrientationLandscapeLeft
        || [self.navigationController interfaceOrientation] == UIInterfaceOrientationLandscapeRight)
    {
        [self setLandscape];
    }
    else
    {
        [self setPortrait];
    }
}

@end
