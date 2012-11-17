//
//  Helper.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 21/01/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+(NSURL *) getUrl:(NSString *)term;

+(NSURL *) searchNouns:(NSString *)term;

+(void)showAlert;
+(void)dismissAlert;

+(BOOL)existsVerb:(NSString* ) verb;

@end
