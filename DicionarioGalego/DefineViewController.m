//
//  DefineViewController.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "DefineViewController.h"
#import "Helper.h"
#import "Parser.h"
#import "ASIHTTPRequest.h"

@implementation DefineViewController
@synthesize webView;
@synthesize html;
@synthesize term;
@synthesize termToDefine;
@synthesize options;
@synthesize optionsLinks;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.termToDefine != nil)
    {
        [self grabURLInBackground:self];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        self.webView.opaque = NO;
        self.webView.backgroundColor = [UIColor clearColor];
        [self.webView loadHTMLString:self.html baseURL:baseURL];
    }
}


- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)grabURLInBackground:(id)sender
{
    NSURL *url = [Helper getUrl:self.termToDefine];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.delegate = self;
    parser.word = self.termToDefine;
    [parser parse:responseString];
    [Helper dismissAlert];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ParserDelegate methods

-(void) doOnDefine:(NSString *)definition
{
    self.html = definition;
    self.term = self.termToDefine;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString:self.html baseURL:baseURL]; 
}
-(void) doOnOptions:(NSArray *)theOptions optionsLinks:(NSArray *)theOptionsLinks
{
    self.options = theOptions;
    self.optionsLinks = theOptionsLinks;
    [self performSegueWithIdentifier:@"ShowOptions" sender:self];
}
-(void) doOnNotFound
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"O termo \'%@\' non se atopa no dicionario", nil), self.termToDefine];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}
-(void) doOnError
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Houbo un erro. Por favor, volve tentalo máis tarde.", nil)];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}

#pragma end

@end
