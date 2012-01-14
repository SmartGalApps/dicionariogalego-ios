//
//  Parser.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "Parser.h"
#import "HTMLParser.h"
#import "HTMLNode.h"

@implementation Parser

@synthesize word;


-(NSString *)parse:(NSString *) text {
    if ([text rangeOfString:@"Non se atopou o termo."].location != NSNotFound) {
        return nil;
    }
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];

    if (error) {
        NSLog(@"Error: %@", error);
        return @"<html><head><body>yeha</body></html>";
    }
    HTMLNode *bodyNode = [parser body];
    
    NSArray *linkNodes = [bodyNode findChildTags:@"a"];
    NSMutableArray* options = [[NSMutableArray alloc] init];
    for (HTMLNode *linkNode in linkNodes) {
        NSString* href = [linkNode getAttributeNamed:@"href"];
        if ([href rangeOfString:@"ListaDefinicion"].location != NSNotFound) {
            [options addObject:href];
        }
    }
    // Hay opciones
    for (NSString *href in options) {
        NSLog(@"%@", href);
    }
    // No hay opciones, está la definición
    if ([options count] == 0) {
        NSArray *fontNodes = [bodyNode findChildTags:@"font"];
        // Sólo debe haber uno, el que nos interesa
        for (HTMLNode *fontNode in fontNodes) {
            NSString* size = [fontNode getAttributeNamed:@"size"];
            if ([size isEqualToString:@"2"]) {
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                BOOL firstTerm = TRUE;
                BOOL isVerb = FALSE;
                for (HTMLNode *child in [fontNode children]) {
                    NSMutableString *tagName = [[NSMutableString alloc] initWithString:[child tagName]];
                    if ([tagName isEqualToString:@"br"]) {
                    }
                    if (!isVerb && [tagName isEqualToString:@"i"]) {
                        if ([[child contents] rangeOfString:@"v.i."].location != NSNotFound ||
                            [[child contents] rangeOfString:@"v.t."].location != NSNotFound ||
                            [[child contents] rangeOfString:@"v.p."].location != NSNotFound) {
                            isVerb = TRUE;
                        }
                    }
                    if ([tagName isEqualToString:@"b"]) {
                        // Si es un número
                        if ([f numberFromString: [child contents]] != nil) {
                            [child setAttributeNamed:@"class" value:@"number"];
                        }
                        else if ([[child contents] caseInsensitiveCompare:self.word] == NSOrderedSame) {
                            if (!firstTerm) {
                                
                            }
                            else {
                                firstTerm = FALSE;
                            }
                        }
                    }
                }
                
                NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\" /></head><body><div class=\"title\"><div class=\"word\">"];
                [html appendString:self.word];
                [html appendString:@"</div></div><div class=\"content\">"];
                [html appendString:[fontNode rawContents]];
                [html appendString:@"</div></body></html>"];
                [html stringByReplacingOccurrencesOfString:@"¿" withString:@""];
                [html stringByReplacingOccurrencesOfString:@"<font face=\"Arial, Helvetica, sans-serif\">" withString:@""];
                [html stringByReplacingOccurrencesOfString:@"<font face=\"Zapf Dingbats\" size=\"2\">" withString:@""];
                [html stringByReplacingOccurrencesOfString:@"<font size=\"[0-9]\">" withString:@""];
                [html stringByReplacingOccurrencesOfString:@"</font>" withString:@""];
                [html stringByReplacingOccurrencesOfString:@"<font size=\"2\">" withString:@""];
                [html stringByReplacingOccurrencesOfString:@"&iquest" withString:@""];
                NSLog(@"%@", html);
                return html;
            }
        }
        
    }
    return text;
}

@end
