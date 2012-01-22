//
//  DefineViewController.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "DefineViewController.h"
#import "OptionsViewController.h"
#import "Helper.h"
#import "Parser.h"
#import "ASIFormDataRequest.h"

@implementation DefineViewController
@synthesize webView;
@synthesize translateButton;
@synthesize conjugateButton;
@synthesize bottomToolbar;
@synthesize htmlDefinition;
@synthesize termFromMainViewController;
@synthesize termFromIntegration;
@synthesize options;
@synthesize optionsLinks;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/*
 * Recarga el HTML. Se limpia el fondo para ponerlo con CSS
 */
-(void)reloadHtml
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString:self.htmlDefinition baseURL:baseURL];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Viene de integración, hay que buscar el término y ocultar la barra
    if (self.termFromIntegration != nil)
    {
        [self grabURLInBackground:self];
        [self.bottomToolbar setHidden:TRUE];
    }
    else
    {
        // Mostrar la barra y cargar el html.
        [self.bottomToolbar setHidden:FALSE];
        if ([Helper existsVerb:self.termFromMainViewController])
        {
            [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.translateButton,self.conjugateButton,nil] animated:TRUE];
        }
        else
        {
            [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.translateButton,nil] animated:TRUE];
        }
        [self reloadHtml];
    }
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [self setTranslateButton:nil];
    [self setConjugateButton:nil];
    [self setBottomToolbar:nil];
    [self setHtmlDefinition:nil];
    [self setTermFromMainViewController:nil];
    [self setTermFromIntegration:nil];
    [self setOptions:nil];
    [self setOptionsLinks:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 * Realiza la petición al servidor (viene de la integración)
 */
- (IBAction)grabURLInBackground:(id)sender
{
    [Helper showAlert];
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.edu.xunta.es/diccionarios/BuscaTermo.jsp"];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:self.termFromIntegration forKey:@"Termo"];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

/*
 * Botón de integración
 */
- (IBAction)translate:(id)sender {
    NSString *urlString = [[NSString alloc] initWithFormat:@"traduce://%@", self.termFromMainViewController];
    NSURL *myURL = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:myURL])
    {
        [[UIApplication sharedApplication] openURL:myURL];
    }
    else
    {
        NSString *appURLString = [[NSString alloc] initWithFormat:@"http://itunes.com/apps/tradutorgalego"];
        NSURL *appURL = [NSURL URLWithString:appURLString];
        [[UIApplication sharedApplication] openURL:appURL];
    }
}

/*
 * Botón de integración
 */
- (IBAction)conjugate:(id)sender {
    NSString *urlString = [[NSString alloc] initWithFormat:@"conxuga://%@", self.termFromMainViewController];
    NSURL *myURL = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:myURL])
    {
        [[UIApplication sharedApplication] openURL:myURL];
    }
    else
    {
        NSString *appURLString = [[NSString alloc] initWithFormat:@"http://itunes.com/apps/conxugalego"];
        NSURL *appURL = [NSURL URLWithString:appURLString];
        [[UIApplication sharedApplication] openURL:appURL];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.delegate = self;
    parser.word = self.termFromIntegration;
    [parser parse:responseString];
    [Helper dismissAlert];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ParserDelegate methods

/*
 * Encontró definición (viene de integración)
 */
-(void) doOnDefine:(NSString *)definition
{
    self.htmlDefinition = definition;
    [self reloadHtml];
}

/*
 * Encontró opciones (viene de integración)
 */
-(void) doOnOptions:(NSArray *)theOptions optionsLinks:(NSArray *)theOptionsLinks
{
    self.options = theOptions;
    self.optionsLinks = theOptionsLinks;
    [self performSegueWithIdentifier:@"ShowOptions" sender:self];
}

/*
 * No encuentra el término
 */
-(void) doOnNotFound
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"O termo \'%@\' non se atopa no dicionario", nil), self.termFromIntegration];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
    [[self navigationController] popViewControllerAnimated:TRUE];
}

/*
 * Hubo algun error
 */
-(void) doOnError
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"Houbo un erro. Por favor, volve tentalo máis tarde.", nil)];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
    [[self navigationController] popViewControllerAnimated:TRUE];
}

#pragma end

/*
 * Para ir a la pantalla de definiciones, o de las opciones
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowOptions"])
    {
        OptionsViewController *optionsViewController = 
        segue.destinationViewController;
        optionsViewController.theOptionsLinks = self.optionsLinks;
        optionsViewController.theOptions = self.options;
    }
}

@end
