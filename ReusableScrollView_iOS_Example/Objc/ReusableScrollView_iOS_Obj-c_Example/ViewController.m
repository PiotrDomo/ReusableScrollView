//
//  ViewController.m
//  ReusableScrollView_iOS_Obj-c_Example
//
//  Created by Piotr Domowicz on 15.05.18.
//  Copyright © 2018 sumofighter666. All rights reserved.
//

@import ReusableScrollView;

#import "ViewController.h"
#import "ReusableScrollView.h"

@interface ViewController () <ReusableScrollViewDelegate, ReusableScrollViewDataSource>

@property (weak, nonatomic) IBOutlet ReusableScrollView *scrollView;
@property (nonatomic, assign) NSUInteger viewCount;
@property (nonatomic, assign) CGSize size;

@end

@implementation ViewController

@synthesize initialIndex;
@synthesize numberOfViews;

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.viewCount = 12;
    
    CGFloat contentWidth = self.size.width * (CGFloat)self.viewCount;
    
    self.scrollView.contentSize         = CGSizeMake(contentWidth, self.size.height);
    self.scrollView.layer.borderColor   = [UIColor blackColor].CGColor;
    self.scrollView.layer.borderWidth   = 1;
    
}

#pragma mark - Getters

- (CGSize)size {
    return self.scrollView.bounds.size;
}

- (NSUInteger)numberOfViews {
    return 12;
}

- (NSInteger)initialIndex {
    return 7;
}
    
- (NSTimeInterval)focusDelay {
    return 0.5;
}

- (UIView *)scrollViewDidRequestViewWithReusableScrollView:(ReusableScrollView *)reusableScrollView atIndex:(NSInteger)atIndex {
    
    // In this case first check the reusable view exists already
    ReusableView *reusableView = [reusableScrollView reusableViewAtAbsoluteIndex:atIndex];
    if ([reusableView.contentView isKindOfClass:[UIImageView class]]) {
        [((UIImageView *)reusableView.contentView) setImage:[self thumbForIndex:atIndex]];
        return nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self thumbForIndex:atIndex]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageView;
}

- (UIImage *)thumbForIndex:(NSUInteger)index {
    NSString *imageName = [NSString stringWithFormat:@"image%ld_small", index];
    
    return [UIImage imageNamed:imageName];
}

- (UIImage *)imageForIndex:(NSUInteger)index {
    NSString *imageName = [NSString stringWithFormat:@"image%ld", index];
    
    return [UIImage imageNamed:imageName];
}

- (void)reusableViewDidFocusWithReusableView:(ReusableView * _Nonnull)reusableView {
    if (reusableView.absoluteIndex > -1) {
        NSLog(@"Load large image");
        UIImage *image = [self imageForIndex:reusableView.absoluteIndex];
        [((UIImageView *)reusableView.contentView) setImage:image];
    }
}

@end
