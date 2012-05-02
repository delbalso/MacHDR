//
//  PhotoView.m
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-23.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import "PhotoView.h"


@implementation PhotoView
@synthesize iView;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSRect rect = NSMakeRect(0, 0, 300, 200);
        iView = [[NSImageView alloc] initWithFrame:rect];
        [iView setImageScaling:NSScaleToFit];
        [iView setImage:[NSImage imageNamed:@"picture.png"]];
        //[[[NSImage imageNamed:@"picture.png"] TIFFRepresentation] writeToFile:@"/Users/michaeldelbalso/Desktop/Result.tif" atomically:YES];

        //[self setImageview:imageview];
        [self addSubview:iView];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}



@end
