//
//  ALRadialButton.m
//  ALRadial
//
//  Created by andrew lattis on 12/10/14.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import "ALRadialButton.h"

@implementation ALRadialButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)willAppear {
	//rotate the button upsidedown so its right side up after the 180 degree rotation while its moving out
	[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, 180/180*M_PI)];
	
	self.alpha = 1.0;
	
	[UIView animateWithDuration:.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
		
		//this animation rotates the button 180 degree's, and moves the center point to the end of the "string"
		[self setCenter:self.bouncePoint];
		[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, 0/180*M_PI)];
		
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:.15f animations:^{
			//a little bounce back at the end
			[self setCenter:self.centerPoint];
		}];
		
	}];
}


- (void)willDisappear {
	[UIView animateWithDuration:.15f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
		
		//first do the rotate in place animation
		[self.imageView setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, -(180/180*M_PI))];
	
	} completion:^(BOOL finished) {
		
		[UIView animateWithDuration:.25f animations:^{
			//now move it back to the origin button
			[self setCenter:self.originPoint];
			
		} completion:^(BOOL finished) {
			//finally hide the button and tell the delegate we are done so it can cleanup memory
			self.alpha = 0.0f;
			[self.delegate buttonDidFinishAnimation:self];
		}];
		
	}];
}

@end
