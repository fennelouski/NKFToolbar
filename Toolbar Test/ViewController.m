//
//  ViewController.m
//  Toolbar Test
//
//  Created by HAI on 1/1/16.
//  Copyright © 2016 Nathan Fennel. All rights reserved.
//

#import "ViewController.h"
#import "NKFToolbar.h"

@interface ViewController ()

@property (nonatomic, strong) NKFToolbar *testToolbar;
@property (nonatomic, strong) UIBarButtonItem *shareButton, *flexibleSpace, *cancelButton, *cameraButton;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.testToolbar];
    
    NSNotificationCenter *notificaitonCenter = [NSNotificationCenter defaultCenter];
    [notificaitonCenter addObserver:self
                           selector:@selector(updateViewConstraints)
                               name:UIDeviceOrientationDidChangeNotification
                             object:nil];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    NSLog(@"Rotated");
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        self.testToolbar.orientation = NKFToolbarOrientationHorizontal;
        
        self.testToolbar.frame = CGRectMake(0.0f,
                                            self.view.frame.size.height - 44.0f,
                                            self.view.frame.size.width,
                                            44.0f);
    } else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        self.testToolbar.orientation = NKFToolbarOrientationVertical;
        
        self.testToolbar.frame = CGRectMake(0.0f,
                                            0.0f,
                                            100.0f,
                                            self.view.frame.size.height);
    }
    
    [self.testToolbar layoutSubviews];
}





- (NKFToolbar *)testToolbar {
    if (!_testToolbar) {
        _testToolbar = [[NKFToolbar alloc] initWithFrame:CGRectMake(0.0f,
                                                                    100.0f,
                                                                    self.view.frame.size.width,
                                                                    44.0f)];
        
        _testToolbar.items = @[self.shareButton, self.flexibleSpace, self.cancelButton, self.flexibleSpace, self.cameraButton];
        _testToolbar.usesSpaces = YES;
    }
    
    return _testToolbar;
}

- (UIBarButtonItem *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                     target:self
                                                                     action:@selector(barButtonTouched:)];
    }
    
    return _shareButton;
}

- (UIBarButtonItem *)flexibleSpace {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                         target:self
                                                         action:nil];
}

- (UIBarButtonItem *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                      target:self
                                                                      action:@selector(barButtonTouched:)];
    }
    
    return _cancelButton;
}

- (UIBarButtonItem *)cameraButton {
    if (!_cameraButton) {
        _cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                      target:self
                                                                      action:@selector(barButtonTouched:)];
    }
    
    return _cameraButton;
}

- (void)barButtonTouched:(UIBarButtonItem *)sender {
    NSLog(@"Sender: %@", sender);
}






#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
