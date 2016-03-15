//
//  DashboardViewController.m
//  CodingExampleOption2
//
//  Created by Jason Smith on 1/27/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import "DashboardViewController.h"
#import "ColorSelectorCollectionViewController.h"
@import Photos;

@interface DashboardViewController (){
    int i;
    int index;
    UIAlertController * alert;
    UIAlertAction* okButton;
    BOOL colIsValid;
    BOOL rowIsValid;
}

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //variable initialization
    _selectedPatternSequenceArray = [[NSMutableArray alloc]init];
    _colorGridViewController.delegate = self;
    _colorGridViewController.dataSource = self;
    _maxColumns = 0;
    _maxRows = 0;
    [_colorGridViewController reloadData];
    i = 0;
    index = 0;
    //keyboard hide toolbar
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                  UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard:)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:
                          CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:nil action:nil];
    toolbar.items = [NSArray arrayWithObjects:flexibleItem,barButton,nil];
    
    //initeal set up of UI elemets
    _numberOfColumnsTextField.inputAccessoryView = toolbar;
    _numberOfRowsTextField.inputAccessoryView = toolbar;
    _numberOfColumnsTextField.delegate = self;
    _numberOfRowsTextField.delegate = self;
    
    _saveAsPhotoButton.enabled = NO;
    _saveAsPhotoButton.alpha = 0.7;
    _submitButton.enabled = NO;
    _submitButton.alpha = 0.7;
    
    //setup access to the users photo library and success alert dialog
    [self initSaveToPhotoOpperation];
}
#pragma mark - instance methods
-(void)initSaveToPhotoOpperation{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
            alert   = [UIAlertController
                       alertControllerWithTitle:@"Great Job!"
                       message:@"Your image was created and is available in your photos"
                       preferredStyle:UIAlertControllerStyleAlert];
            
            okButton = [UIAlertAction
                        actionWithTitle:@"Ok"
                        style:UIAlertActionStyleDefault
                        handler:nil];
            
            [alert addAction:okButton];
            
            
        }else if(status == PHAuthorizationStatusDenied){
            _saveAsPhotoButton.hidden = YES;
        }
    }];
}

- (void)photoLibraryDidChange:(PHChange *)changeInstance{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showColorPicker:(id)sender {
    [self performSegueWithIdentifier:@"showColorSelector" sender:self];
}
-(void)generateColorGridWithColorSequanceArray:(NSArray*)colorArray
                                withMaxColumns:(NSInteger)maxColumns
                                   withMaxRows:(NSInteger)maxRows{
    _selectedPatternSequenceArray = colorArray.mutableCopy;
    _maxColumns = maxColumns;
    _maxRows = maxRows;

    
    if(_maxColumns > 0 && _maxRows > 0 ){
        _saveAsPhotoButton.enabled = YES;
        _saveAsPhotoButton.alpha = 1.0;
        [_colorGridViewController reloadData];
    }
}
-(void) hideKeyboard:(id)sender{
    [self.view endEditing:YES];
}
-(void) popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController*)popoverPresentationController{
    ColorSelectorCollectionViewController *popoverController =
    (ColorSelectorCollectionViewController*)popoverPresentationController.presentedViewController;
    index = 0;
    _selectedPatternSequenceArray =  popoverController.selectedColors;
    
    rowIsValid = _numberOfRowsTextField.text.length > 0;
    colIsValid = _numberOfColumnsTextField.text.length > 0;
    
    if(rowIsValid && colIsValid && _selectedPatternSequenceArray.count > 0){
        _submitButton.enabled = YES;
        _submitButton.alpha = 1.0;
    }
    
}
- (UIImage *)takeSnapshotOfView:(UIView *)view{
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - TextFieldDelegate Methods

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(colIsValid  && rowIsValid  && _selectedPatternSequenceArray.count > 0){
        _submitButton.enabled = YES;
        _submitButton.alpha = 1.0;
    }else{
        _submitButton.alpha = 0.7;
        _submitButton.enabled = NO;
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *fullText = [textField.text stringByAppendingString:string];
    if(textField == _numberOfColumnsTextField){
        _maxColumns = [fullText integerValue];
        colIsValid = range.location > 0;
    }
    if(textField == _numberOfRowsTextField){
        _maxRows = [fullText integerValue];
        rowIsValid = range.location > 0;
    }
    
    return YES;
}
#pragma mark - IBAction Methods
- (IBAction)saveGridAsImage:(id)sender {
    UIImage  *generatedImage = [self takeSnapshotOfView:_colorGridViewController.viewForFirstBaselineLayout];
    
    NSData *data=UIImagePNGRepresentation(generatedImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // NSString *imgName = [NSString stringWithFormat:imagename];
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:@"AdvancedMDColorGrid"];
    [data writeToFile:strPath atomically:YES];
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    [library performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:generatedImage];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            //allows the operation to run freely from the background thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alert animated:YES completion:nil];
            });
        }else {
            NSLog(@"write error : %@",error);
        }
    }];
}

- (IBAction)generateColorGrid:(id)sender {
    index = 0;
    NSInteger numCols = [_numberOfColumnsTextField.text integerValue];
    NSInteger numRows = [_numberOfRowsTextField.text integerValue];
    [self generateColorGridWithColorSequanceArray:_selectedPatternSequenceArray withMaxColumns:numCols withMaxRows:numRows];
}
#pragma mark  - CollectionViewMethods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _maxRows;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _maxColumns;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:@"HeaderView"
                                                                                         forIndexPath:indexPath];
        reusableview = headerView;
    }
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float cellWidth = collectionView.bounds.size.width / _maxColumns * 0.83;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = cell.frame.size.width / 2;
    UIColor *backgroundColor = [UIColor clearColor];
    if( index % _selectedPatternSequenceArray.count == 0) {
        i = 0;
    }else{
        i++;
    }
    backgroundColor = [_selectedPatternSequenceArray objectAtIndex:i];
    index++;
    cell.backgroundColor = backgroundColor;

    return cell;
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Assuming you've hooked this all up in a Storyboard with a popover presentation style
     if ([segue.identifier isEqualToString:@"showColorSelector"]) {
         UINavigationController *destNav = segue.destinationViewController;
         destNav.popoverPresentationController.backgroundColor = [UIColor whiteColor];
         destNav.preferredContentSize = CGSizeMake(400, 200);
         UIPopoverPresentationController *popoverController = destNav.popoverPresentationController;
         popoverController.delegate = self;
        
     }
 }
-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller{
    return UIModalPresentationNone;
}
@end
