//
//  Colors.m
//  hackours
//
//  Created by Tristan Joly on 30/11/2013.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import "Colors.h"

@implementation Colors

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(44/255.0) green:(42/255.0) blue:(62/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(23/255.0)  green:(22/255.0)  blue:(35/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}
@end
