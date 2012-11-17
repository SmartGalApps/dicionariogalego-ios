//
//  Parser.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "Parser.h"
#import "SBJsonParser.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
@implementation Parser

@synthesize word;
@synthesize delegate;

-(void)parse:(NSString *) text {
    NSLog(@"%@", text);
    if ([text rangeOfString:@"Este termo non se encontra no dicionario."].location != NSNotFound) {
        [self.delegate doOnNotFound];
        return;
    }
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:text error:&error];
    
    if (error) {
        [self.delegate doOnError];
        return;
    }
    HTMLNode *bodyNode = [parser body];
    HTMLNode *description = [bodyNode findChildOfClass:@"description"];
    for (HTMLNode *child in description.children) {

    }
    
    NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\" /></head><body><div class=\"title\"><div class=\"word\">"];
    [html appendString:[NSString stringWithFormat:@"%@%@",
                        [[self.word substringToIndex:1] uppercaseString],
                        [[self.word substringFromIndex:1] lowercaseString]]];
    [html appendString:@"</div></div><div class=\"content\">"];
    [html appendString:[description rawContents]];
    [html appendString:@"</div></body></html>"];
    [html replaceOccurrencesOfString:@"¿"
                          withString:@""
                             options:0
                               range:NSMakeRange(0, [html length])];
    [html replaceOccurrencesOfString:@"&iquest"
                          withString:@""
                             options:0
                               range:NSMakeRange(0, [html length])];
    for (int i = 1; i < 100; i++) {
        NSString *s = [NSString stringWithFormat:@"%@%d.%@", @"<span>", i, @"</span>"];
        NSString *s2 = [NSString stringWithFormat:@"%@%d.%@", @"<span class=\"number\">", i, @"</span>"];
        [html replaceOccurrencesOfString:s
                              withString:s2 
                                 options:0
                                   range:NSMakeRange(0, [html length])];
        NSString *s3 = [NSString stringWithFormat:@"%@%d%@", @"<sup>", i, @"</sup>"];
        [html replaceOccurrencesOfString:s3
                              withString:@"" 
                                 options:0
                                   range:NSMakeRange(0, [html length])];
    }
    [self.delegate doOnDefine:html];
    return;
}

-(NSMutableArray* )parseSearchNounsResponse:(NSString *) text
{
    SBJsonParser* parser = [[SBJsonParser alloc] init];
    
    NSMutableArray* result;
    
    NSMutableArray *elements = (NSMutableArray *) [parser objectWithString:text];
    
    if ([elements count] == 0)
    {
        return nil;
    }
    
    result = [[NSMutableArray alloc] init];
    
    for (NSDictionary* element in elements)
    {
        NSString* term = [element objectForKey:@"simpleTitle"];
        if ([term isEqualToString:self.word])
        {
            NSMutableDictionary* definition = [[NSMutableDictionary alloc] init];
            [definition setObject:[element objectForKey:@"htmlDescription"] forKey:@"htmlDescription"];
            [definition setObject:[element objectForKey:@"htmlTitle"] forKey:@"htmlTitle"];
            [result addObject:definition];
        }
    }
    return result;
    
}

@end
