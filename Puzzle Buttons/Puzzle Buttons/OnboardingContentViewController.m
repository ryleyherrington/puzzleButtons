//
//  OnboardingContentViewController.m
//  Onboard
//
//  Created by Mike on 8/17/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

#import "OnboardingContentViewController.h"
#import "OnboardingViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



static NSString * const kDefaultOnboardingFont = @"HelveticaNeue-Light";

#define DEFAULT_TEXT_COLOR [UIColor whiteColor];

static CGFloat const kContentWidthMultiplier = 0.9;
static CGFloat const kDefaultImageViewSize = 100;
static CGFloat const kDefaultTopPadding = 60;
static CGFloat const kDefaultUnderIconPadding = 30;
static CGFloat const kDefaultUnderTitlePadding = 20;
static CGFloat const kDefaultBottomPadding = 0;
static CGFloat const kDefaultUnderPageControlPadding = 0;
static CGFloat const kDefaultTitleFontSize = 34;
static CGFloat const kDefaultBodyFontSize = 28;
static CGFloat const kDefaultButtonFontSize = 20;
static CGFloat const kArrowButtonWidth = 26.f;
static CGFloat const kArrowButtonHeight = 26.f;

static CGFloat const kActionButtonHeight = 50;
//static CGFloat const kMainPageControlHeight = 35;

@interface OnboardingContentViewController ()

@end

@implementation OnboardingContentViewController

+ (instancetype)contentWithTitle:(NSString *)title body:(NSString *)body backgroundImage:(UIImage*)backgroundImage image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    OnboardingContentViewController *contentVC = [[self alloc] initWithTitle:title body:body backgroundImage:backgroundImage image:image buttonText:buttonText action:action];
    return contentVC;
}

- (instancetype)initWithTitle:(NSString *)title body:(NSString *)body backgroundImage:(UIImage*)backgroundImage image:(UIImage *)image buttonText:(NSString *)buttonText action:(dispatch_block_t)action {
    self = [super init];

    // hold onto the passed in parameters, and set the action block to an empty block
    // in case we were passed nil, so we don't have to nil-check the block later before
    // calling
    _titleText = title;
    _body = body;
    _image = image;
    _backgroundImage = backgroundImage;
    _buttonText = buttonText;

    self.buttonActionHandler = action;
    
    // default auto-navigation
    self.movesToNextViewController = NO;
    
    // default icon properties
    if(_image) {
		self.iconHeight = _image.size.height;
		self.iconWidth = _image.size.width;
	}
    
    else {
		self.iconHeight = kDefaultImageViewSize;
		self.iconWidth = kDefaultImageViewSize;
	}
    
    // default title properties
    self.titleFontName = kDefaultOnboardingFont;
    self.titleFontSize = kDefaultTitleFontSize;
    
    // default body properties
    self.bodyFontName = kDefaultOnboardingFont;
    self.bodyFontSize = kDefaultBodyFontSize;
    
    // default button properties
    self.buttonFontName = kDefaultOnboardingFont;
    self.buttonFontSize = kDefaultButtonFontSize;
    
    // default padding values
    self.topPadding = kDefaultTopPadding;
    self.underIconPadding = kDefaultUnderIconPadding;
    self.underTitlePadding = kDefaultUnderTitlePadding;
    self.bottomPadding = kDefaultBottomPadding;
    self.underPageControlPadding = kDefaultUnderPageControlPadding;
    
    // default colors
    self.titleTextColor = DEFAULT_TEXT_COLOR;
    self.bodyTextColor = DEFAULT_TEXT_COLOR;
    self.buttonTextColor = DEFAULT_TEXT_COLOR;
    
    // default blocks
    self.viewWillAppearBlock = ^{};
    self.viewDidAppearBlock = ^{};
    self.viewWillDisappearBlock = ^{};
    self.viewDidDisappearBlock = ^{};

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // now that the view has loaded we can generate the content
    [self generateView];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if we have a delegate set, mark ourselves as the next page now that we're
    // about to appear
    if (self.delegate) {
        [self.delegate setNextPage:self];
    }
    
    // call our view will appear block
    if (self.viewWillAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillAppearBlock();
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // if we have a delegate set, mark ourselves as the current page now that
    // we've appeared
    if (self.delegate) {
        [self.delegate setCurrentPage:self];
    }
    
    // call our view did appear block
    if (self.viewDidAppearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidAppearBlock();
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // call our view will disappear block
    if (self.viewWillDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewWillDisappearBlock();
        });
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    // call our view did disappear block
    if (self.viewDidDisappearBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.viewDidDisappearBlock();
        });
    }
}

- (void)setButtonActionHandler:(dispatch_block_t)action {
    _buttonActionHandler = action ?: ^{};
}

- (void)generateView {
    // we want our background to be clear so we can see through it to the image provided
    self.view.backgroundColor = [UIColor whiteColor];
    
    // do some calculation for some common values we'll need, namely the width of the view,
    // the center of the width, and the content width we want to fill up, which is some
    // fraction of the view width we set in the multipler constant
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat horizontalCenter = viewWidth / 2;
    CGFloat contentWidth = viewWidth * kContentWidthMultiplier;

    
    // create the image view with the appropriate image, size, and center in on screen
    _imageView = [[UIImageView alloc] initWithImage:_image];
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
    if (_backgroundImage == nil)
        [_imageView setBackgroundColor:_baseColor];
    else
        [_imageView setBackgroundColor:[UIColor clearColor]];
    
    if (_isFirst){
    [_imageView setFrame:CGRectMake(0,
                                    0,
                                    viewWidth*.8,
                                    viewHeight * 3 / 5)];
    }else {
        [_imageView setFrame:CGRectMake(0,
                                        0,
                                        viewWidth,
                                        viewHeight * 3 / 5)];
    }
    [self.view addSubview:_imageView];
    
    UIView* autolayoutHelperView = [[UIView alloc] init];
    [autolayoutHelperView setFrame:CGRectMake(0,
                                              0,
                                              viewWidth,
                                              viewHeight * 3 / 5)];
    autolayoutHelperView.hidden = YES;
    [self.view addSubview:autolayoutHelperView];
    
    _backgroundImageView = [[UIImageView alloc] initWithImage:_backgroundImage];
    [_backgroundImageView setContentMode:UIViewContentModeScaleToFill];
    [_backgroundImageView setBackgroundColor:[UIColor clearColor]];//[TPIConstants baseColorLight]];
    [_backgroundImageView setFrame:CGRectMake(0,
                                              0,
                                              viewWidth,
                                              viewHeight * 3 / 5)];
    
    [self.view bringSubviewToFront:_imageView];
    
    
    [self.view addSubview:_backgroundImageView];
       
    //send background to back
    [self.view sendSubviewToBack:_backgroundImageView];
   
    
    // create and configure the main text label sitting underneath the icon with the provided padding
    _mainTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(autolayoutHelperView.frame) + self.underIconPadding,
                                                               contentWidth,
                                                               0)];
    _mainTextLabel.text = _titleText;
    _mainTextLabel.textColor = [UIColor darkGrayColor];
    
    if(IS_IPHONE_4_OR_LESS){
        _mainTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    } else if(IS_IPHONE_5){
        _mainTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26];
    } else {
        _mainTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    }
    _mainTextLabel.numberOfLines = 0;
    _mainTextLabel.textAlignment = NSTextAlignmentCenter;
    [_mainTextLabel sizeToFit];
    _mainTextLabel.center = CGPointMake(horizontalCenter, _mainTextLabel.center.y-20);
    [self.view addSubview:_mainTextLabel];
    
    // create and configure the sub text label
    _subTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mainTextLabel.frame) + self.underTitlePadding, contentWidth, 0)];
    _subTextLabel.text = _body;
    _subTextLabel.textColor = [UIColor grayColor];
    if(IS_IPHONE_4_OR_LESS){
        _subTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    }else {
        _subTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    }
    _subTextLabel.numberOfLines = 0;
    _subTextLabel.textAlignment = NSTextAlignmentCenter;
    [_subTextLabel sizeToFit];
    _subTextLabel.center = CGPointMake(horizontalCenter, _subTextLabel.center.y);
    [self.view addSubview:_subTextLabel];
    
    // create the action button if we were given button text
    if (_buttonText) {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100,
                                                                   self.view.frame.size.height-kActionButtonHeight - 20, //for status bar
                                                                   100,
                                                                   kActionButtonHeight)];
        _actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        [_actionButton setTitle:_buttonText forState:UIControlStateNormal];
        [_actionButton setTitleColor:_baseColor forState:UIControlStateNormal]; //[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionButton];
    } else {
        _actionButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 2 * kArrowButtonWidth,
                                                                   self.view.frame.size.height- kArrowButtonHeight - 25, //just 5 px of padding + 20 for status bar
                                                                   kArrowButtonWidth,
                                                                   kArrowButtonHeight)];
        
        [_actionButton setTintColor:_baseColor];
        [_actionButton setImage:[UIImage imageNamed:@"rightarrow"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(handleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionButton];
    }
}


#pragma mark - Transition alpha

- (void)updateAlphas:(CGFloat)newAlpha {
    _imageView.alpha = newAlpha;
    _backgroundImageView.alpha = newAlpha;
    _mainTextLabel.alpha = newAlpha;
    _subTextLabel.alpha = newAlpha;
    _actionButton.alpha = newAlpha;
}


#pragma mark - action button callback

- (void)handleButtonPressed {
    // if we want to navigate to the next view controller, tell our delegate
    // to handle it
    if (self.movesToNextViewController) {
        [self.delegate moveNextPage];
    }
    
    // call the provided action handler
    if (_buttonActionHandler) {
        _buttonActionHandler();
    }
}

@end
