//
//  NKFToolbar.m
//  Toolbar Test
//
//  Created by HAI on 1/1/16.
//  Copyright © 2016 Nathan Fennel. All rights reserved.
//

#import "NKFToolbar.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)


static CGSize const minimumToolbarSize = {44.0f, 44.0f};

@interface NKFToolbar ()

@property (nonatomic, strong) NSMapTable *toolbarContainerDictionary;

@property (nonatomic)  CGSize sizeWhileHorizontal;

@property (nonatomic, strong) NSMutableArray *verticalItemContainers;

@property (nonatomic, strong) NSArray *backupCopyOfItems;

@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;

@end

@implementation NKFToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.toolbarContainerDictionary = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                                                    valueOptions:NSPointerFunctionsStrongMemory
                                                                        capacity:16/*Arbitrary Value*/];
        self.verticalItemContainers = [NSMutableArray new];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateLayout];
        });
        
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (void)updateLayout {
    if (self.superview) {
        NKFToolbarOrientation tempOrientation = self.orientation;
        
        self.orientation = NKFToolbarOrientationHorizontal;
        [self layoutSubviews];
        self.orientation = NKFToolbarOrientationVertical;
        [self layoutSubviews];
        self.orientation = tempOrientation;
        [self layoutSubviews];
    }
}

- (void)layoutSubviews {
    if (self.orientation == NKFToolbarOrientationHorizontal) {
        self.sizeWhileHorizontal = self.bounds.size;
        
        NSMutableArray *updatedItems = [NSMutableArray new];
        
        for (UIToolbar *toolbarContainer in self.verticalItemContainers) {
            [toolbarContainer removeFromSuperview];
            
            if (toolbarContainer.items.count > 2) {
                [updatedItems addObject:[toolbarContainer.items objectAtIndex:1]];
                [updatedItems addObject:self.flexibleSpace];
            }
        }
        
        [updatedItems removeLastObject];
        
        if (updatedItems.count) {
            [self setItems:updatedItems
                  animated:YES];
        }
        
        [super layoutSubviews];
    } else {
        [self.verticalItemContainers removeAllObjects];
        
        for (int i = 0; i < self.backupCopyOfItems.count; i++) {
            if (i % 2 == self.firstItemIsSpace ? 1 : 0) {
                UIBarButtonItem *barButtonItem = [self.backupCopyOfItems objectAtIndex:i];
                UIToolbar *barButtonItemContainer = [self.toolbarContainerDictionary
                                                     objectForKey:barButtonItem];
                if (!barButtonItemContainer) {
                    CGRect frame = CGRectMake(0.0f,
                                              0.0f,
                                              self.frame.size.width,
                                              (self.sizeWhileHorizontal.height > minimumToolbarSize.height) ? self.sizeWhileHorizontal.height : minimumToolbarSize.height);
                    barButtonItemContainer = [[UIToolbar alloc] initWithFrame:frame];
                    
                    if (barButtonItem && barButtonItemContainer) {
                        [self.toolbarContainerDictionary setObject:barButtonItemContainer
                                                            forKey:barButtonItem];
                    }
                    
                    barButtonItemContainer.tintColor = self.tintColor;
                    barButtonItemContainer.barTintColor = self.barTintColor;
                    barButtonItemContainer.backgroundColor = [UIColor clearColor];
                    barButtonItemContainer.clipsToBounds = YES;
                }
                
                [barButtonItemContainer setItems:@[self.flexibleSpace, barButtonItem, self.flexibleSpace]
                                        animated:NO];
                
                [self.verticalItemContainers addObject:barButtonItemContainer];
            }
        }
        
        CGSize offset = CGSizeMake(((self.frame.size.width > minimumToolbarSize.width) ? self.frame.size.width: minimumToolbarSize.width) * 0.5f,
                                   ((self.sizeWhileHorizontal.height > minimumToolbarSize.height) ? self.sizeWhileHorizontal.height : minimumToolbarSize.height) * 0.5f);
        
        if (self.useFloatingVerticalItems) {
            offset.width -= self.floatingCornerRadius;
            
            [self setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
            [self setShadowImage:[UIImage new]
              forToolbarPosition:UIBarPositionAny];
        } else {
            [self setBackgroundImage:nil
                  forToolbarPosition:UIBarPositionAny
                          barMetrics:UIBarMetricsDefault];
            [self setShadowImage:nil
              forToolbarPosition:UIBarPositionAny];
        }
        
        for (int i = 0; i < self.verticalItemContainers.count; i++) {
            UIToolbar *container = [self.verticalItemContainers objectAtIndex:i];
            
            CGPoint center = CGPointMake(offset.width,
                                         container.frame.size.height * 0.5f + (float)i / (float)(self.verticalItemContainers.count - ((self.verticalItemContainers.count > 1) ? 1 : 0)) * (self.frame.size.height - offset.height * 2.0f));
            
            
            if (self.useFloatingVerticalItems) {
                if (i == 0) {
                    center.y -= self.floatingCornerRadius;
                } else if (i + 1 == self.verticalItemContainers.count) {
                    center.y += self.floatingCornerRadius;
                }
                
                container.clipsToBounds = YES;
                container.layer.cornerRadius = self.floatingCornerRadius;
                
                [container setBackgroundImage:nil
                           forToolbarPosition:UIBarPositionAny
                                   barMetrics:UIBarMetricsDefault];
                [container setShadowImage:nil
                       forToolbarPosition:UIBarPositionAny];
            } else {
                container.clipsToBounds = NO;
                container.layer.cornerRadius = 0.0f;
                
                [container setBackgroundImage:[UIImage new]
                           forToolbarPosition:UIBarPositionAny
                                   barMetrics:UIBarMetricsDefault];
                [container setShadowImage:[UIImage new]
                       forToolbarPosition:UIBarPositionAny];
            }
            
            container.center = center;
            
            [self addSubview:container];
            
            if (container.items.count > 1) {
                UIBarButtonItem *actualItem = [container.items objectAtIndex:1];
                if (actualItem.style == UIBarButtonItemStylePlain) {
                    [actualItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]}
                                              forState:UIControlStateNormal];
                } else {
                    [actualItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]}
                                              forState:UIControlStateNormal];
                }
            }
            
            [container layoutSubviews];
        }
    }
    
    [super layoutSubviews];
}

- (void)setItems:(NSArray<UIBarButtonItem *> *)items {
    [self setItems:items animated:NO];
}

- (void)setItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated {
    [super setItems:items
           animated:animated];
    
    NSOrderedSet *noDuplicateItems = [[NSOrderedSet alloc] initWithArray:items];
    
    NSMutableArray *tempItems = [[NSMutableArray alloc] init];
    
    for (UIBarButtonItem *barButtonItem in noDuplicateItems) {
        [tempItems addObject:barButtonItem];
    }
    
    self.backupCopyOfItems = tempItems;
    
    [self.verticalItemContainers removeAllObjects];
    
    [UIView animateWithDuration:animated ? 0.35f : 0.0f
                     animations:^{
                         [self layoutSubviews];
                     }];
}


- (UIBarButtonItem *)flexibleSpace {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
}





















@end
