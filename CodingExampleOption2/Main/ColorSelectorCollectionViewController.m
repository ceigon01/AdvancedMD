//
//  ColorSelectorCollectionViewController.m
//  CodingExampleOption2
//
//  Created by Jason Smith on 1/27/16.
//  Copyright © 2016 Jason Smith. All rights reserved.
//

#import "ColorSelectorCollectionViewController.h"
#import "AppDelegate.h"
#import "ColorCollectionViewCell.h"
#import "DashboardViewController.h"

@interface ColorSelectorCollectionViewController (){
    AppDelegate *appDelegate;
}
@end 
@implementation ColorSelectorCollectionViewController

static NSString * const reuseIdentifier = @"ColorCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set previously selected pattern
    DashboardViewController *dashboardViewController = (DashboardViewController*)self.presentingViewController;
    _selectedColors = (dashboardViewController.selectedPatternSequenceArray.count > 0)?dashboardViewController.selectedPatternSequenceArray:[[NSMutableArray alloc]init];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
#pragma mark <UICollectionViewDataSource,UIPopoverControllerDelegate,UIPopoverPresentationControllerDelegate>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return appDelegate.colorOptionArray.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableview = headerView;
    }
    return reusableview;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //cell customization
    ColorCollectionViewCell *cell = (ColorCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIColor *cellBackgroundColor = [appDelegate.colorOptionArray objectAtIndex:indexPath.row];
    cell.layer.cornerRadius = cell.frame.size.width / 2;
    cell.backgroundColor = cellBackgroundColor;
    //show current tap sequence on individual cells
    NSInteger itemIndex=[_selectedColors indexOfObject:cellBackgroundColor];
    if(_selectedColors.count > 0 && itemIndex != NSNotFound){
        cell.countLabel.text = [NSString stringWithFormat:@"%li",itemIndex+1];
    }else{
        cell.countLabel.text = @"";
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectedColors.count >= appDelegate.colorOptionArray.count){
        [_selectedColors removeAllObjects];
    }
    [_selectedColors addObject:[appDelegate.colorOptionArray  objectAtIndex:indexPath.row]];
    [collectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
