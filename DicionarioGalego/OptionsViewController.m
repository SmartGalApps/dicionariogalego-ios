//
//  OptionsViewController.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 15/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "OptionsViewController.h"
#import "DefineViewController.h"
#import "ASIHTTPRequest.h"
#import "Parser.h"

@implementation OptionsViewController
@synthesize options;
@synthesize theOptions;
@synthesize theOptionsLinks;
@synthesize selected;
@synthesize selectedLink;
@synthesize html;
@synthesize loadingAlert;

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
    self.selected = [self.theOptions objectAtIndex:0];
    self.selectedLink = [self.theOptionsLinks objectAtIndex:0];
}


- (void)viewDidUnload
{
    [self setOptions:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)search:(id)sender {
    [self grabURLInBackground:self];
    [self showAlert];
}


- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.theOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.theOptions objectAtIndex:row];
} 

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.selected = [self.theOptions objectAtIndex:row];
    self.selectedLink = [self.theOptionsLinks objectAtIndex:row];
}



- (IBAction)grabURLInBackground:(id)sender
{
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.edu.xunta.es/diccionarios/"];
    NSLog(@"-------%@", self.selected);
    [urlString appendString:self.selectedLink];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.word = self.selected;
    self.html = [parser parse:responseString];
    
    [self performSegueWithIdentifier:@"DefineOption" sender:self]; 
    [self dismissAlert];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self dismissAlert];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"DefineOption"])
	{
		DefineViewController *defineViewController = 
        segue.destinationViewController;
        defineViewController.html = self.html;
        defineViewController.term = self.selected;
	}
}

-(void)showAlert {
    self.loadingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Buscando definición...", nil) 
                                                   message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [self.loadingAlert show];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = CGPointMake(self.loadingAlert.bounds.size.width / 2, self.loadingAlert.bounds.size.height - 50);
    [indicator startAnimating];
    [self.loadingAlert addSubview:indicator];
}

-(void)dismissAlert {
    [self.loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
