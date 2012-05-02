//
//  HDR.h
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-25.
//  Copyright 2012 University of Toronto. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <math.h>

typedef struct {
	CGFloat red, green, blue;
} rgbColour;

@interface HDR : NSObject {
    NSBitmapImageRep *Image1;
    NSBitmapImageRep *Image2;
    NSBitmapImageRep *hdrImage;
    IBOutlet NSColor * pixcolor;
    CGFloat trianglePeak;
    CGFloat stdDev;
}

@property (nonatomic,retain) NSBitmapImageRep * Image1;
@property (nonatomic,retain) NSBitmapImageRep * Image2;
@property (nonatomic,retain) NSBitmapImageRep * hdrImage;
@property (nonatomic) CGFloat trianglePeak;
@property (nonatomic) CGFloat stdDev;
- (void) drawLineIm1;
- (void) colourFix:(rgbColour*)colour power:(float)exponent;
- (void) createHDR;
- (float) triangularC:(CGFloat)value;
+(void) CGImageWriteToFile:(CGImageRef)image path:(NSString *)path;
-(float)gaussianX:(CGFloat)x; 

@end
