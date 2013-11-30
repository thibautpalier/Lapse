//
//  VideoMakerViewController.m
//  hackours
//
//  Created by Thibault Palier on 30/11/13.
//  Copyright (c) 2013 Thibault Palier. All rights reserved.
//

#import "VideoMakerViewController.h"

@interface VideoMakerViewController ()

@end

@implementation VideoMakerViewController

// Video ingredient's
@synthesize musicUrl = _musicUrl;
@synthesize imageArray = _imageArray;
@synthesize interval = _interval;

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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.mp4", @"video"];
    NSString *fullPath = [documentsDir stringByAppendingPathComponent:fileName];
    
    CGSize size = CGSizeMake(640, 480);
    [self writeImagesToMovieAtPath:fullPath withSize:size];
}

-(void) writeImagesToMovieAtPath:(NSString *) path withSize:(CGSize) size
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectoryPath error:nil];
    for (NSString *tString in dirContents)
    {
        if ([tString isEqualToString:@"video.mp4"])
        {
            [[NSFileManager defaultManager]removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documentsDirectoryPath,tString] error:nil];
            
        }
    }
    
    NSLog(@"Write Started");
    
    NSError *error = nil;
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:
                                  [NSURL fileURLWithPath:path] fileType:AVFileTypeMPEG4
                                                              error:&error];
    NSParameterAssert(videoWriter);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey,
                                   nil];
    
    
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                             assetWriterInputWithMediaType:AVMediaTypeVideo
                                             outputSettings:videoSettings];
    
    
    
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput
                                                     sourcePixelBufferAttributes:nil];
    
    NSParameterAssert(videoWriterInput);
    
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    videoWriterInput.expectsMediaDataInRealTime = YES;
    [videoWriter addInput:videoWriterInput];
    //Start a session:
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    
    //Video encoding
    
    CVPixelBufferRef buffer = NULL;
    
    //convert uiimage to CGImage.
    
    int frameCount = 0;
    
    for(int i = 0; i<[_imageArray count]; i++)
    {
        buffer = [self pixelBufferFromCGImage:[[_imageArray objectAtIndex:i] CGImage] andSize:size];
        
        BOOL append_ok = NO;
        int j = 0;
        while (!append_ok && j < 30)
        {
            if (adaptor.assetWriterInput.readyForMoreMediaData)
            {
                double result = _interval * frameCount;
                printf("Temps d'intersion  :%f \n", result);
                CMTime frameTimeInterval = CMTimeMakeWithSeconds(result, 100000);
                
                //CMTime frameTime = CMTimeMake(frameCount,(int32_t) 10);
                
                append_ok = [adaptor appendPixelBuffer:buffer withPresentationTime:frameTimeInterval];
                CVPixelBufferPoolRef bufferPool = adaptor.pixelBufferPool;
                NSParameterAssert(bufferPool != NULL);
                
                [NSThread sleepForTimeInterval:0.05];
            }
            else
            {
                printf("adaptor not ready %d, %d\n", frameCount, j);
                [NSThread sleepForTimeInterval:0.1];
            }
            j++;
        }
        if (!append_ok)
        {
            printf("error appending image %d times %d\n", frameCount, j);
        }
        frameCount++;
        CVBufferRelease(buffer);
    }
    
    [videoWriterInput markAsFinished];
    [videoWriter finishWriting];
    
    
    [_imageArray removeAllObjects];
    
    NSLog(@"Write Ended"); 
}


- (CVPixelBufferRef) pixelBufferFromCGImage:(CGImageRef)image andSize:(CGSize) size
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
 
//    CGAffineTransform transform;
//    
//    NSParameterAssert(context);
//    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
