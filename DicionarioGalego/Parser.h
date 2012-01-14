//
//  Parser.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject {
    NSString *word;
}

@property (nonatomic, retain) NSString* word;

-(NSString *)parse:(NSString *) text;

@end
