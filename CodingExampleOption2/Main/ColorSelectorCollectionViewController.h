//
//  ColorSelectorCollectionViewController.h
//  CodingExampleOption2
//
//  Created by Jason Smith on 1/27/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorSelectorCollectionViewController : UICollectionViewController<UIPopoverPresentationControllerDelegate>
@property(nonatomic,strong)NSMutableArray *selectedColors;
@end
