//
//  HtmlDecorator.m
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 15/11/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import "HtmlDecorator.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

@implementation HtmlDecorator

-(NSString*) decorate:(NSArray*) definitions forWord:(NSString*) word
{
    
    NSMutableString *html = [[NSMutableString alloc] initWithString:@"<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\" /></head><body>"];
    
    for (NSDictionary* definition in definitions)
    {
        NSString* htmlDescription = [definition objectForKey:@"htmlDescription"];

        [html appendString:@"<div class=\"title\"><div class=\"word\">"];
        
        [html appendString:[NSString stringWithFormat:@"%@%@",
                            [[word substringToIndex:1] uppercaseString],
                            [[word substringFromIndex:1] lowercaseString]]];
        
        if ([definitions count] > 1)
        {
            [html appendString:[NSString stringWithFormat:@"<sup class=\"miniSup\">%i</sup>", [definitions indexOfObject:definition] + 1]];
        }
        
        [html appendString:@"</div></div><div class=\"content\">"];
        [html appendString:htmlDescription];
        
        [html appendString:@"</div>"];
    }
    
    [html appendString:@"</body></html>"];
    
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
//        NSString *s3 = [NSString stringWithFormat:@"%@%d%@", @"<sup>", i, @"</sup>"];
//        [html replaceOccurrencesOfString:s3
//                              withString:@""
//                                 options:0
//                                   range:NSMakeRange(0, [html length])];
    }
    return html;
}

@end
