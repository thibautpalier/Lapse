//
//  VideoMakerViewController.h
//  hackours
//
//  Created by Thibault Palier on 30/11/13.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoMakerViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *imageArray;
@property (weak, nonatomic) NSURL *musicUrl;
@property double interval;

@end
