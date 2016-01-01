//
//  NKFToolbar.m
//  Toolbar Test
//
//  Created by HAI on 1/1/16.
//  Copyright © 2016 Nathan Fennel. All rights reserved.
//

#import "NKFToolbar.h"

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
    }
    
    return self;
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
                    barButtonItemContainer = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                                         0.0f,
                                                                                         self.frame.size.width,
                                                                                         (self.sizeWhileHorizontal.height > minimumToolbarSize.height) ? self.sizeWhileHorizontal.height : minimumToolbarSize.height)];
                    
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
        
        for (int i = 0; i < self.verticalItemContainers.count; i++) {
            UIToolbar *container = [self.verticalItemContainers objectAtIndex:i];
            
            container.center = CGPointMake(offset.width,
                                           container.frame.size.height * 0.75f + offset.height + (float)i / (float)(self.verticalItemContainers.count - ((self.verticalItemContainers.count > 1) ? 0 : 0)) * self.frame.size.height);
            
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
}


- (UIBarButtonItem *)flexibleSpace {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:nil
                                                         action:nil];
}



















@end
