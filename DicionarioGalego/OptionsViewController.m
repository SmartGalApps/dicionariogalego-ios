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
#import "Helper.h"

@implementation OptionsViewController
@synthesize options;
@synthesize theOptions;
@synthesize theOptionsLinks;
@synthesize selected;
@synthesize selectedLink;
@synthesize html;

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
    NSLog(@"--- %d", [self.theOptions count]);
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
    [Helper showAlert];
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
    parser.delegate = self;
    parser.word = self.selected;
    [parser parse:responseString];
    [Helper dismissAlert];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Helper dismissAlert];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ParserDelegate methods

-(void) doOnDefine:(NSString *)definition
{
    self.html = definition;
    [self performSegueWithIdentifier:@"DefineOption" sender:self]; 
}
-(void) doOnOptions:(NSArray *)theOptions optionsLinks:(NSArray *)theOptionsLinks
{
    
}
-(void) doOnNotFound
{
    
}
-(void) doOnError
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Houbo un erro. Por favor, volve tentalo máis tarde.", nil)];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}

#pragma end

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

@end
