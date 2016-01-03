//
//  NKFToolbar.h
//  Toolbar Test
//
//  Created by HAI on 1/1/16.
//  Copyright © 2016 Nathan Fennel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NKFToolbarOrientationHorizontal,
    NKFToolbarOrientationVertical,
} NKFToolbarOrientation;

@interface NKFToolbar : UIToolbar

/**
 *  The orientation of the toolbar. Horizontal results in the toolbar being used as a regular UIToolbar.
 *  Default is Horizontal.
 */
@property (nonatomic) NKFToolbarOrientation orientation;

/**
 *  Set YES if each item is separated by a space. Setting as YES will skip every other item.
 *  Default is NO.
 */
@property (nonatomic) BOOL usesSpaces;

/**
 *  Only used if usesSpaces is YES. This switches the items skipped from being even to being odd.
 *  Default is NO.
 */
@property (nonatomic) BOOL firstItemIsSpace;

/**
 *  Separates the items vertically so they're freely floating without a toolbar frame.
 */
@property (nonatomic) BOOL useFloatingVerticalItems;

/**
 *  If the toolbar is floating then round the corners to this radius.
 */
@property (nonatomic) CGFloat floatingCornerRadius;

@end
