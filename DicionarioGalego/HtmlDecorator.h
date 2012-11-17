//
//  HtmlDecorator.h
//  DicionarioGalego
//
//  Created by Xurxo Méndez Pérez on 15/11/12.
//  Copyright (c) 2012 ninguna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlDecorator : NSObject

-(NSString*) decorate:(NSArray*) definitions forWord:(NSString*) word;

@end
