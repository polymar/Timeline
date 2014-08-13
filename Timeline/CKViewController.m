//
//  CKViewController.m
//  Timeline
//
//  Created by openovone on 13/08/14.
//  Copyright (c) 2014 codekrafters. All rights reserved.
//

#import "CKViewController.h"

@interface CKViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation CKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.collectionView registerNib:[UINib nibWithNibName:@"" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = ((indexPath.section % 2) == 0) ? [UIColor blueColor] : [UIColor redColor];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

@end
