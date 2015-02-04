//
//  StartViewController.m
//  LeftMenuArcRoot
//
//  Created by ryan on 12/11/14.
//  Copyright (c) 2014 Ryan. All rights reserved.
//

#import "StartViewController.h"

@interface StartViewController ()

@property (nonatomic, retain) NSArray *guideArray;

@end

@implementation StartViewController

@synthesize startImageView;
@synthesize guideArray;

- (void)showPannel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowPannelViewNotification object:nil];
}
- (void)showGuide
{
    [self.view addAnimationWithType:kCATransitionFade subtype:nil];
    self.startImageView.hidden = YES;
}
#pragma mark - Gesture methods
- (void)swipeWithGesture:(UISwipeGestureRecognizer *)gesture
{
    if(self.startScrollView.contentOffset.x >= (self.guideArray.count-1)*self.startScrollView.frame.size.width)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kIsWelcomeShown];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowPannelViewNotification object:nil];
    }
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.startImageView.image = [UIImage assetLaunchImage];

    if(Is3_5Inch)
        self.guideArray = @[@"start0_4.jpg",@"start1_4.jpg",@"start2_4.jpg"];
    else if(Is4Inch)
        self.guideArray = @[@"start0_5.jpg",@"start1_5.jpg",@"start2_5.jpg"];
    else if(Is4_7Inch)
        self.guideArray = @[@"start0_6.jpg",@"start1_6.jpg",@"start2_6.jpg"];
    else if(Is5_5Inch)
        self.guideArray = @[@"start0_6p.jpg",@"start1_6p.jpg",@"start2_6p.jpg"];

    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsWelcomeShown] isEqualToString:@"1"])
    {
        self.startScrollView.hidden = YES;
        self.pageControl.hidden = YES;
        [self showPannel];
    }
    else
    {
        self.startScrollView.hidden = NO;
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = self.guideArray.count;
        [self showGuide];
        NSInteger index = 0;
        for(NSString *imgName in self.guideArray)
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(index*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            imgView.image = [UIImage imageNamed:imgName];
            [self.startScrollView addSubview:imgView];
            index++;
        }
        [self.startScrollView setContentSize:CGSizeMake(self.view.frame.size.width*self.guideArray.count, [UIScreen mainScreen].bounds.size.height)];
        
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeWithGesture:)];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeGesture.delegate = self;
        [self.view addGestureRecognizer:swipeGesture];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    self.pageControl.currentPage = page;
}

#pragma mark - StatusBar methods
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
