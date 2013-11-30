//
//  CalibrateController.m
//  hackours
//
//  Created by Tristan Joly on 30/11/2013.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import "CalibrateController.h"

@interface CalibrateController ()

@end

@implementation CalibrateController
@synthesize tapButton = _tapButton;
@synthesize timings = _timings;
@synthesize timingsFromDate = _timingsFromDate;
@synthesize start = _start;
@synthesize tapNumber = _tapNumber;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Here");
    _timings = [[NSMutableArray alloc] initWithCapacity:0];
    _timingsFromDate = [[NSMutableArray alloc] initWithCapacity:0];
    _tapNumber = 0;
    
    // Commencer a lire musique
    
    // Start Timing
    _start = [[NSDate alloc] init];
    _start = [NSDate date];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)calculEcart{
    
    for (int i = 0; i < 10 ; i++) {
        if (i == 0) {
            [_timings addObject:[_timingsFromDate objectAtIndex:i]];
        } else {
            double a = [[_timingsFromDate objectAtIndex:i]doubleValue];
            double b = [[_timingsFromDate objectAtIndex:i -1]doubleValue];
            double result = a-b;
            [_timings addObject:[NSNumber numberWithDouble:result]];
            NSLog(@"Result : %f", result);
        }
    }
    
    double average = 0;
    for (int j = 1; j < 10 ; j++) {
        average = average + [[_timings objectAtIndex:j]doubleValue];
    }
    average = average / 9;
    NSLog(@"Average : %f", average);
}

- (IBAction)didTap:(id)sender {
    if (_tapNumber > 9) {
        NSLog(@"End");
        [self calculEcart];
    } else {
        NSTimeInterval timeIntervalWithDate = [_start timeIntervalSinceNow];
        NSNumber *a = [NSNumber numberWithDouble:timeIntervalWithDate];
        [_timingsFromDate addObject:a];
        _tapNumber ++;
    }
}
@end
