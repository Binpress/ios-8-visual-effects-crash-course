//
//  MainViewController.m
//  VisualEffectsDemo
//
//  Copyright (c) 2014 Tammy Coron. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "MoreDetailsViewController.h"

@interface MainViewController () <UIViewControllerTransitioningDelegate, UIScrollViewDelegate>
{
    UIBlurEffect *_blurEffect;
    BOOL _showWithVibrancy;
    
    UIVisualEffectView *_bluredEffectView;
    UILabel *_label;
    
    AVAudioPlayer *_audioPlayer;
}

@property (nonatomic, weak) IBOutlet UIScrollView *imageScrollView;

@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, weak) IBOutlet UIView *selectedDetailsView;

@property (nonatomic, strong) IBOutlet UILabel *movieTitle;
@property (nonatomic, strong) IBOutlet UILabel *movieReleaseDate;

@property (nonatomic, weak) IBOutlet UIView *showMenuView;
@property (nonatomic, weak) IBOutlet UIImageView *showMenuIcon;
@property (nonatomic, weak) IBOutlet UIButton *btnShowMenu;

@property (nonatomic, weak) IBOutlet UIView *selectionViewPrimary;
@property (nonatomic, weak) IBOutlet UIView *selectionViewSecondary;

@property (nonatomic, weak) IBOutlet UIButton *btnShowControls;
@property (nonatomic, weak) IBOutlet UIView *effectsControlView;

@end

@implementation MainViewController

#pragma mark -
#pragma mark Init View

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark View Will/Did LayoutSubviews

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    MoreDetailsViewController *detailViewController = segue.destinationViewController;
    
    detailViewController.transitioningDelegate = self;
    detailViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    detailViewController.view.backgroundColor = [UIColor clearColor];
    
    // there is a bug! this is a work around
    self.selectionViewPrimary.frame = CGRectMake(-113, 0, self.selectionViewPrimary.frame.size.width, self.selectionViewPrimary.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    detailViewController.imageFromPreviousScreen = copied;
}

#pragma mark -
#pragma mark PLay Music

-(void)setupAndPlayMusic
{
    NSString *path = [NSString stringWithFormat:@"%@/Professor_and_the_Plant.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audioPlayer.numberOfLoops = -1;
    
    [_audioPlayer play];
}

#pragma mark -
#pragma mark View Setup

- (void)setupView
{
    [self setupAndPlayMusic];
    [self setupImageScrollView];
    
    [self setupButtonMasks];
    [self setupLabel];
    
    [self setupBlurEffectForSelectionDetailsView];
    
    _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _showWithVibrancy = YES;
    
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"_selectedItem"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupButtonMasks
{
    for (int i = 1; i <= 5; i++)
    {
        UIButton *button = (UIButton *)[self.selectionViewSecondary viewWithTag:i];
        button.imageView.layer.cornerRadius = roundf(button.imageView.frame.size.width/2.0);
        button.imageView.layer.masksToBounds = YES;
    }
}

- (void)setupLabel
{
    _label = [[UILabel alloc] init];
    _label.textAlignment = NSTextAlignmentCenter;
    
    [_label setText:NSLocalizedString(@"Make Selection", nil)];
    [_label setFont:[UIFont systemFontOfSize:14.0f]];
    _label.textColor = [UIColor lightTextColor];
    
    [_label sizeToFit];
    [_label setCenter:self.view.center];
    
    
    UIButton *button = (UIButton *)[self.selectionViewSecondary viewWithTag:5];
    _label.frame = CGRectMake(0, button.frame.origin.y + button.frame.size.height + 20, self.selectionViewPrimary.frame.size.width, _label.frame.size.height);
}

- (void)setupSelectedDetails:(int )selectedItem
{
    switch (selectedItem)
    {
        case 5:
        {
            self.movieTitle.text = NSLocalizedString(@"Tim Burton Movies", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"( use the menu to select a movie )", nil);
            self.mainImageView.image = [UIImage imageNamed:@"tim_burton_the_man.jpg"];
            
            break;
        }
            
        case 1:
        {
            self.movieTitle.text = NSLocalizedString(@"9", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"9 September 2009 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_9.jpg"];
            
            break;
        }
        
        case 2:
        {
            self.movieTitle.text = NSLocalizedString(@"Corpse Bride", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"23 September 2005 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_corpse.jpg"];
            
            break;
        }
            
        case 3:
        {
            self.movieTitle.text = NSLocalizedString(@"Frankenweenie", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"5 October 2012 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_frankenweenie.jpg"];
            
            break;
        }
            
        case 4:
        {
            self.movieTitle.text = NSLocalizedString(@"The Nightmare Before Christmas", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"29 October 1993 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_nightmare.jpg"];
            
            break;
        }
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:selectedItem forKey:@"_selectedItem"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark UIScrollViewDelegate & Tapping Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.mainImageView;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    float newScale = [self.imageScrollView zoomScale] * 2;
    
    if (newScale > self.imageScrollView.maximumZoomScale)
    {
        newScale = 1;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.imageScrollView zoomToRect:zoomRect animated:YES];
    }
    else
    {
        newScale = self.imageScrollView.maximumZoomScale;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self.imageScrollView zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark Utility methods

- (void)setupImageScrollView
{
    self.imageScrollView.bouncesZoom = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.clipsToBounds = YES;
    self.imageScrollView.maximumZoomScale = 4.0;
    self.imageScrollView.minimumZoomScale = 0.5;
    self.imageScrollView.zoomScale = 1;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    
    [self.mainImageView addGestureRecognizer:doubleTap];
    self.mainImageView.userInteractionEnabled = YES;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = [self.imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [self.imageScrollView frame].size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    CGFloat offsetX = (self.imageScrollView.bounds.size.width > self.imageScrollView.contentSize.width)?
    (self.imageScrollView.bounds.size.width - self.imageScrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (self.imageScrollView.bounds.size.height > self.imageScrollView.contentSize.height)?
    (self.imageScrollView.bounds.size.height - self.imageScrollView.contentSize.height) * 0.5 : 0.0;
    
    self.mainImageView.center = CGPointMake(self.imageScrollView.contentSize.width * 0.5 + offsetX, self.imageScrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)btnShowMenu_tap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 1:
        {
            [self hideSelectionView];
            break;
        }
            
        case 2:
        {
            [self setupEffectsForSelectionViewAndShowSelectionViewController];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)btnChangeSelection_tap:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self setupSelectedDetails:(int)button.tag];
    
    [self hideSelectionView];
}

- (IBAction)btnShowMain_tap:(id)sender
{
    self.mainImageView.image = [UIImage imageNamed:@"tim_burton_the_man.jpg"];
    
    self.movieTitle.text = NSLocalizedString(@"Tim Burton Movies", nil);
    self.movieReleaseDate.text = NSLocalizedString(@"( use the menu to select a movie )", nil);
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

#pragma mark - Additional Code for Dynamically Changing Effects

- (IBAction)btnToggleEffectsControlView:(id)sender
{
    // toggles effects selection view
    
    [self hideSelectionView];
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 1:
        {
            [self hideEffectsControlView];
            break;
        }
            
        case 2:
        {
            [self showEffectsControlView];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)btnChangeBlurEffect_tap:(id)sender
{
    // changes blur effect setting
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 0:
        {
            _blurEffect = nil;
            _showWithVibrancy = NO;
            _label.textColor = [UIColor lightGrayColor];
            
            break;
        }
            
        case 1:
        {
            _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            _label.textColor = [UIColor darkTextColor];
            
            break;
        }
        case 2:
        {
            _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _label.textColor = [UIColor darkTextColor];
            
            break;
        }
        case 3:
        {
            _blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _label.textColor = [UIColor lightTextColor];
            
            break;
        }
            
        default:
            break;
    }
    
    button.selected = YES;
    for (UIView *subview in self.effectsControlView.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *otherButton = (UIButton *)subview;
            if (otherButton.tag != button.tag)
            {
                otherButton.selected = NO;
            }
            
            if (!_showWithVibrancy && otherButton.tag == 4) // vibrancy on
            {
                [otherButton setTitleColor:[UIColor colorWithRed:0.0/255.0 green:118.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            
            if (!_showWithVibrancy && otherButton.tag == 5) // vibrancy off
            {
                [otherButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        }
    }
    
    [self hideEffectsControlView];
}

- (IBAction)btnChangeVibrancyEffect_tap:(id)sender
{
    // changes vibrancy effect setting
    
    UIButton *button = (UIButton *)sender;
    switch (button.tag)
    {
        case 4:
        {
            _showWithVibrancy = NO;
            break;
        }
            
        case 5:
        {
            _showWithVibrancy = YES;
            break;
        }
            
        default:
            break;
    }
    
    [button setTitleColor:[UIColor colorWithRed:0.0/255.0 green:118.0/255.0 blue:255.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    for (UIView *subview in self.effectsControlView.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *otherButton = (UIButton *)subview;
            if (otherButton.tag != button.tag)
            {
                [otherButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }
        }
    }
    
    [self hideEffectsControlView];
}

#pragma mark -
#pragma mark Setup Blur and Vibrancy Effects

- (void)setupBlurEffectForSelectionDetailsView
{
    // this sets up the small box at the bottom of the main screen
    
    self.selectedDetailsView.backgroundColor = [UIColor clearColor];
    
    self.movieTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, self.selectedDetailsView.frame.size.width, 19)];
    self.movieTitle.textColor = [UIColor darkTextColor];
    
    self.movieTitle.textAlignment = NSTextAlignmentCenter;
    self.movieTitle.text = NSLocalizedString(@"Tim Burton Movies", nil);
    
    self.movieReleaseDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, self.selectedDetailsView.frame.size.width, 19)];
    self.movieReleaseDate.textColor = [UIColor darkTextColor];
    self.movieReleaseDate.textAlignment = NSTextAlignmentCenter;
    self.movieReleaseDate.text = NSLocalizedString(@"( use the menu to select a movie )", nil);
    
    // Blur Effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [bluredEffectView setFrame:self.selectedDetailsView.bounds];
    
    [self.selectedDetailsView addSubview:bluredEffectView];
    
    // Vibrancy Effect
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyEffectView setFrame:self.selectedDetailsView.bounds];
    
    // Add Label to Vibrancy View
    [vibrancyEffectView.contentView addSubview:self.movieTitle];
    [vibrancyEffectView.contentView addSubview:self.movieReleaseDate];
    
    // Add Vibrancy View to Blur View
    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
    // border radius
    [self.selectedDetailsView.layer setCornerRadius:8.0f];
    self.selectedDetailsView.clipsToBounds = YES;
}

- (void)setupEffectsForSelectionViewAndShowSelectionViewController
{
    // this sets up and displays the side panel selection view
    
    [_bluredEffectView removeFromSuperview];
    [_label removeFromSuperview];
    
    if (_blurEffect)
    {
        self.selectionViewPrimary.backgroundColor = [UIColor clearColor];
        
        // Blur Effect
        _bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
        _bluredEffectView.tag = 111;
        [_bluredEffectView setFrame:self.selectionViewPrimary.bounds];
        [self.selectionViewPrimary addSubview:_bluredEffectView];
        
        if (_showWithVibrancy)
        {
            // Vibrancy Effect
            UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:_blurEffect];
            UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
            [vibrancyEffectView setFrame:self.selectionViewPrimary.bounds];
            
            // Add Label to Vibrancy View
            [vibrancyEffectView.contentView addSubview:_label];
            
            // Add Vibrancy View to Blur View
            [_bluredEffectView.contentView addSubview:vibrancyEffectView];
        }
        else
        {
            [self.selectionViewSecondary addSubview:_label];
        }
        
    }
    else
    {
        self.selectionViewPrimary.backgroundColor = [UIColor darkGrayColor];
        [self.selectionViewSecondary addSubview:_label];
    }
    
    [self.selectionViewPrimary addSubview:self.selectionViewSecondary];
    
    [self showSelectionView];
}

#pragma mark -
#pragma mark View Animation Methods

- (void)showSelectionView
{
    self.btnShowMenu.tag = 1;
    
    [UIView animateWithDuration:0.25
                delay:0.0
                options: 0
                animations:^{
                    self.selectionViewPrimary.frame = CGRectMake(0, 0, self.selectionViewPrimary.frame.size.width, self.selectionViewPrimary.frame.size.height);
                        
                    self.showMenuView.frame = CGRectMake(self.selectionViewPrimary.frame.size.width, self.showMenuView.frame.origin.y, self.showMenuView.frame.size.width, self.showMenuView.frame.size.height);
                        
                    self.showMenuIcon.frame = CGRectMake(8, self.showMenuIcon.frame.origin.y, self.showMenuIcon.frame.size.width, self.showMenuIcon.frame.size.height);
                }
                completion:^(BOOL finished) {   }
     
     ];
}

- (void)hideSelectionView
{
    self.btnShowMenu.tag = 2;
    
    [UIView animateWithDuration:0.25
                delay:0.0
                options: 0
                animations:^{
                    self.selectionViewPrimary.frame = CGRectMake(-self.selectionViewPrimary.frame.size.width, 0, self.selectionViewPrimary.frame.size.width, self.selectionViewPrimary.frame.size.height);
                        
                    self.showMenuView.frame = CGRectMake(-11, self.showMenuView.frame.origin.y, self.showMenuView.frame.size.width, self.showMenuView.frame.size.height);
                        
                    self.showMenuIcon.frame = CGRectMake(20, self.showMenuIcon.frame.origin.y, self.showMenuIcon.frame.size.width, self.showMenuIcon.frame.size.height);
                }
                completion:^(BOOL finished) {   }
     
     ];
}

#pragma mark - Animation for Dynamically Changing Effects

- (void)showEffectsControlView
{
    self.btnShowControls.tag = 1;
    
    [UIView animateWithDuration:0.25
                delay:0.0
                options: 0
                animations:^{
                    self.effectsControlView.frame = CGRectMake(0, self.view.frame.size.height - self.effectsControlView.frame.size.height, self.effectsControlView.frame.size.width, self.effectsControlView.frame.size.height);
                }
                completion:^(BOOL finished) {   }
     
     ];
}

- (void)hideEffectsControlView
{
    self.btnShowControls.tag = 2;
    
    [UIView animateWithDuration:0.25
                delay:0.0
                options: 0
                animations:^{
                    self.effectsControlView.frame = CGRectMake(0,self.view.frame.size.height, self.effectsControlView.frame.size.width, self.effectsControlView.frame.size.height);
                }
                completion:^(BOOL finished) {   }
     
     ];
}


@end