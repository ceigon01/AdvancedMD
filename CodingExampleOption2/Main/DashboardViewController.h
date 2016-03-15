//
//  DashboardViewController.h
//  CodingExampleOption2
//
//  Created by Jason Smith on 1/27/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormButton.h"
#import "SubmitButton.h"
#import "OptionalButton.h"
@import Photos;


@interface DashboardViewController : UIViewController<UIPopoverPresentationControllerDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver,UICollectionViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberOfRowsTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfColumnsTextField;
@property (weak, nonatomic) IBOutlet FormButton *colorSelectorButton;
@property (weak, nonatomic) IBOutlet SubmitButton *submitButton;
@property (weak, nonatomic) IBOutlet UICollectionView *colorGridViewController;
@property (strong,nonatomic) NSMutableArray *selectedPatternSequenceArray;
@property (assign, nonatomic) NSInteger maxColumns;
@property (assign, nonatomic) NSInteger maxRows;
@property (weak, nonatomic) IBOutlet OptionalButton *saveAsPhotoButton;

-(void)generateColorGridWithColorSequanceArray:(NSArray*)colorArray
                                withMaxColumns:(NSInteger)maxColumns
                                   withMaxRows:(NSInteger)maxRows;


@end
