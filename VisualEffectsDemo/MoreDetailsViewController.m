//
//  MoreDetailsViewController.m
//  VisualEffectsDemo
//
//  Copyright (c) 2014 Tammy Coron. All rights reserved.
//

#import "MoreDetailsViewController.h"

@interface MoreDetailsViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *mainImageView;
@property (nonatomic, weak) IBOutlet UIView *selectedDetailsView;

@property (nonatomic, strong) IBOutlet UILabel *movieTitle;
@property (nonatomic, strong) IBOutlet UILabel *movieReleaseDate;

@property (nonatomic, strong) IBOutlet UITextView *movieDetails;

@end

@implementation MoreDetailsViewController

#pragma mark -
#pragma mark Init View

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    
    // fixing bug for entering view
    self.mainImageView.hidden = NO;
    self.mainImageView.image = self.imageFromPreviousScreen;
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
    
    // fixing bug for leaving view
    self.view.backgroundColor = [UIColor clearColor];
    self.mainImageView.hidden = YES;
}

#pragma mark -
#pragma mark View Setup

- (void)setupView
{
    self.selectedDetailsView.backgroundColor = [UIColor clearColor];
    
    self.movieTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, self.selectedDetailsView.frame.size.width, 19)];
    self.movieTitle.textColor = [UIColor lightTextColor];
    self.movieTitle.textAlignment = NSTextAlignmentCenter;
    
    self.movieReleaseDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.selectedDetailsView.frame.size.width, 19)];
    self.movieReleaseDate.textColor = [UIColor lightTextColor];
    self.movieReleaseDate.textAlignment = NSTextAlignmentCenter;
    
    self.movieDetails = [[UITextView alloc] initWithFrame:CGRectMake(0, 165, self.selectedDetailsView.frame.size.width, 345)];
    self.movieDetails.textColor = [UIColor lightTextColor];
    self.movieDetails.backgroundColor = [UIColor clearColor];
    self.movieDetails.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.movieDetails.textContainerInset = UIEdgeInsetsMake(0, 12, 0, 12);
    self.movieDetails.editable = NO;
    
    // Blur Effect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
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
    [vibrancyEffectView.contentView addSubview:self.movieDetails];
    
    // Add Vibrancy View to Blur View
    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
    long selectedItem = [[NSUserDefaults standardUserDefaults] integerForKey:@"_selectedItem"];
    [self setupSelectedDetails:selectedItem];
}

- (void)setupSelectedDetails:(long )selectedItem
{
    switch (selectedItem)
    {
        case 5:
        {
            self.movieTitle.text = NSLocalizedString(@"Tim Burton", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"August 25, 1958", nil);
            self.mainImageView.image = [UIImage imageNamed:@"tim_burton_the_man.jpg"];
            self.movieDetails.text = @"Timothy Walter 'Tim' Burton is an American film director, producer, artist, writer, poet and stop motion artist. He is known for his dark, gothic, macabre and quirky horror and fantasy films such as Beetlejuice, Edward Scissorhands, The Nightmare Before Christmas, Ed Wood, Sleepy Hollow, Corpse Bride, Sweeney Todd: The Demon Barber of Fleet Street, Dark Shadows and Frankenweenie, and for blockbusters such as Pee-wee's Big Adventure, Batman, its first sequel Batman Returns, Planet of the Apes, Charlie and the Chocolate Factory and Alice in Wonderland.";
            
            break;
        }
            
        case 1:
        {
            self.movieTitle.text = NSLocalizedString(@"9", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"9 September 2009 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_9.jpg"];
            self.movieDetails.text = @"A rag doll that awakens in a post-apocalyptic future holds the key to humanity's salvation.";
            
            break;
        }
            
        case 2:
        {
            self.movieTitle.text = NSLocalizedString(@"Corpse Bride", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"23 September 2005 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_corpse.jpg"];
            self.movieDetails.text = @"When a shy groom practices his wedding vows in the inadvertent presence of a deceased young woman, she rises from the grave assuming he has married her.";
            
            break;
        }
            
        case 3:
        {
            self.movieTitle.text = NSLocalizedString(@"Frankenweenie", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"5 October 2012 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_frankenweenie.jpg"];
            self.movieDetails.text = @"Young Victor conducts a science experiment to bring his beloved dog Sparky back to life, only to face unintended, sometimes monstrous, consequences.";
            
            break;
        }
            
        case 4:
        {
            self.movieTitle.text = NSLocalizedString(@"The Nightmare Before Christmas", nil);
            self.movieReleaseDate.text = NSLocalizedString(@"29 October 1993 (USA)", nil);
            self.mainImageView.image = [UIImage imageNamed:@"movie_nightmare.jpg"];
            self.movieDetails.text = @"Jack Skellington, king of Halloweentown, discovers Christmas Town, but doesn't quite understand the concept.";
            
            break;
        }
            
        default:
            break;
    }
}

@end