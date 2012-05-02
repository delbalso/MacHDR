//
//  PhotoGrabberController.m
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-24.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import "PhotoGrabberController.h"


@implementation PhotoGrabberController
@synthesize grabber,/*currentImage,*/iView,image1, image2,hdrImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       
    }
    
    return self;
}

- (void) awakeFromNib
{
    self = [super init];
    if (self) {
        [iView setImage:[NSImage imageNamed:@"picture.png"]];
        grabber = [[PhotoGrabber alloc] init]; 
        grabber.delegate = (id)self;
        [grabber grabPhoto];
        hdr = [[HDR alloc] init];
        //currentImage = [[NSBitmapImageRep alloc] init];
        [self setView:iView];
    }
}

-(void) loadView
{
    [super loadView];
    //NSRect rect = NSMakeRect(10, 10, 200, 100);
    //[[self view] initWithFrame:rect];
    [self setView:iView];
}
- (void)dealloc
{
    [super dealloc];
}

-(IBAction)clicked:(id)sender
{
    NSLog(@"Refresh pressed");
    [grabber grabPhoto];
    NSLog(@"Exposure is %f",[grabber.cameraControl getExactExposure]);
}
-(IBAction)newShutterSpeed:(id)sender
{
    NSLog(@"Textfield pressed");
    [grabber.cameraControl setExactExposure:[sender floatValue]];
    NSLog(@"Exposure is %f",[grabber.cameraControl getExactExposure]);
}
-(IBAction)newTrianglePeak:(id)sender
{
    NSLog(@"New TriangePeak");
    [hdr setTrianglePeak:[sender floatValue]];
    NSLog(@"Exposure is %f",[grabber.cameraControl getExactExposure]);
}

-(IBAction)newStdDev:(id)sender
{
    NSLog(@"New StdDev");
    [hdr setStdDev:[sender floatValue]];
    NSLog(@"StdDev is %f",[grabber.cameraControl getExactExposure]);
}

- (void)photoGrabbed:(NSImage*)image
{
    if (image==nil)
    {
        NSLog(@"image is NIL!");
        return;
    }
    //currentImage =[image CGImageForProposedRect:nil context:nil hints:nil];
    currentImage = [[image representations] objectAtIndex: 0];
    [iView setImage:image];
    [[image TIFFRepresentation] writeToFile:@"/Users/michaeldelbalso/Desktop/Result1.tif" atomically:YES];
}
-(IBAction)saveImage1:(id)sender
{ 
    NSLog(@"Saving Image1");
    [hdr setImage1:[currentImage copy]];
    //[hdr drawLineIm1];
    //[HDR CGImageWriteToFile:[hdr Image1] path:@"/Users/michaeldelbalso/Desktop/Image1.png"];
    NSImage *im = [[[NSImage alloc] init] autorelease];
    [im addRepresentation:[hdr Image1]];
    [image1 setImage:im];
}
-(IBAction)saveImage2:(id)sender
{
    NSLog(@"Saving Image2");
    [hdr setImage2:[currentImage copy]];
    //[image2 setImage:[self imageFromCGImageRef:[hdr Image2]]];
    NSImage *im = [[[NSImage alloc] init] autorelease];
    [im addRepresentation:[hdr Image2]];
    [image2 setImage:im];
}
- (IBAction) createHDR:(id)sender
{
    NSLog(@"Creating HDR Image");
    [hdr createHDR];
    NSImage *im = [[[NSImage alloc] init] autorelease];
    [im addRepresentation:[hdr hdrImage]];
    [hdrImage setImage:im];
}
- (NSImage*) imageFromCGImageRef:(CGImageRef)image
{ 
    NSRect imageRect = NSMakeRect(0.0, 0.0, 0.0, 0.0); 
    CGContextRef imageContext = nil; 
    NSImage* newImage = nil; // Get the image dimensions. 
    imageRect.size.height = CGImageGetHeight(image); 
    imageRect.size.width = CGImageGetWidth(image); 
    
    // Create a new image to receive the Quartz image data. 
    newImage = [[NSImage alloc] initWithSize:imageRect.size]; 
    [newImage lockFocus]; 
    
    // Get the Quartz context and draw. 
    imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];    
    CGContextDrawImage(imageContext, *(CGRect*)&imageRect, image); [newImage unlockFocus]; 
    return newImage;
}
@end
