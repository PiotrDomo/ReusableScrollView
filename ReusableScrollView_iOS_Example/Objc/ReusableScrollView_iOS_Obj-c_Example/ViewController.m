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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat contentWidth = self.size.width * (CGFloat)self.viewCount;
    
    self.scrollView.contentSize         = CGSizeMake(contentWidth, self.size.height);
    self.scrollView.layer.borderColor   = [UIColor blackColor].CGColor;
    self.scrollView.layer.borderWidth   = 1;
    
}

#pragma mark - Getters

- (CGSize)size {
    return self.scrollView.bounds.size;
}

- (NSUInteger)viewCount {
    return 10;
}

@synthesize initialIndex;

@synthesize numberOfViews;

- (NSUInteger)numberOfViews {
    return 10;
}

- (NSInteger)initialIndex {
    return 7;
}
    
- (NSTimeInterval)focusDelay {
    return 2;
}

- (ReusableView * _Nonnull)reusableScrollViewDidRequestViewWithReusableScrollView:(ReusableScrollView * _Nonnull)reusableScrollView
                                                                            model:(ScrollViewModel * _Nonnull)model {
    
    CGRect frame = CGRectMake(model.position.x, model.position.y, self.size.width, self.size.height);
    
    ReusableView *reusableView      = [[ReusableView alloc] initWithFrame:frame];
    reusableView.backgroundColor    = [UIColor whiteColor];
    reusableView.alpha              = model.relativeIndex == RelativeIndexCurrent ? 1 : 0.5;
    reusableView.layer.borderColor  = [UIColor redColor].CGColor;
    reusableView.layer.borderWidth  = 1;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 20.f, 40.f, 80.f)];
    label.tag = 1;
    
    [reusableView addSubview:label];
    
    return reusableView;
}

- (void)reusableViewDidFocusWithReusableView:(ReusableView * _Nonnull)reusableView {
    
    UILabel *label = (UILabel *)[reusableView viewWithTag:1];
    
    label.text = [NSString stringWithFormat:@"%ld", reusableView.viewModel.absoluteIndex];
}

@end
