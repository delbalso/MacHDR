//
//  PhotoGrabberController.h
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-24.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabber.h"
#import "HDR.h"

@interface PhotoGrabberController : NSViewController {
    PhotoGrabber * grabber;
    IBOutlet NSImageView* iView;
    IBOutlet NSImageView* image1;
    IBOutlet NSImageView* image2;
    IBOutlet NSImageView* hdrImage;
    NSBitmapImageRep *  currentImage;
    IBOutlet NSButton *mybutton;
    HDR * hdr;
    //IBOutlet NSTextField *shutterSpeed;
}
//@property (nonatomic, retain) CGImageRef currentImage;
@property (nonatomic, retain) NSImageView* iView;
@property (nonatomic, retain) NSImageView* image1;
@property (nonatomic, retain) NSImageView* image2;
@property (nonatomic, retain) NSImageView* hdrImage;
@property (nonatomic, retain) PhotoGrabber* grabber;
-(IBAction)clicked:(id)sender;
-(IBAction)newShutterSpeed:(id)sender;
-(IBAction)newTrianglePeak:(id)sender;
-(IBAction)newStdDev:(id)sender;
- (IBAction) createHDR:(id)sender;
-(IBAction)saveImage1:(id)sender;
-(IBAction)saveImage2:(id)sender;

- (void)photoGrabbed:(NSImage*)image;
-(void) loadView;
- (NSImage*) imageFromCGImageRef:(CGImageRef)image;
@end
