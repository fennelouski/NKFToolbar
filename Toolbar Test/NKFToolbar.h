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
 */
@property (nonatomic) NKFToolbarOrientation orientation;

/**
 *  If each item is separated by a space. Setting as YES will skip every other item.
 */
@property (nonatomic) BOOL usesSpaces;

/**
 *  Only used if usesSpaces is YES. This switches the items skipped from being even to being odd.
 */
@property (nonatomic) BOOL firstItemIsSpace;

@end
