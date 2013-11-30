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
@synthesize url = _url;
@synthesize controller = _controller;
@synthesize library = _library;
@synthesize image = _image;
@synthesize imageArray = _imageArray;

-(void)viewWillAppear:(BOOL)animated {
   // CAGradientLayer *bgLayer = [Colors blueGradient];
   // bgLayer.frame = self.view.bounds;
   // [self.view.layer insertSublayer:bgLayer atIndex:0];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"step1_background.png"]];
}

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

- (IBAction)didNext:(id)sender{
    UIStoryboard *storyBoard = self.storyboard;
    
    CalibrateController *calibrateController = [storyBoard instantiateViewControllerWithIdentifier:@"CalibrateController"];
    
    // Tester null pour choix music
    [calibrateController setMusicUrl:_url];
    
    // Tester null pour choix images (10 mini);
    [calibrateController setImageArray:_imageArray];
    
    //Stop Audio
    [_audioPlayer stop];
    
    [self presentViewController:calibrateController animated:YES completion:nil];
}


//---------------Methode Delegate ImagePickerView------------------
- (void)assetPickerControllerDidCancel:(WSAssetPickerController *)sender
{
    // Dismiss the WSAssetPickerController.
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)assetPickerController:(WSAssetPickerController *)sender didFinishPickingMediaWithAssets:(NSArray *)assets
{
    _imageArray = [NSMutableArray array];
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        //Construction du tableau dimage
        for (ALAsset *asset in assets) {
            [_imageArray addObject:[[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullResolutionImage]];
        }
        
        //Affichage de limage 1
        self.image = [_imageArray objectAtIndex:0];
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
    _url = [item valueForProperty:MPMediaItemPropertyAssetURL];
    
    [[_musicPicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_url error:&error];
    
    [_labelTitre setText:[item valueForProperty:MPMediaItemPropertyTitle]];
    
    int minute = floor([_audioPlayer duration] / 60);
    int seconde  = [_audioPlayer duration] - (minute * 60);
    [_labelDuration setText:[NSString stringWithFormat:@"%02d:%02d", minute, seconde]];
    
	
    
    [_audioPlayer play];
}
@end
