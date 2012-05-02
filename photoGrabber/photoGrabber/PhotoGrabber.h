//
//  PhotoGrabber.h
//  By Erik Rothoff Andersson <erikrothoff.com>
//

#import <Foundation/Foundation.h>
#import <QTKit/QTKit.h>
#import "UVCCameraControl.h"

@protocol PhotoGrabberDelegate <NSObject>

- (void)photoGrabbed:(NSImage*)image;

@end

@interface PhotoGrabber : NSObject {
    CVImageBufferRef currentImage;
    
    QTCaptureDevice *video;
    QTCaptureDecompressedVideoOutput *output;
    QTCaptureInput *input;
    QTCaptureSession *session;
    
    UVCCameraControl * cameraControl;
    
    id<PhotoGrabberDelegate> delegate;
    
}

@property (nonatomic, assign) id<PhotoGrabberDelegate> delegate;
@property (nonatomic, retain) NSImage * savedImage;
@property (nonatomic, retain) UVCCameraControl * cameraControl;
- (void)grabPhoto;
- (NSString*)deviceName;

@end