////////////////////////////////////////////////////////////////////////////////
//
// Code Krafters B.V. Timeline
// Copyright (c) 2014 Code Krafters B.V.
// All Rights Reserved Worldwide
// Proprietary and Confidential - Not for Distribution
// Written by Code Krafters B.V.
//
// CKTimelineLayout.m
//
// AUTHOR IDENTITY:
//		Roberto Gamboni		13/08/14	
//    
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
#import "CKTimelineLayout.h"

////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/** Private category of the CKTimelineLayout class */
@interface CKTimelineLayout ()

@property(nonatomic, assign) CGFloat timelineBarX;
@property(nonatomic, assign) CGFloat timelineBarWidth;
@property(nonatomic, assign) CGFloat timelineBarHeight;
@property(nonatomic, assign) CGFloat timelineFillingHeight;
@property(nonatomic, assign) CGFloat sideCellsWidth;
@property(nonatomic, assign) CGFloat sideCellsHeight;
@property(nonatomic, assign) CGFloat rightCellX;

@property(nonatomic, assign) CGFloat layoutHeight;

@property(nonatomic, retain) NSMutableArray* layoutArray;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation CKTimelineLayout

- (void) prepareLayout
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super prepareLayout];
    
    if (!self.layoutArray)
    {
        self.layoutArray = [[NSMutableArray alloc] init];
    }
    
    self.timelineBarHeight = 30;
    self.timelineBarWidth = 60;
    
    CGRect collectionRect = self.collectionView.bounds;
    self.sideCellsWidth = (collectionRect.size.width - self.timelineBarWidth) / 2.;
    self.sideCellsHeight = 140;
    
    self.timelineFillingHeight = self.sideCellsHeight - self.timelineBarHeight;
    self.timelineBarX = (collectionRect.size.width / 2.f) - (self.timelineBarWidth / 2.f);
    self.rightCellX = self.timelineBarX + self.timelineBarWidth;
    
    CGFloat prevCellBottom = 0.f;
    
    NSInteger numOfSections = self.collectionView.numberOfSections;
    for (int section = 0; section < numOfSections; section++) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        NSInteger randomNumber = arc4random() % 40;
        BOOL sign = (arc4random() % 2) == 0;
        CGFloat currentSectionHeight = self.sideCellsHeight;
        if (sign)
        {
            currentSectionHeight += randomNumber;
        }
        else
        {
            currentSectionHeight -= randomNumber;
        }
        
        for (int item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            CGRect itemFrame = CGRectZero;
            if (item == 0) {
                itemFrame.origin.x = 0;
                itemFrame.origin.y = prevCellBottom;
                itemFrame.size = CGSizeMake(self.sideCellsWidth, currentSectionHeight);
            } else if (item == 1) {
                itemFrame.origin.x = self.timelineBarX;
                //setting the defaults
                itemFrame.size = CGSizeMake(self.timelineBarWidth, currentSectionHeight);
                itemFrame.origin.y = prevCellBottom;
                
                if (section == 0)
                {
                    itemFrame.size = CGSizeMake(self.timelineBarWidth, currentSectionHeight - (self.timelineBarHeight / 2));
                } else
                {
                    itemFrame.origin.y = prevCellBottom - (self.timelineBarHeight / 2);
                }
                
                if (section == (numOfSections - 1))
                {
                    itemFrame.size = CGSizeMake(self.timelineBarWidth, currentSectionHeight + (self.timelineBarHeight / 2));
                }
                
            } else {
                itemFrame.origin.x = self.rightCellX;
                itemFrame.origin.y = prevCellBottom;
                itemFrame.size = CGSizeMake(self.sideCellsWidth, currentSectionHeight);
            }
            
            [tempArray addObject:[NSValue valueWithCGRect:itemFrame]];
        }
        prevCellBottom += currentSectionHeight;
        [self.layoutArray addObject:tempArray];
    }
    self.layoutHeight = prevCellBottom;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%s - rect: %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    NSMutableArray *attributes = [NSMutableArray array];
    BOOL start = NO;
    BOOL end = NO;
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        if (!start)
        {
            NSIndexPath* centerItem = [NSIndexPath indexPathForItem:1 inSection:section];
            UICollectionViewLayoutAttributes* itemAttr = [self layoutAttributesForItemAtIndexPath:centerItem];
            
            if (!CGRectEqualToRect(CGRectIntersection(rect, itemAttr.frame), CGRectNull)) {
                start = YES;
            }
        }
        else
        {
            NSIndexPath* leftItem = [NSIndexPath indexPathForItem:0 inSection:section];
            UICollectionViewLayoutAttributes* itemAttr = [self layoutAttributesForItemAtIndexPath:leftItem];
            
            if (CGRectEqualToRect(CGRectIntersection(rect, itemAttr.frame), CGRectNull)) {
                end = YES;
            }
        }
        
        if (end) {
            break;
        }
        
        if (start)
        {
            NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
            for (int item = 0; item < itemCount; item++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                UICollectionViewLayoutAttributes* itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
                [attributes addObject:itemAttr];
            }
        }
        
        
//        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
//        for (int item = 0; item < itemCount; item++) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
//            UICollectionViewLayoutAttributes* itemAttr = [self layoutAttributesForItemAtIndexPath:indexPath];
//            
//            
//            [attributes addObject:itemAttr];
//            //checking that ALL the items are ending outside the bounding rect
//            if ((itemAttr.center.y + itemAttr.size.height / 2) > (rect.origin.y + rect.size.height))
//            {
//                done = YES;
//            }
//            else
//            {
//                done = NO;
//            }
//        }
//        if (done)
//        {
//            break;
//        }
    }
    NSLog(@"Attributes: %@", attributes);
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect itemFrame = [[[self.layoutArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CGRectValue];
    attributes.size = itemFrame.size;
    attributes.center = CGPointMake(CGRectGetMidX(itemFrame), CGRectGetMidY(itemFrame));
    
    return attributes;
}

- (CGSize) collectionViewContentSize
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return CGSizeMake(self.collectionView.bounds.size.width, self.layoutHeight);
}

@end
