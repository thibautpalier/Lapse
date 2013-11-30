//
//  ViewController.m
//  hackours
//
//  Created by Thibault Palier on 30/11/13.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import "ViewController.h"
#import "CalibrateController.h"

@interface ViewController ()

@property UIBarButtonItem* doneButton;

@property int IMAGE_COUNTER;

@end

@implementation ViewController

@synthesize matserView = _matserView;
@synthesize photosView = _photosView;
@synthesize musicView = _musicView;
@synthesize musicPicker = _musicPicker;
@synthesize buttonAjouter = _buttonAjouter;
@synthesize imageView = _imageView;
@synthesize audioPlayer = _audioPlayer;
@synthesize labelTitre = _labelTitre;
@synthesize progressView = _progressView;
@synthesize controller = _controller;
@synthesize library = _library;
@synthesize image = _image;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //initialisation imagepicker
    _library = [[ALAssetsLibrary alloc] init];
    _controller = [[WSAssetPickerController alloc] initWithAssetsLibrary:_library];
    [_controller setDelegate:self];
    
    //Initialisation musicPicker
    _musicPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    [_musicPicker setDelegate:self];
    [_musicPicker setAllowsPickingMultipleItems:FALSE];
    
    //Initialisation audioPlayer
    _audioPlayer = [[AVAudioPlayer alloc] init];
    
    //Initialisation progressbar
    [_progressView setProgress:0.0];
}

//Ptogression de la bar de lecture
- (void)onTick:(NSTimer *)timer{
    [_progressView setProgress:[_audioPlayer currentTime]/[_audioPlayer duration] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--------------------Action des controlleur------------------

- (IBAction)didAjouter:(UIButton *)sender {
    [self presentViewController:_controller animated:YES completion:NULL];
}

- (IBAction)didAjouterMusic:(UIButton *)sender {
    [self presentViewController:_musicPicker animated:YES completion:nil];
}

- (IBAction)didPlay:(UIButton *)sender {
    if([_audioPlayer isPlaying]){
        [_audioPlayer pause];
    }
    else{
        [_audioPlayer play];
    }
}


//---------------Methode Delegate ImagePickerView------------------
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    // Dismiss the WSAssetPickerController.
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    
    
    /*
    for (ALAsset *asset in assets) {
        image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullResolutionImage];
    }
     */
    
    //NSString *imgUrl = [[assets objectAtIndex:1] valueForProperty:ALAssetPropertyURLs];
    
    //_image = [[UIImage alloc] initWithCGImage:[[[assets objectAtIndex:0] defaultRepresentation] fullScreenImage]];
    
    /*CGImageRef images = [[[assets objectAtIndex:0] defaultRepresentation] fullScreenImage];
    if (images){
        _image = [UIImage imageWithCGImage:images];
    }*/
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        self.image = [[UIImage alloc] initWithCGImage:[[[assets objectAtIndex:0] defaultRepresentation] fullResolutionImage]];
        [self.imageView setImage:self.image];
    }];
    
}

//----------------Methode delegate Music PickerView
- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    
    NSError *error;
    
    //Timer pour la barre de progression
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval: 0.1f target: self selector:@selector(onTick:) userInfo:nil repeats:TRUE];
    
    
    //Charge la music choisi dans le lecteur
    MPMediaItem *item = [[mediaItemCollection items] objectAtIndex:0];
    NSURL *url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    [[_musicPicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    [_labelTitre setText:[item valueForProperty:MPMediaItemPropertyTitle]];
    
    int minute = floor([_audioPlayer duration] / 60);
    int seconde  = [_audioPlayer duration] - (minute * 60);
    [_labelDuration setText:[NSString stringWithFormat:@"%02d:%02d", minute, seconde]];
    
	
    
    [_audioPlayer play];
}

//---------------Methode delegate audioplayer-------------

//---------------Methode Pour listener button-------------
- (IBAction)didNext:(id)sender{
    UIStoryboard *storyBoard = self.storyboard;
    
    CalibrateController *calibrateController = [storyBoard instantiateViewControllerWithIdentifier:@"CalibrateController"];
    [self presentViewController:calibrateController animated:YES completion:nil];
}



@end
