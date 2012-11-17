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
#import "Reachability.h"
#import "HtmlDecorator.h"

@implementation DefineViewController
@synthesize webView;
@synthesize translateButton;
@synthesize conjugateButton;
@synthesize bottomToolbar;
@synthesize space1;
@synthesize space2;
@synthesize htmlDefinition;
@synthesize fondo;
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


-(BOOL) isConnected
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    return [internetReachable isReachable];
}



-(void) setLandscape
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        space1.width = 180;
//        space2.width = 150;
//    }
//    else
//    {
//        space1.width = 300;
//        space2.width = 300;
//    }
}

-(void) setPortrait
{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//    {
//        space1.width = 105;
//        space2.width = 65;
//    }
//    else
//    {
//        space1.width = 300;
//        space2.width = 300;
//    }
}

/*
 * Recarga el HTML. Se limpia el fondo para ponerlo con CSS
 */
-(void)reloadHtml
{
    [Helper dismissAlert];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView loadHTMLString:self.htmlDefinition baseURL:baseURL];
}
#pragma mark - View lifecycle


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Viene de integración, hay que buscar el término y ocultar la barra
    if (self.termFromIntegration != nil)
    {
        if ([self isConnected])
        {
//            [self grabURLInBackground:self];
            [self searchNouns:self];
            [self.bottomToolbar setHidden:TRUE];
        }
        else
        {
            UIAlertView *info = [[UIAlertView alloc] 
                                 initWithTitle:nil message:NSLocalizedString(@"Necesitas conexión a internet.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
            [info show];
        }
    }
    else
    {
        // Mostrar la barra y cargar el html.
        [self.bottomToolbar setHidden:FALSE];
        if ([Helper existsVerb:self.termFromMainViewController])
        {
            [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.space1, self.conjugateButton,self.translateButton,self.space1,nil] animated:TRUE];
        }
        else
        {
            [self.bottomToolbar setItems:[[NSArray alloc] initWithObjects:self.space1, self.translateButton,self.space1,nil] animated:TRUE];
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
    [self setFondo:nil];
    [self setSpace1:nil];
    [self setSpace2:nil];
    [super viewDidUnload];
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

- (void)searchNouns:(id)sender
{
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.realacademiagalega.org/rag_dicionario/searchNouns.do?term="];
    [urlString appendString:self.termFromIntegration];
    NSString * finalURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:finalURLString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setStringEncoding:NSUnicodeStringEncoding];
    [request startAsynchronous];
}

/*
 * Botón de integración
 */
- (IBAction)translate:(id)sender {
    NSString* encodedText = [self.termFromMainViewController stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [[NSString alloc] initWithFormat:@"traduce://%@", encodedText];
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
    NSString* encodedText = [self.termFromMainViewController stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [[NSString alloc] initWithFormat:@"conxuga://%@", encodedText];
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
//    // Use when fetching text data
//    NSString *responseString = [request responseString];
//    
//    Parser *parser = [[Parser alloc] init];
//    parser.delegate = self;
//    parser.word = self.termFromIntegration;
//    [parser parse:responseString];
//    [Helper dismissAlert];
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.delegate = self;
    parser.word = self.termFromIntegration;
    NSMutableArray* definitions = [parser parseSearchNounsResponse:responseString];
    [Helper dismissAlert];
    
    if (definitions == nil)
    {
        [self doOnNotFound];
        return;
    }
    else
    {
        HtmlDecorator* htmlDecorator = [[HtmlDecorator alloc] init];
        NSString* html = [htmlDecorator decorate:definitions forWord:self.termFromIntegration];
        
        self.htmlDefinition = html;
        [self reloadHtml];
    }
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



-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        [self setLandscape];
    }
    else
    {
        [self setPortrait];
    }
}

@end
