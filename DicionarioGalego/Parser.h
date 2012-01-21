//
//  Parser.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 06/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>

-(void) doOnDefine:(NSString *)definition;
-(void) doOnOptions:(NSArray *)options optionsLinks:(NSArray *)optionsLinks;
-(void) doOnNotFound;
-(void) doOnError;

@end

@interface Parser : NSObject {
    NSString *word;
}

@property (nonatomic, retain) NSString* word;
@property (nonatomic, retain) id<ParserDelegate> delegate;

-(void)parse:(NSString *) text;

@end
