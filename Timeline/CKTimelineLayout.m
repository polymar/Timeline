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

@property(nonatomic, retain) NSMutableArray* layoutArray;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation CKTimelineLayout

- (void) prepareLayout
{
    [super prepareLayout];
    
    if (!self.layoutArray)
    {
        self.layoutArray = [[NSMutableArray alloc] init];
    }
    
    self.timelineBarHeight = 40;
    self.timelineBarWidth = 80;
    
    CGRect collectionRect = self.collectionView.bounds;
    self.sideCellsWidth = (collectionRect.size.width - self.timelineBarWidth) / 2.;
    self.sideCellsHeight = 160;
    self.timelineFillingHeight = self.sideCellsHeight - self.timelineBarHeight;
    self.timelineBarX = (collectionRect.size.width / 2.f) - (self.timelineBarWidth / 2.f);
    self.rightCellX = self.timelineBarX + self.timelineBarWidth;
    
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
            CGRect itemFrame = CGRectZero;
            if (item == 0) {
                itemFrame.origin.x = 0;
                itemFrame.size = CGSizeMake(self.sideCellsWidth, self.sideCellsHeight);
            } else if (item == 1) {
                itemFrame.origin.x = self.timelineBarX;
                itemFrame.size = CGSizeMake(self.timelineBarWidth, self.sideCellsHeight);
            } else {
                itemFrame.origin.x = self.rightCellX;
                itemFrame.size = CGSizeMake(self.sideCellsWidth, self.sideCellsHeight);
            }
            itemFrame.origin.y = section * self.sideCellsHeight;
            
            [tempArray addObject:[NSValue valueWithCGRect:itemFrame]];
        }
        [self.layoutArray addObject:tempArray];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (int section = 0; section < self.collectionView.numberOfSections; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (int item = 0; item < itemCount; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect itemFrame = [[[self.layoutArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] CGRectValue];
    attributes.size = itemFrame.size;
    attributes.center = CGPointMake(CGRectGetMidX(itemFrame), CGRectGetMidY(itemFrame));
    
    return attributes;
}

@end
