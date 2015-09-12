//
//  ALViewController.m
//  ALRadial
//
//  Created by andrew lattis on 12/9/24.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import "ALViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	//create an instance of the radial menu and set ourselves as the delegate.
	self.radialMenu = [[ALRadialMenu alloc] init];
	self.radialMenu.delegate = self;
	
	self.socialMenu = [[ALRadialMenu alloc] init];
	self.socialMenu.delegate = self;
    self.socialMenu.fadeItems = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressed:(id)sender {
	//the button that brings the items into view was pressed
	if (sender == self.button) {
		[self.radialMenu buttonsWillAnimateFromButton:sender withFrame:self.button.frame inView:self.view];
	} else if (sender == self.socialButton) {
		[self.socialMenu buttonsWillAnimateFromButton:sender withFrame:self.socialButton.frame inView:self.view];
	}
}



#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
	//FIXME: dipshit, change one of these variable names
	if (radialMenu == self.radialMenu) {
		return 9;
	} else if (radialMenu == self.socialMenu) {
		return 3;
	}
	
	return 0;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
	if (radialMenu == self.radialMenu) {
		return 360;
	} else if (radialMenu == self.socialMenu) {
		return 90;
	}
	
	return 0;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
	if (radialMenu == self.radialMenu) {
		return 80;
	} else if (radialMenu == self.socialMenu) {
		return 80;
	}
	
	return 0;
}


- (ALRadialButton *) radialMenu:(ALRadialMenu *)radialMenu buttonForIndex:(NSInteger)index {
    ALRadialButton *button = [[ALRadialButton alloc] init];
    if (radialMenu == self.radialMenu) {
		if (index == 1) {
            [button setImage:[UIImage imageNamed:@"dribbble"] forState:UIControlStateNormal];
		} else if (index == 2) {
            [button setImage:[UIImage imageNamed:@"youtube"] forState:UIControlStateNormal];
		} else if (index == 3) {
            [button setImage:[UIImage imageNamed:@"vimeo"] forState:UIControlStateNormal];
		} else if (index == 4) {
            [button setImage:[UIImage imageNamed:@"pinterest"] forState:UIControlStateNormal];
		} else if (index == 5) {
            [button setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
		} else if (index == 6) {
            [button setImage:[UIImage imageNamed:@"instagram500"] forState:UIControlStateNormal];
		} else if (index == 7) {
            [button setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
		} else if (index == 8) {
            [button setImage:[UIImage imageNamed:@"googleplus-revised"] forState:UIControlStateNormal];
		} else if (index == 9) {
            [button setImage:[UIImage imageNamed:@"facebook500"] forState:UIControlStateNormal];
		}

	} else if (radialMenu == self.socialMenu) {
		if (index == 1) {
            [button setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
		} else if (index == 2) {
            [button setImage:[UIImage imageNamed:@"googleplus-revised"] forState:UIControlStateNormal];
		} else if (index == 3) {
            [button setImage:[UIImage imageNamed:@"facebook500"] forState:UIControlStateNormal];
		}
	}
	
    if (button.imageView.image) {
        return button;
    }
    
	return nil;
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
	if (radialMenu == self.radialMenu) {
		[self.radialMenu itemsWillDisapearIntoButton:self.button];
	} else if (radialMenu == self.socialMenu) {
		[self.socialMenu itemsWillDisapearIntoButton:self.socialButton];
		if (index == 1) {
			NSLog(@"email");
		} else if (index == 2) {
			NSLog(@"google+");
		} else if (index == 3) {
			NSLog(@"facebook");
		}
	}

}

@end
