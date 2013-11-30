//
//  ViewController.m
//  hackours
//
//  Created by Thibault Palier on 30/11/13.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property UIBarButtonItem* doneButton;

@property int IMAGE_COUNTER;

@end

@implementation ViewController

@synthesize matserView = _matserView;
@synthesize photosView = _photosView;
@synthesize musicView = _musicView;
@synthesize doneButton = _doneButton;
@synthesize imgPicker = _imgPicker;
@synthesize musicPicker = _musicPicker;
@synthesize buttonAjouter = _buttonAjouter;
@synthesize imageView = _imageView;
@synthesize audioPlayer = _audioPlayer;
@synthesize labelTitre = _labelTitre;
@synthesize progressView = _progressView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialization imgPicker:
    _imgPicker = [[UIImagePickerController alloc] init];
    [_imgPicker setAllowsEditing:YES];
    [_imgPicker setDelegate:self];
    [_imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
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
    [self presentViewController:_imgPicker animated:YES completion:nil];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask ,YES);
    NSString* documentsPath = [paths objectAtIndex:0];
    NSString* dataFile = [documentsPath stringByAppendingPathComponent:@"UserCustomPotraitPic1.jpg"];
    
    NSData *potraitImgData = [NSData dataWithContentsOfFile:dataFile];
    //backgroundImagePotrait = [UIImage imageWithData:potraitImgData];
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

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"Inside navigationController ...");
    if (!_doneButton)
    {
        _doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveImagesDone:)];
    }
    
    viewController.navigationItem.rightBarButtonItem = _doneButton;
}

- (IBAction)saveImagesDone:(id)sender
{
    NSLog(@"saveImagesDone ...");
    //Fermer le pickerView
    [[_imgPicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage : (UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    _IMAGE_COUNTER = _IMAGE_COUNTER + 1;
    NSLog(@"didFinishPickingImage ...");
    _imageView.image = image;
    
    // Get the data for the image
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
    
    
    // Give a name to the file
    NSString* incrementedImgStr = [NSString stringWithFormat: @"img%d.jpg", _IMAGE_COUNTER];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:incrementedImgStr];
    
    [imageData writeToFile:fullPathToFile2 atomically:NO];
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



@end
