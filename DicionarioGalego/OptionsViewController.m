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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selected = [self.theOptions objectAtIndex:0];
    self.selectedLink = [self.theOptionsLinks objectAtIndex:0];
    [Helper dismissAlert];
}


- (void)viewDidUnload
{
    [self setOptions:nil];
    [self setTheOptions:nil];
    [self setTheOptionsLinks:nil];
    [self setSelected:nil];
    [self setSelectedLink:nil];
    [self setHtml:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 * Realiza la petición al servidor cuando el usuario escoge una opción
 */
- (IBAction)grabURLInBackground:(id)sender
{
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.edu.xunta.es/diccionarios/"];
    [urlString appendString:self.selectedLink];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

/*
 * La petición tuvo éxito (es enlace directo, no tiene que encontrar el término)
 */
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

/*
 * Hubo algún error en la petición
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Helper dismissAlert];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Lanza la petición al servidor
 */
- (IBAction)search:(id)sender {
    [self grabURLInBackground:self];
    [Helper showAlert];
}

#pragma mark - UIPickerView delegate and datasource

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

#pragma mark end


#pragma mark - ParserDelegate methods

/*
 * El parser encontró la definición
 */
-(void) doOnDefine:(NSString *)definition
{
    self.html = definition;
    [self performSegueWithIdentifier:@"DefineOption" sender:self]; 
}

/*
 * No se puede dar
 */
-(void) doOnOptions:(NSArray *)theOptions optionsLinks:(NSArray *)theOptionsLinks
{
    
}

/*
 * No se puede dar
 */
-(void) doOnNotFound
{
    
}

/*
 * Hubo algún error. Muestra alert
 */
-(void) doOnError
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Houbo un erro. Por favor, volve tentalo máis tarde.", nil)];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}

#pragma end

/*
 * Lanza la pantalla de definición
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"DefineOption"])
	{
		DefineViewController *defineViewController = 
        segue.destinationViewController;
        defineViewController.htmlDefinition = self.html;
        defineViewController.termFromIntegration = self.selected;
	}
}

@end
