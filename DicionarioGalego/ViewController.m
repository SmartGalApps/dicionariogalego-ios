//
//  ViewController.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "ViewController.h"
#import "DefineViewController.h"
#import "OptionsViewController.h"
#import "ASIFormDataRequest.h"
#import "Parser.h"
#import "Helper.h"
#import "HtmlDecorator.h"
#import "Reachability.h"

@implementation ViewController
@synthesize definitionInHtml;
@synthesize termTextField;
@synthesize searchButton;
@synthesize scrollView;
@synthesize logoPortada;
@synthesize label;
@synthesize optionsLinks;
@synthesize options;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
}

- (void)viewDidUnload
{
    [self setDefinitionInHtml:nil];
    [self setTermTextField:nil];
    [self setSearchButton:nil];
    [self setScrollView:nil];
    [self setOptionsLinks:nil];
    [self setOptions:nil];
    [self setLogoPortada:nil];
    [self setLabel:nil];
    [super viewDidUnload];
}

-(void) setLandscape
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        logoPortada.frame = CGRectMake(20, 76, 150, 150);
        label.frame = CGRectMake(178, 123, 280, 21);
        termTextField.frame = CGRectMake(178, 146, 243, 31);
        searchButton.frame = CGRectMake(429, 143, 37, 37);
    }
    else
    {
        logoPortada.frame = CGRectMake(185, 430, 300, 300);
        label.frame = CGRectMake(536, 544, 300, 21);
        termTextField.frame = CGRectMake(536, 581, 220, 31);
        searchButton.frame = CGRectMake(771, 578, 37, 37);
    }
}

-(void) setPortrait
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        logoPortada.frame = CGRectMake(85, 67, 150, 150);
        label.frame = CGRectMake(20, 229, 280, 21);
        termTextField.frame = CGRectMake(20, 252, 243, 31);
        searchButton.frame = CGRectMake(271, 249, 37, 37);
    }
    else
    {
        logoPortada.frame = CGRectMake(234, 147, 300, 300);
        label.frame = CGRectMake(224, 532, 300, 21);
        termTextField.frame = CGRectMake(224, 569, 265, 31);
        searchButton.frame = CGRectMake(497, 566, 37, 37);
    }
}

-(BOOL) isConnected
{
    Reachability *internetReachable = [Reachability reachabilityForInternetConnection];
    return [internetReachable isReachable];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
 * Realiza la búsqueda. Si el campo está vacío no hace nada. Si tiene espacios en blanco muestra un alertView
 */
-(void)search {
    if ([self.termTextField.text rangeOfString:@" "].location != NSNotFound) {
        UIAlertView *info = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"O termo non pode ter espazos en blanco", nil) 
                                                       message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
        [info show];
        return;
    }
    if ([self.termTextField.text length] > 0) {
        if ([self isConnected])
        {
//            [self grabURLInBackground:self];
            [self searchNouns:self];
            [Helper showAlert];
        }
        else
        {
            UIAlertView *info = [[UIAlertView alloc] 
                                 initWithTitle:nil message:NSLocalizedString(@"Necesitas conexión a internet.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
            [info show];
        }
    }
}

/*
 * Si la longitud de lo introducido es 0, desactiva el botón.
 * También es aquí donde se comprueba la longitud máxima para permitir seguir escribiendo o no
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    [self.searchButton setEnabled:newLength > 0];
    
    return (newLength > 16) ? NO : YES;
}

/*
 * Para ir a la pantalla de definiciones, o de las opciones
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"Define"])
	{
		DefineViewController *defineViewController = 
        segue.destinationViewController;
        defineViewController.htmlDefinition = self.definitionInHtml;
        defineViewController.termFromMainViewController = self.termTextField.text;
	}
    else if ([segue.identifier isEqualToString:@"ShowOptions"])
    {
        OptionsViewController *optionsViewController = 
        segue.destinationViewController;
        optionsViewController.theOptionsLinks = self.optionsLinks;
        optionsViewController.theOptions = self.options;
    }
}

/*
 * Acción del botón de buscar
 */
- (IBAction)searchButton:(id)sender {
    [self search];
}

/*
 * Realiza la petición al servidor
 */
- (IBAction)grabURLInBackground:(id)sender
{
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.realacademiagalega.org/rag_dicionario/searchNoun.do?nounTitle="];
    [urlString appendString:self.termTextField.text];
    NSString * finalURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:finalURLString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setPostValue:self.termTextField.text forKey:@"Termo"];
    [request setDelegate:self];
    [request setStringEncoding:NSUnicodeStringEncoding];
    [request startAsynchronous];
}

- (void)searchNouns:(id)sender
{
    NSMutableString *urlString = [NSMutableString string];
    [urlString appendString:@"http://www.realacademiagalega.org/rag_dicionario/searchNouns.do?term="];
    [urlString appendString:self.termTextField.text];
    NSString * finalURLString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:finalURLString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setStringEncoding:NSUnicodeStringEncoding];
    [request startAsynchronous];
}

/*
 * Método delegate cuando hubo éxito (en la petición, falta parsear)
 */
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    Parser *parser = [[Parser alloc] init];
    parser.delegate = self;
    parser.word = self.termTextField.text;
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
        NSString* html = [htmlDecorator decorate:definitions forWord:self.termTextField.text];
        
        self.definitionInHtml = html;
        [self performSegueWithIdentifier:@"Define" sender:self];
    }
}

/*
 * Si la conexión falla, sale
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [Helper dismissAlert];
    [self doOnNotFound];
}

#pragma mark - ParserDelegate methods

/*
 * Se obtuvo una definición con éxito
 */
-(void) doOnDefine:(NSString *)definition
{
    self.definitionInHtml = definition;
    [self performSegueWithIdentifier:@"Define" sender:self]; 
}

/*
 * Se obtuvieron opciones
 */
-(void) doOnOptions:(NSArray *)theOptions optionsLinks:(NSArray *)theOptionsLinks
{
    self.options = theOptions;
    self.optionsLinks = theOptionsLinks;
    [self performSegueWithIdentifier:@"ShowOptions" sender:self];
}

/*
 * No se encuentra en el diccionario. Muestra alert
 */
-(void) doOnNotFound
{
    NSMutableString *message = [[NSMutableString alloc] initWithFormat:NSLocalizedString(@"O termo \'%@\' non se atopa no dicionario", nil), self.termTextField.text];
    UIAlertView *info = [[UIAlertView alloc] 
                         initWithTitle:nil message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [info show];
}

/*
 * Hubo algún error parseando. Muestra alert
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
 * Estos métodos son para manejar el teclado virtual: ocultarlo tras buscar, hacer scroll cuando sale, etc.
 */
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat height;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        height = kbSize.width > kbSize.height ? kbSize.height : kbSize.width - 40;
    }
    else
    {
        height = kbSize.width > kbSize.height ? kbSize.height : kbSize.width + 100;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= height;
    if (!CGRectContainsPoint(aRect, self.termTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.termTextField.frame.origin.y-height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
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

/*
 * Para activar el ENTER del teclado virtual como botón de búsqueda
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.termTextField) {
        [theTextField resignFirstResponder];
    }
    [self search];
    return YES;
}
@end