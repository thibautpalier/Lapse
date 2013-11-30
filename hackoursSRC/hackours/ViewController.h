//
//  ViewController.h
//  hackours
//
//  Created by Thibault Palier on 30/11/13.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSAssetPicker.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate, WSAssetPickerControllerDelegate>

//output
@property (strong, nonatomic) NSMutableArray *imageArray;


//Vue Conteneur
@property (strong, nonatomic) IBOutlet UIView *matserView;
@property (weak, nonatomic) IBOutlet UIView *photosView;
@property (weak, nonatomic) IBOutlet UIView *musicView;

//VuePhotosView
@property (weak, nonatomic) IBOutlet UIButton *buttonAjouter;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

//Vue MusicView
@property (weak, nonatomic) IBOutlet UIButton *buttonAjouterMusic;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitre;
@property (weak, nonatomic) IBOutlet UILabel *labelDuration;


//PickerView
@property (nonatomic, retain) ALAssetsLibrary *library;
@property (nonatomic, retain) WSAssetPickerController *controller;
@property (nonatomic, retain) MPMediaPickerController *musicPicker;

//AudioPlayer
@property AVAudioPlayer *audioPlayer;

//Methodes PhotosView
- (IBAction)didAjouter:(UIButton *)sender;

//Methode MusicView
- (IBAction)didAjouterMusic:(UIButton *)sender;
- (IBAction)didPlay:(UIButton *)sender;

- (IBAction)didNext:(id)sender;


@end
