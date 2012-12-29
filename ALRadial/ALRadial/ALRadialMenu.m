//
//  ALRadialMenu.m
//  ALRadial
//
//  Created by andrew lattis on 12/10/14.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import "ALRadialMenu.h"
#import <QuartzCore/QuartzCore.h>

@implementation ALRadialMenu


//FIXME: sanity/dedup this
- (void)itemsWillAppearFromButton:(UIButton *) button inView:(UIView *)view {
	if ([self.items count]) {
		//the items are already displayed, we shouldn't be here
		return;
	}

	int itemCount = [self.delegate numberOfItemsInRadialMenu:self];
	if (itemCount == 0) {
		//without any items to display there's nothing todo
		return;
	}
	
	NSMutableArray *mutablePopups = [[NSMutableArray alloc] init];

	
	int arc = [self.delegate arcSizeForRadialMenu:self];
	if (arc == 0) {
		NSLog(@"default arc");
		arc = 90;
	}
	
	int radius = [self.delegate arcRadiusForRadialMenu:self];
	if (radius < 1) {
		NSLog(@"default radius");
		radius = 80;
	}

  int start = 0;
  if ([self.delegate respondsToSelector:@selector(arcStartForRadialMenu:)]) {
      start = [self.delegate arcStartForRadialMenu:self];
  }
	
	
	
	float angle = arc/itemCount;
	int centerX = button.center.x;
	int centerY = button.center.y;
	CGPoint origin = CGPointMake(centerX, centerY);
	
	int currentItem = 1;
	ALRadialButton *popupButton;
	while (currentItem <= itemCount) {
		float radians = (angle * (currentItem - 1) + start) * (M_PI/180);
		
		int x = round (centerX + radius * cos(radians));
		int y = round (centerY + radius * sin(radians));
		//extra space to have the items bounce back at the end of the "spring"
		int extraX = round (centerX + (radius*1.07) * cos(radians));
		int extraY = round (centerY + (radius*1.07) * sin(radians));
		
		
		CGRect frame = button.frame;
		//FIXME: make height/width ivars with a delegate to resize
		frame.size.height = 25;
		frame.size.width = 25;
		frame.origin.x = centerX;
		frame.origin.y = centerY;
		
		CGPoint final = CGPointMake(x, y);
		CGPoint bounce = CGPointMake(extraX, extraY);
		
		
		popupButton = [[ALRadialButton alloc] initWithFrame:frame];
		popupButton.alpha = 0.0f;
		popupButton.centerPoint = final;
		popupButton.bouncePoint = bounce;
		popupButton.originPoint = origin;
		
		
		//get the image from the deletate and set it on the button
		[popupButton setImage:[self.delegate radialMenu:self imageForIndex:currentItem] forState:UIControlStateNormal];
		//set the button tag, delegate, and target action
		popupButton.tag = currentItem;
		popupButton.delegate = self;
		[popupButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		
		[view insertSubview:popupButton belowSubview:button];
		
		[mutablePopups addObject:popupButton];
		
		currentItem++;
	}
	
	self.items = mutablePopups;
	self.itemIndex = 0;
	

	//calculate the item fling interval based on the number of items
	//never go on for more than half a second
	//FIXME make this configurable
	float maxDuration = .50;
	float flingInterval = maxDuration/[self.items count];
	
	//start the timer that kicks off each animation set
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:flingInterval target:self selector:@selector(willFlingItem) userInfo:nil repeats:YES];
	
	//the origin button should spin for as long as we are flinging objects
	//+1 so its still spinning as the final object is animating out
	float spinDuration = ([self.items count]+1) * flingInterval;
	
	//use CABasicAnimation instead of a view animation so we can keep the spin going for more than 360 degrees
	[self shouldRotateButton:button forDuration:spinDuration forwardDirection:YES];
}


- (void)itemsWillDisapearIntoButton:(UIButton *) button {
	if ([self.items count] == 0) {
		//no items are displayed, we shouldn't be here
		return;
	}

	
	//calculate the item fling interval based on the number of items
	//never go on for more than half a second
	//FIXME make this configurable
	float maxDuration = .50;
	float flingInterval = maxDuration/[self.items count];
	
	//fling index is still the last object from the fling out
	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:flingInterval target:self selector:@selector(willRecoilItem) userInfo:nil repeats:YES];
	
	//this should go on for as long as we are flinging objects
	float spinDuration = ([self.items count]+1) * flingInterval;

	[self shouldRotateButton:button forDuration:spinDuration forwardDirection:NO];
}


- (void)buttonsWillAnimateFromButton:(id)sender inView:(UIView *)view {
	if ([self.items count]) {
		//the items are displayed already, hide them
		[self itemsWillDisapearIntoButton:sender];
	} else {
		//the items aren't displayed, throw them into view
		[self itemsWillAppearFromButton:sender inView:view];
	}
}





#pragma mark - private methods
- (void)willFlingItem {
	if (self.itemIndex == [self.items count]) {
		//nothing more to animate, kill the timer and exit
		[self.animationTimer invalidate];
		self.animationTimer = nil;
		
		return;
	}
	
	ALRadialButton *button = [self.items objectAtIndex:self.itemIndex];
	//tell the button to animate into view
	[button willAppear];
	
	self.itemIndex++;
}


- (void)willRecoilItem {
	if (self.itemIndex == 0) {
		//nothing more to animate, kill the timer and exit
		[self.animationTimer invalidate];
		self.animationTimer = nil;
		
		return;
	}
	self.itemIndex--;
	
	ALRadialButton *button = [self.items objectAtIndex:self.itemIndex];
	//tell the button to animate out of view
	[button willDisappear];
}


- (void)buttonPressed:(id)sender  {
	ALRadialButton *button = (ALRadialButton *)sender;
	[self.delegate radialMenu:self didSelectItemAtIndex:button.tag];
}



- (void)shouldRotateButton:(UIButton *)button forDuration:(float)duration forwardDirection:(BOOL)direction {
	//use CABasicAnimation instead of a view animation so we can keep the spin going for more than 360
	CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	spinAnimation.duration = duration;
	spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
	//do a 180 turn for each object being flung
	float totalDuration = M_PI * [self.items count];
	if (!direction) {
		totalDuration = totalDuration * -1;
	}
	spinAnimation.toValue = [NSNumber numberWithFloat: totalDuration];
	[button.layer addAnimation:spinAnimation forKey:@"spinAnimation"];

}





#pragma mark - button delegate methods
- (void) buttonDidFinishAnimation:(ALRadialButton *)radialButton {
	//now that the animation is complete remove the button from view.
	[radialButton removeFromSuperview];
	
	if (radialButton.tag == 1) {
		//all the buttons are removed, kill the array that was retaining them
		self.items = nil;
	}
}


@end