//
//  HDR.m
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-25.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import "HDR.h"


@implementation HDR
@synthesize Image1, Image2, hdrImage,trianglePeak, stdDev;//, Image1Colour, Image2Colour;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        //[[pixcolor alloc] init];
        [self setTrianglePeak:0.5];
    }
    
    return self;
}

+(void) CGImageWriteToFile:(CGImageRef)image path:(NSString *)path {
    NSLog(@"Trying to write to file");
    CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, image, nil);
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
    }
    
    CFRelease(destination);
}

- (void)dealloc
{
    [super dealloc];
}

- (void) drawLineIm1
{
    //[Image1 setColor:(NSColor *)redColor atX:[NSNumber numberWithInt:1] y:[NSNumber numberWithInt:1]];
   for (int j = 5; j <= 500; j++) { 
        for (int i = 5; i <= 500; i++) {
            [Image1 setColor:[NSColor colorWithCalibratedRed:1 green:0.3 blue:0.3 alpha:1] atX:(NSInteger)j y:(NSInteger)i];
            //NSColor* col = [Image1 colorAtX:(NSInteger)1 y:(NSInteger)1];
            
            
        }
    }
    NSLog(@" pxl %@", [Image1 colorAtX:(NSInteger)30 y:(NSInteger)30]);
}

- (void) createHDR
{
    rgbColour Image1Colour = {0,0,0};
    rgbColour Image2Colour = {0,0,0};
    rgbColour DisplayPixel = {0,0,0};
                              
    //[Image1 setColor:(NSColor *)redColor atX:[NSNumber numberWithInt:1] y:[NSNumber numberWithInt:1]];
    [self setHdrImage:[Image2 copy]];
    for (int j = 0; j <= [Image1 pixelsHigh]; j++) { 
        for (int i = 0; i <= [Image1 pixelsWide]; i++) {
            NSColor* col = [Image1 colorAtX:(NSInteger)i y:(NSInteger)j];
            [col getRed:&(Image1Colour.red) green:&(Image1Colour.green) blue:&(Image1Colour.blue) alpha:nil];
            col = [Image2 colorAtX:(NSInteger)i y:(NSInteger)j];
            [col getRed:&(Image2Colour.red) green:&(Image2Colour.green) blue:&(Image2Colour.blue) alpha:nil];
            
            [self colourFix:&Image1Colour power:2.2];
            [self colourFix:&Image2Colour power:2.2];
            
            float C1 = [self gaussianX:((Image1Colour.red + Image1Colour.green + Image1Colour.blue)/3)];
            float C2 = [self gaussianX:((Image2Colour.red + Image2Colour.green + Image2Colour.blue)/3)];
            if ((i+j%1000)==0)
                NSLog(@"C1 is %f and C2 is %f",C1,C2);
            DisplayPixel.red = (Image1Colour.red*C1 + Image2Colour.red*C2)/(C1+C2);
            DisplayPixel.blue = (Image1Colour.blue*C1 + Image2Colour.blue*C2)/(C1+C2);
            DisplayPixel.green = (Image1Colour.green*C1 + Image2Colour.green*C2)/(C1+C2);
            
            [self colourFix:&DisplayPixel power:1/2.2];
            
            [hdrImage setColor:[NSColor colorWithCalibratedRed:DisplayPixel.red
                                                         green:DisplayPixel.green
                                                          blue:DisplayPixel.blue
                                                         alpha:1]
                           atX:(NSInteger)i y:(NSInteger)j];
            
            
            
        }
    }
}
-(float)gaussianX:(CGFloat)x
{
    //float stdDev = 1.0/3;
    float mean = trianglePeak;
    //NSLog(@" X is %f mean is %f",x,mean);
    //return stdDev;
    //return (2*stdDev*stdDev);
    //return (-(x-mean)*(x-mean)/(2*stdDev*stdDev));
    return expf(-(x-mean)*(x-mean)/(2*stdDev*stdDev));
}

- (float) triangularC:(CGFloat)value
{
    if (value==0 ||value==1){
        return .001;
    }
    if (value > trianglePeak)
    {
        return (1-value)/(1-trianglePeak);
    }
    else
    {
        return value/trianglePeak;
    }
}

- (void) colourFix:(rgbColour*)colour power:(float)exponent
{
    (*colour).red = pow((*colour).red,exponent);
    (*colour).green = pow((*colour).green,exponent);
    (*colour).blue = pow((*colour).blue,exponent);
}

@end
