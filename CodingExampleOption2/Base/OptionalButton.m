//
//  OptionalButton.m
//  CodingExampleOption2
//
//  Created by Jason Smith on 1/28/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import "OptionalButton.h"
#import "AdvancedMDColor.h"

@implementation OptionalButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self buttonWithTypeInit];
}
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    OptionalButton *button = [super buttonWithType:buttonType];
    [button buttonWithTypeInit];
    return button;
}

/// Because we can't override init on a uibutton, do init steps here.
- (void)buttonWithTypeInit {
    [self setTitleColor:[AdvancedMDColor whiteColor] forState:UIControlStateNormal];
    CALayer *btnLayer = [self layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:4.0];
    [btnLayer setBackgroundColor:[AdvancedMDColor primaryColor].CGColor];
}

/// Make your button have a custom appearance when highlighted here.
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}
@end
