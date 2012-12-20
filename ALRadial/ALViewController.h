//
//  ALViewController.h
//  ALRadial
//
//  Created by andrew lattis on 12/9/24.
//  Copyright (c) 2012 andrew lattis. All rights reserved.
//  http://andrewlattis.com
//

#import <UIKit/UIKit.h>
//#import "ALPopup.h"
#import "ALRadialMenu.h"

@interface ALViewController : UIViewController <ALRadialMenuDelegate>

- (IBAction)buttonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *socialButton;

@property (strong, nonatomic) ALRadialMenu *radialMenu;
@property (strong, nonatomic) ALRadialMenu *socialMenu;

@property (strong, nonatomic) NSArray *popups;

@end
