//
//  FormButton.m
//  CodingExampleOption2
//
//  Created by Jason Smith on 1/27/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import "FormButton.h"
#import "AdvancedMDColor.h"

@implementation FormButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self buttonWithTypeInit];
}
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    FormButton *button = [super buttonWithType:buttonType];
    [button buttonWithTypeInit];
    return button;
}

/// Because we can't override init on a uibutton, do init steps here.
- (void)buttonWithTypeInit {
    [self setTitleColor:[AdvancedMDColor secondaryColor] forState:UIControlStateNormal];
    
    CALayer *btnLayer = [self layer];
    [btnLayer setBorderColor:[AdvancedMDColor secondaryColor].CGColor];
    [btnLayer setBorderWidth:2.0f];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:4.0];
    
    self.tintColor = [AdvancedMDColor secondaryColor];
}

/// Make your button have a custom appearance when highlighted here.
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}


@end
