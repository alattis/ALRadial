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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPressed:(id)sender {
	//the button that brings the items into view was pressed
	if (sender == self.button) {
		[self.radialMenu buttonsWillAnimateFromButton:sender inView:self.view];
	} else if (sender == self.socialButton) {
		[self.socialMenu buttonsWillAnimateFromButton:sender inView:self.view];
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


- (UIImage *) radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger) index {
	if (radialMenu == self.radialMenu) {
		if (index == 1) {
			return [UIImage imageNamed:@"dribbble"];
		} else if (index == 2) {
			return [UIImage imageNamed:@"youtube"];
		} else if (index == 3) {
			return [UIImage imageNamed:@"vimeo"];
		} else if (index == 4) {
			return [UIImage imageNamed:@"pinterest"];
		} else if (index == 5) {
			return [UIImage imageNamed:@"twitter"];
		} else if (index == 6) {
			return [UIImage imageNamed:@"instagram500"];
		} else if (index == 7) {
			return [UIImage imageNamed:@"email"];
		} else if (index == 8) {
			return [UIImage imageNamed:@"googleplus-revised"];
		} else if (index == 9) {
			return [UIImage imageNamed:@"facebook500"];
		}

	} else if (radialMenu == self.socialMenu) {
		if (index == 1) {
			return [UIImage imageNamed:@"email"];
		} else if (index == 2) {
			return [UIImage imageNamed:@"googleplus-revised"];
		} else if (index == 3) {
			return [UIImage imageNamed:@"facebook500"];
		}
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
