//
//  photoGrabberAppDelegate.h
//  photoGrabber
//
//  Created by Michael Del Balso on 12-03-23.
//  Copyright 2012 University of Toronto. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PhotoGrabberController.h"

@interface photoGrabberAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    //PhotoGrabberController * photoGrabberController;
    
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *view;

@end
