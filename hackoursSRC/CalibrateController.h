//
//  CalibrateController.h
//  hackours
//
//  Created by Tristan Joly on 30/11/2013.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalibrateController : UIViewController

//Properties
@property (weak, nonatomic) IBOutlet UIButton *tapButton;
@property (strong, nonatomic) NSMutableArray *timings;
@property (strong, nonatomic) NSMutableArray *timingsFromDate;
@property (strong, nonatomic) NSDate *start;
@property (nonatomic) int tapNumber;

// Methods
- (void)calculEcart;
- (IBAction)didTap:(id)sender;
@end
