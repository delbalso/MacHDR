//
//  PhotoView.h
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-23.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabber.h"

@interface PhotoView : NSImageView {
    NSImageView * iView;
    NSImage * savedimage;
    
}
//@property (nonatomic, retain) NSButton *mybutton;
//@property (nonatomic, retain) NSTextField *shutterSpeed;
@property (nonatomic, retain) NSImageView *iView;

@end
