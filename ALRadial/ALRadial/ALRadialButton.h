//
//  ALRadialButton.h
//  ALRadial
//
//  Created by andrew lattis on 12/10/14.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import <UIKit/UIKit.h>

@class ALRadialButton;

///protocol delegate for owner of the button
@protocol ALRadialButtonDelegate <NSObject>

/**
 * method to let the creator know when the disappear animation is completed
 * @param radialButton the radial button object making the request
 */
- (void) buttonDidFinishAnimation:(ALRadialButton *)radialButton;

@end


///uibutton subclass that handles the individual item animation and display
@interface ALRadialButton : UIButton

///@name Tasks

///animate this button into view
- (void)willAppear;

///animate this button out of view
- (void)willDisappear;


///@name Properties

///the center point of the button frame in its normal position
@property (nonatomic) CGPoint centerPoint;

///the center point of the button frame in the extended position , this gets us the bouncing string effect when the button is flung out
@property (nonatomic) CGPoint bouncePoint;

///the center point of the button's starting point, and ending point when it disappears
@property (nonatomic) CGPoint originPoint;

///the delegate object for the creator of this button
@property (nonatomic, weak) id <ALRadialButtonDelegate> delegate;

@end
