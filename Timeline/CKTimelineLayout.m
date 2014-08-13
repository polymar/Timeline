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

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation CKTimelineLayout

- (void) prepareLayout
{
    self.timelineBarHeight = 40;
    self.timelineBarWidth = 80;
    
    CGRect collectionRect = self.collectionView.bounds;
    self.sideCellsWidth = (collectionRect.size.width - self.timelineBarWidth) / 2.;
    self.sideCellsHeight = 160;
    self.timelineFillingHeight = self.sideCellsHeight - self.timelineBarHeight;
    self.timelineBarX = (collectionRect.size.width / 2.f) - (self.timelineBarWidth / 2.f);
    self.rightCellX = self.timelineBarX + self.timelineBarWidth;
}

@end
