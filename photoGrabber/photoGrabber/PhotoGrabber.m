//
//  PhotoGrabber.m
//  By Erik Rothoff Andersson <erikrothoff.com>
//

#import "PhotoGrabber.h"


@implementation PhotoGrabber

@synthesize delegate, savedImage,cameraControl;

- (id)init
{
    if ( (self = [super init]) )
    {
        NSError *error = nil;
        // Acquire a device, we will also have objects for getting input
        // from the device, and another for output
        video = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
        BOOL success = [video open:&error];
        
        if ( ! success || error )
        {
            NSLog(@"Did not succeed in acquire: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        
        // QTCaptureDeviceInput is the object that will use the
        // device as input, i.e. handle the photo-taking
        input = [[QTCaptureDeviceInput alloc] initWithDevice:video];
        
        // Session handles the input and output of both objects
        session = [[QTCaptureSession alloc] init];
        
        // Add our input object as input for this particular session
        // (the code is pretty self-explanatory)
        success = [session addInput:input error:&error];
        
        if ( ! success || error )
        {
            NSLog(@"Did not succeed in connecting input to session: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        
        // Create an object for outputing the video
        // The input will tell the session object that it has taken
        // some data, which will in turn send this to the output
        // object, which has a delegate that you defined
        output = [[QTCaptureDecompressedVideoOutput alloc] init];
        
        // This is the delegate. Note the
        // captureOutput:didOutputVideoFrame...-method of this
        // object. That is the method which will be called when 
        // a photo has been taken.
        [output setDelegate:self];
        
        // Add the output-object for the session
        success = [session addOutput:output error:&error];
        
        if ( ! success || error )
        {
            NSLog(@"Did succeed in connecting output to session: %d", success);
            NSLog(@"Error: %@", [error localizedDescription]);
            return nil;
        }
        
        // Because the input stream is video we will be getting
        // many frames after each other, we take the first one
        // we get and store it, and don't accept any more after
        // we already have one
        currentImage = nil;
        
        // Ok, this might be all kinds of wrong, but it was the only way I found to map a 
        // QTCaptureDevice to a IOKit USB Device. The uniqueID method seems to always(?) return 
        // the locationID as a HEX string in the first few chars, but the format of this string 
        // is not documented anywhere and (knowing Apple) might change sooner or later.
        //
        // In most cases you'd be probably better of using the UVCCameraControls
        // - (id)initWithVendorID:(long) productID:(long) 
        // method instead. I.e. for the Logitech QuickCam9000:
        // cameraControl = [[UVCCameraControl alloc] initWithVendorID:0x046d productID:0x0990];
        //
        // You can use USB Prober (should be in /Developer/Applications/Utilities/USB Prober.app) 
        // to find the values of your camera.
        
        UInt32 locationID = 0;
        sscanf( [[video uniqueID] UTF8String], "0x%8x", &locationID );
        cameraControl = [[UVCCameraControl alloc] initWithLocationID:locationID];
        //cameraControl = [[UVCCameraControl alloc] initWithVendorID:0x05ac productID:0x8507];
        NSLog(@"Exposure is %f",[cameraControl getExactExposure]);
        [cameraControl setAutoExposure:NO];
        [cameraControl setExactExposure:100]; //Set AutoExposure to NO
        NSLog(@"Exposure is %f",[cameraControl getExposure]);
        [cameraControl setAutoWhiteBalance:NO];
        
        

    }
    return self;
}

// This is the method to use when you want to initialize a grab
- (void)grabPhoto
{
    
    [session startRunning];
    
}

// The device-name will most likely be "Built-in iSight camera"
- (NSString*)deviceName
{
    return [video localizedDisplayName];
}

// QTCapture delegate method, called when a frame has been loaded by the camera
- (void)captureOutput:(QTCaptureOutput *)captureOutput didOutputVideoFrame:(CVImageBufferRef)videoFrame withSampleBuffer:(QTSampleBuffer *)sampleBuffer fromConnection:(QTCaptureConnection *)connection
{
    // If we already have an image we should use that instead
    //if ( currentImage ) return;
    
    // Retain the videoFrame so it won't disappear
    // don't forget to release!
    CVBufferRetain(videoFrame);
    
    
    // The Apple docs state that this action must be synchronized
    // as this method will be run on another thread
    @synchronized (self) {
        currentImage = videoFrame;
    }
    
    // As stated above, this method will be called on another thread, so
    // we perform the selector that handles the image on the main thread
    [self performSelectorOnMainThread:@selector(saveImage) withObject:nil waitUntilDone:NO];
}

// Called from QTCapture delegate method
- (void)saveImage
{
    // Stop the session so we don't record anything more
    [session stopRunning];
    
    // Convert the image to a NSImage with JPEG representation
    // This is a bit tricky and involves taking the raw data
    // and turning it into an NSImage containing the image
    // as JPEG
    NSCIImageRep *imageRep = [NSCIImageRep imageRepWithCIImage:[CIImage imageWithCVImageBuffer:currentImage]];
    
    NSImage *image = [[NSImage alloc] initWithSize:[imageRep size]];
    [image addRepresentation:imageRep];
    
    NSData *bitmapData = [image TIFFRepresentation];
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:bitmapData];
    NSData *imageData = [bitmapRep representationUsingType:NSJPEGFileType properties:nil];
    
    [image release];
    image = [[NSImage alloc] initWithData:imageData];
    
    // Call delegate callback
    if ( [self.delegate respondsToSelector:@selector(photoGrabbed:)] )
        [self.delegate photoGrabbed:image];
    
    // Clean up after us
    [image release];
    CVBufferRelease(currentImage);
    currentImage = nil;
}

- (void)dealloc
{
    self.delegate = nil;
    
    // Just close/turn off everything if it's running
    if ( [session isRunning] )
        [session stopRunning];
    
    if ( [video isOpen] )
        [video close];
    
    // Remove input/output
    [session removeInput:input];
    [session removeOutput:output];
    
    [input release];
    [session release];
    [output release];
    [super dealloc];
}

@end