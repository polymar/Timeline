//
//  CKViewController.m
//  Timeline
//
//  Created by openovone on 13/08/14.
//  Copyright (c) 2014 codekrafters. All rights reserved.
//

#import "CKViewController.h"
#import "CKTimelineLayout.h"
#import "CKTimelineLocationCell.h"
#import "CKTimelineEventIndicatorCell.h"

@interface CKViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UICollectionViewLayout* timelineLayout;

@end

@implementation CKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timelineLayout = [[CKTimelineLayout alloc] init];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CKTimelineLocationCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CKTimelineLocation"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CKTimelineEventIndicatorCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"CKTimelineEventIndicator"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.collectionViewLayout = self.timelineLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.timelineLayout invalidateLayout];
}

#pragma mark -
#pragma mark UICollectionViewDelegate

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%s", __PRETTY_FUNCTION__);
    UICollectionViewCell *cell = nil;
    
    if (indexPath.row == 0)
    {
        //location
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CKTimelineLocation" forIndexPath:indexPath];
        CKTimelineLocationCell* locationCell = (CKTimelineLocationCell*) cell;
        locationCell.locationLabel.text = [NSString stringWithFormat:@"Location %d", indexPath.section];
        cell.backgroundColor = [UIColor greenColor];
        cell.alpha = 0.1 * (indexPath.section + 1);
    } else if (indexPath.row == 1)
    {
        //timeline indicators
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CKTimelineEventIndicator" forIndexPath:indexPath];
        CKTimelineEventIndicatorCell* indicatorCell = (CKTimelineEventIndicatorCell*) cell;
        indicatorCell.eventTimeLabel.text = [NSString stringWithFormat:@"20:%@", [NSString stringWithFormat:@"%d", 10 + (indexPath.section + 1) * 3]];
    } else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        //details
        cell.backgroundColor = [UIColor blueColor];
        cell.alpha = 0.1 * (indexPath.section + 1);
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 10;
}

@end
