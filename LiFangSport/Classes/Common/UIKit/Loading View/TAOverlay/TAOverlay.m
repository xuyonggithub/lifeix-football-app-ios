//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// TAOverlay
// Copyright (c) 2015 TAIMUR AYAZ
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

#if !__has_feature(objc_arc)
#error TAOverlay is ARC only. Please turn on ARC for the project or use -fobjc-arc flag
#endif

#import "TAOverlay.h"

NSString * const TAOverlayWillDisappearNotification     = @"TAOverlayWillDisappearNotification";
NSString * const TAOverlayDidDisappearNotification      = @"TAOverlayDidDisappearNotification";
NSString * const TAOverlayWillAppearNotification        = @"TAOverlayWillAppearNotification";
NSString * const TAOverlayDidAppearNotification         = @"TAOverlayDidAppearNotification";
NSString * const TAOverlayProgressCompletedNotification = @"TAOverlayProgressCompletedNotification";

NSString * const TAOverlayLabelTextUserInfoKey          = @"TAOverlayLabelTextUserInfoKey";

#pragma mark UIImage Category Implementation

@implementation UIImage (TAOverlay)

- (UIImage *) maskImageWithColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

#pragma mark TAOverlay interface extension

static NSMutableSet *overlays = nil;

@interface TAOverlay ()

/** A boolean value indicating if the _overlay allows user _interaction. */
@property (nonatomic, assign) BOOL interaction;

/** A boolean value indicating if the _overlay shows a shadow _background. */
@property (nonatomic, assign) BOOL showBackground;

/** A boolean value indicating if the overlay's _background is blurred. */
@property (nonatomic, assign) BOOL showBlurred;

/** A boolean value indicating if the _overlay auto hides. */
@property (nonatomic, assign) BOOL shouldHide;

/** A boolean value indicating if the _overlay will hide. Used to control auto hide feature */
@property (nonatomic, assign) BOOL willAutoHide;
@property (nonatomic, assign) BOOL willHide;

/** A boolean value indicating if the _overlay is user dismissible by tap gesture. */
@property (nonatomic, assign) BOOL userDismissTap;

/** A boolean value indicating if the _overlay is user dismissible by swipe gesture. */
@property (nonatomic, assign) BOOL userDismissSwipe;

/** Gesture recognizer for tap gestures. */
@property (nonatomic, strong) UITapGestureRecognizer   *tapGesture;

/** Gesture recognizer for swipe up/down gestures. */
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpDownGesture;

/** Gesture recognizer for swipe left/right gestures. */
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftRightGesture;

@end

#pragma mark TAOverlay Implementation

@implementation TAOverlay


#pragma mark Show/Hide Methods

+ (void)hideOverlayInView:(UIView *)view
{
    for (TAOverlay *overlay in overlays) {
        if (view && ![overlay.rootView isDescendantOfView:view]) {
            continue;
        }
        [overlay overlayHideWithCompletionBlock:nil];
    }
}


- (void)hideOverlay
{
    [self overlayHideWithCompletionBlock:nil];
}

- (void)hideOverlayWithCompletion
{
    if (self.completionBlock != nil){
        [self overlayHideWithCompletionBlock:self.completionBlock];
    }
    else{
        [self overlayHideWithCompletionBlock:nil];
    }
}

- (void)hideOverlayWithCompletionBlock:(void (^)(BOOL))completionBlock
{
    [self overlayHideWithCompletionBlock:completionBlock];
}


- (void)analyzeOptions:(TAOverlayOptions)options image:(BOOL)hasImage imageArray:(BOOL)hasImageArray{
    if (self.willAutoHide) {
        self.willAutoHide = NO;
    }
    [TAOverlay hideOverlayInView:self.rootView];
    
    self.options = options;
    if (!hasImage && !hasImageArray)
    {
        if (OptionPresent(options, TAOverlayOptionOverlayTypeSuccess))
        {
            _overlayType = tOverlayTypeSucess;
        }
        else if (OptionPresent(options, TAOverlayOptionOverlayTypeActivityDefault))
        {
            _overlayType = tOverlayTypeActivityDefault;
        }
//        else if (OptionPresent(options, TAOverlayOptionOverlayTypeActivityLeaf))
//        {
//            _overlayType = tOverlayTypeActivityLeaf;
//        }
//        else if (OptionPresent(options, TAOverlayOptionOverlayTypeActivityBlur))
//        {
//            _overlayType = tOverlayTypeActivityBlur;
//        }
//        else if (OptionPresent(options, TAOverlayOptionOverlayTypeActivitySquare))
//        {
//            _overlayType = tOverlayTypeActivitySquare;
//        }
        else if (OptionPresent(options, TAOverlayOptionOverlayTypeWarning))
        {
            _overlayType = tOverlayTypeWarning;
        }
        else if (OptionPresent(options, TAOverlayOptionOverlayTypeError))
        {
            _overlayType = tOverlayTypeError;
        }
        else if (OptionPresent(options, TAOverlayOptionOverlayTypeInfo))
        {
            _overlayType = tOverlayTypeInfo;
        }
        else if (OptionPresent(options, TAOverlayOptionOverlayTypeProgress))
        {
            _overlayType = tOverlayTypeProgress;
        }
        else if (OptionPresent(options, TAOverlayOptionOverlayTypeText))
        {
            _overlayType = tOverlayTypeText;
        }
        else
        {
            _overlayType = tOverlayTypeActivityDefault;
//            _overlayType = tOverlayTypeActivityLeaf;
        }
    }
    else if (hasImage && !hasImageArray)
    {
        _overlayType = tOverlayTypeImage;
    }
    else if (!hasImage && hasImageArray)
    {
        _overlayType = tOverlayTypeImageArray;
    }

    if (OptionPresent(options, TAOverlayOptionOverlaySizeFullScreen))
    {
        _overlaySize = tOverlaySizeFullScreen;
    }
    else if (OptionPresent(options, TAOverlayOptionOverlaySizeBar))
    {
        _overlaySize = tOverlaySizeBar;
    }
    else if (OptionPresent(options, TAOverlayOptionOverlaySizeRoundedRect))
    {
        _overlaySize = tOverlaySizeRoundedRect;
    }
    else
    {
        _overlaySize = tOverlaySizeBar;
    }
    
    if (OptionPresent(options, TAOverlayOptionOpaqueBackground)){
        self.showBlurred = NO;
    }
    else{
        self.showBlurred = YES;
    }
    
    if (OptionPresent(options, TAOverlayOptionOverlayShadow)){
        _showBackground = YES;
    }
    else{
        _showBackground = NO;
    }
    
    if (OptionPresent(options, TAOverlayOptionAllowUserInteraction)){
        _interaction = NO;
    }
    else{
        _interaction = YES;
        if (OptionPresent(options, TAOverlayOptionOverlayDismissTap)){
            self.userDismissTap = YES;
        }
        else{
            self.userDismissTap = NO;
        }
        if (OptionPresent(options, TAOverlayOptionOverlayDismissSwipeDown) | OptionPresent(options, TAOverlayOptionOverlayDismissSwipeUp) | OptionPresent(options, TAOverlayOptionOverlayDismissSwipeLeft) | OptionPresent(options, TAOverlayOptionOverlayDismissSwipeRight)){
            self.userDismissSwipe = YES;
        }
        else{
            self.userDismissSwipe = NO;
        }
    }
    
    if (OptionPresent(options, TAOverlayOptionAutoHide)){
        _shouldHide = YES;
    }
    else{
        _shouldHide = NO;
    }
    
    [self setProperties];
    [self overlayMake:_overlayText];
}

- (void)setProperties {
    if (_overlayRectSize.width == 0) {
        _overlayRectSize.width = 100;
    }
    if (_overlayRectSize.height == 0) {
        _overlayRectSize.height = 100;
    }
    
    if (_iconSize.width == 0){
        _iconSize.width = 30;
    }
    if (_iconSize.height == 0) {
        _iconSize.height = 30;
    }
    
    if (_overlayFont == nil){
        _overlayFont = OVERLAY_LABEL_FONT;
    }
    
    if (_overlayFontColor == nil){
        _overlayFontColor = OVERLAY_LABEL_COLOR;
    }
    
    if (_overlayBackgroundColor == nil){
        _overlayBackgroundColor = OVERLAY_BACKGROUND_COLOR;
    }
    
    if (_overlayIconColor == nil){
        if (_overlayType == tOverlayTypeSucess){
            _overlayIconColor = OVERLAY_SUCCESS_COLOR;
        }
        else if (_overlayType == tOverlayTypeWarning){
            _overlayIconColor = OVERLAY_WARNING_COLOR;
        }
        else if (_overlayType == tOverlayTypeError){
            _overlayIconColor = OVERLAY_ERROR_COLOR;
        }
        else if (_overlayType == tOverlayTypeInfo){
            _overlayIconColor = OVERLAY_INFO_COLOR;
        }
    }
    
    _overlayProgress = 0.0;
    if (_overlayType == tOverlayTypeProgress && _overlayProgressColor == nil){
        _overlayProgressColor = OVERLAY_PROGRESS_COLOR;
    }
}

- (void)overlayMake:(NSString *)status
{
	[self overlayCreate];
    
     switch (_overlayType) {
             
         case tOverlayTypeSucess:
             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             _icon.strokeColor = nil;
             _icon.lineWidth = 0.0;
             [_icon setStrokeEnd:0.0];
             [CATransaction commit];
             _icon.path = [self bezierPathOfCheckSymbolWithRect:CGRectMake(0, 0, _iconSize.width, _iconSize.height) scale:0.5 thick:OVERLAY_ICON_THICKNESS].CGPath;
             _icon.fillColor = _icon.borderColor = _overlayIconColor.CGColor;
             [_image removeFromSuperview];   _image = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview]; _spinner = nil;
             break;
             
         case tOverlayTypeError:
             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             _icon.strokeColor = nil;
             _icon.lineWidth = 0.0;
             [_icon setStrokeEnd:0.0];
             [CATransaction commit];
             _icon.path = [self bezierPathOfCrossSymbolWithRect:CGRectMake(0, 0, _iconSize.width, _iconSize.height) scale:0.5 thick:OVERLAY_ICON_THICKNESS].CGPath;
             _icon.fillColor = _icon.borderColor = _overlayIconColor.CGColor;
             [_image removeFromSuperview];   _image = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview]; _spinner = nil;
             break;
             
         case tOverlayTypeWarning:
             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             _icon.strokeColor = nil;
             _icon.lineWidth = 0.0;
             [_icon setStrokeEnd:0.0];
             [CATransaction commit];
             _icon.path = [self bezierPathOfExcalmationSymbolWithRect:CGRectMake(0, 0, _iconSize.width, _iconSize.height) scale:0.5 thick:OVERLAY_ICON_THICKNESS].CGPath;
             _icon.fillColor = _icon.borderColor = _overlayIconColor.CGColor;
             [_icon setStrokeEnd:0.0];
             [_image removeFromSuperview];   _image = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview]; _spinner = nil;
             break;
             
         case tOverlayTypeInfo:
             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             _icon.strokeColor = nil;
             _icon.lineWidth = 0.0;
             [_icon setStrokeEnd:0.0];
             [CATransaction commit];
             _icon.path = [self bezierPathOfInfoSymbolWithRect:CGRectMake(0, 0, _iconSize.width, _iconSize.height) scale:0.5 thick:OVERLAY_ICON_THICKNESS].CGPath;
             _icon.fillColor = _icon.borderColor = _overlayIconColor.CGColor;
             [_image removeFromSuperview];   _image = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview]; _spinner = nil;
             break;
             
         case tOverlayTypeProgress:{
             if (!_ringBgIcon) {
                 _ringBgIcon = [self createRingLayerWithCenter:CGPointMake(_iconSize.width - OVERLAY_ICON_THICKNESS, _iconSize.height - OVERLAY_ICON_THICKNESS)
                                                        radius:(_iconSize.width - OVERLAY_ICON_THICKNESS)/2.0
                                                     lineWidth:OVERLAY_ICON_THICKNESS
                                                        color:HEXRGBCOLOR(0x767676)];
                 [_overlay.layer insertSublayer:_ringBgIcon below:_icon];
             }
             if (_icon) {
                 [_icon removeFromSuperlayer];
                 _icon = nil;
             }
             _icon = [self createRingLayerWithCenter:CGPointMake(_iconSize.width - OVERLAY_ICON_THICKNESS, _iconSize.height - OVERLAY_ICON_THICKNESS)
                                             radius:(_iconSize.width - OVERLAY_ICON_THICKNESS)/2.0
                                          lineWidth:OVERLAY_ICON_THICKNESS
                                              color:_overlayProgressColor];
             [_overlay.layer insertSublayer:_icon below:_icon];

             [CATransaction begin];
             [CATransaction setDisableActions:YES];
             [_icon setStrokeEnd:0.0];
             [CATransaction commit];
             _icon.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _iconSize.width - OVERLAY_ICON_THICKNESS, _iconSize.height - OVERLAY_ICON_THICKNESS) cornerRadius:(_iconSize.width - OVERLAY_ICON_THICKNESS)/2.0].CGPath;
             [_image removeFromSuperview];   _image = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview]; _spinner = nil;
         }
             break;
             
         case tOverlayTypeText:
             [_icon removeFromSuperlayer];   _icon = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview]; _spinner = nil;
             [_image removeFromSuperview];   _image = nil;
             break;
             
         case tOverlayTypeActivityDefault:
             [_icon removeFromSuperlayer];   _icon = nil;
             [_image removeFromSuperview];   _image = nil;
             [_spinner startAnimating];
             break;
/*
         case tOverlayTypeActivityLeaf:
             [_icon removeFromSuperlayer];   _icon = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview];    _spinner = nil;
             if (_image.image != nil) _image.image = nil;
             _image.frame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
             _image.animationImages = OVERLAY_ACTIVITY_LEAF_ARRAY;
             _image.animationDuration = 1;
             if (!_image.isAnimating) [_image startAnimating];
             _imageArray = nil;
             break;
             
         case tOverlayTypeActivityBlur:
             [_icon removeFromSuperlayer];   _icon = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview];    _spinner = nil;
             if (_image.image != nil) _image.image = nil;
             _image.frame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
             _image.animationImages = OVERLAY_ACTIVITY_BLUR_ARRAY;
             _image.animationDuration = 1;
             if (!_image.isAnimating) [_image startAnimating];
             _imageArray = nil;
             break;
             
         case tOverlayTypeActivitySquare:
             [_icon removeFromSuperlayer];   _icon = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview];    _spinner = nil;
             if (_image.image != nil) _image.image = nil;
             _image.frame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
             _image.animationImages = OVERLAY_ACTIVITY_SQUARE_ARRAY;
             _image.animationDuration = 0.35;
             if (!_image.isAnimating) [_image startAnimating];
             _imageArray = nil;
             break;
*/             
         case tOverlayTypeImage:
             [_icon removeFromSuperlayer];      _icon = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview];    _spinner = nil;
             if (_image.isAnimating) [_image stopAnimating];
             if (_imageArray != nil) _imageArray = nil;
             if (_image.image == nil) _image.image = _iconImage;
             if (_image.animationImages != nil) _image.animationImages = nil;
             _image.frame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
             break;
             
         case tOverlayTypeImageArray:
             [_icon removeFromSuperlayer];   _icon = nil;
             [_spinner stopAnimating];
             [_spinner removeFromSuperview];    _spinner = nil;
             if (_image.image != nil) _image.image = nil;
             _image.frame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
             _image.animationImages = _imageArray;
             _image.animationDuration = _customAnimationDuration;
             if (!_image.isAnimating) [_image startAnimating];
             _imageArray = nil;
             break;
     }
    if (status == nil) {
        [_label removeFromSuperview];
        _label = nil;
    }
    else {
        _label.text = status;
    }

    _background.userInteractionEnabled = _interaction;
    if (_overlayBackgroundColor) {
        _overlay.backgroundColor = _overlayBackgroundColor;
    }
    
    if (self.userDismissSwipe)
    {
        if (_swipeUpDownGesture == nil && (OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeUp) | OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeDown)))
        {
            _swipeUpDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            
            if (OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeUp))
            {
                _swipeUpDownGesture.direction = UISwipeGestureRecognizerDirectionUp;
            }
            if (OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeDown))
            {
                _swipeUpDownGesture.direction = (_swipeUpDownGesture.direction | UISwipeGestureRecognizerDirectionDown);
            }
            
            [_rootView addGestureRecognizer:_swipeUpDownGesture];
        }
        if (_swipeLeftRightGesture == nil && (OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeLeft) | OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeRight)))
        {
            _swipeLeftRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
            
            if (OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeLeft))
            {
                _swipeLeftRightGesture.direction = UISwipeGestureRecognizerDirectionLeft;
            }
            if (OptionPresent(self.options, TAOverlayOptionOverlayDismissSwipeRight))
            {
                _swipeLeftRightGesture.direction = (_swipeLeftRightGesture.direction | UISwipeGestureRecognizerDirectionRight);
            }
            
            [_rootView addGestureRecognizer:_swipeLeftRightGesture];
        }
    }
    
    if (_tapGesture == nil && self.userDismissTap)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_rootView addGestureRecognizer:_tapGesture];
    }
    
	[self overlayDimensionsWithNotification:nil];
	[self overlayShow];
    if (_shouldHide){
        [self autoHide];
    }
}

- (void)overlayCreate
{
	if (_overlay == nil)
	{
		_overlay = [[UIView alloc] initWithFrame:CGRectZero];
		_overlay.backgroundColor = [UIColor clearColor];
		_overlay.layer.masksToBounds = YES;
		[self registerNotifications];
	}
    
    if (!_rootView) {
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        if ([delegate respondsToSelector:@selector(window)]){
            _rootView = [delegate performSelector:@selector(window)];
        }
        else{
            _rootView = [[UIApplication sharedApplication] keyWindow];
        }
    }
    
 	if (_overlay.superview == nil)
	{
        if (_background == nil)
		{
			_background = [[UIView alloc] initWithFrame:_rootView.bounds];
            _background.backgroundColor = _backgroundColor ? : [UIColor clearColor];
            _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _background.alpha = 0.0;
			[_rootView addSubview:_background];
			[_background addSubview:_overlay];
		}
        else{
            [_rootView addSubview:_background];
        }
	}
    
 	if (_spinner == nil){
		_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_spinner.color = OVERLAY_ACTIVITY_DEFAULT_COLOR;
		_spinner.hidesWhenStopped = YES;
	}
    if (_spinner.superview == nil){
        [_overlay addSubview:_spinner];
    }
     
     if (_icon == nil){
         CGRect layerFrame = CGRectMake(0, 0, _iconSize.width, _iconSize.height);
         _icon = [CAShapeLayer layer];
         _icon.frame = layerFrame;
         _icon.borderWidth = OVERLAY_ICON_THICKNESS;
         _icon.cornerRadius = 20;
         _icon.opacity = 1.0;
         _icon.strokeColor = [UIColor clearColor].CGColor;
         _icon.lineWidth = 0.0;
         [_icon setStrokeEnd:0.0];
     }
    if (_icon.superlayer == nil){
        [_overlay.layer addSublayer:_icon];
    }
    
 	if (_image == nil){
		_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _iconSize.width, _iconSize.height)];
	}
    if (_image.superview == nil) {
        [_overlay addSubview:_image];
    }
    
 	if (_label == nil){
		_label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.font = _overlayFont;
		_label.textColor = _overlayFontColor;
		_label.backgroundColor = [UIColor clearColor];
		_label.textAlignment = NSTextAlignmentCenter;
		_label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		_label.numberOfLines = 0;
	}
    if (_label.superview == nil){
        [_overlay addSubview:_label];
    }
}

- (void)registerNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overlayDimensionsWithNotification:)
												 name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overlayDimensionsWithNotification:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overlayDimensionsWithNotification:) name:UIKeyboardDidHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overlayDimensionsWithNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overlayDimensionsWithNotification:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)overlayDestroy
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_tapGesture)
    {
        [_rootView removeGestureRecognizer:_tapGesture]; _tapGesture = nil;
    }
    if (_swipeUpDownGesture)
    {
        [_rootView removeGestureRecognizer:_swipeUpDownGesture]; _swipeUpDownGesture = nil;
    }
    if (_swipeLeftRightGesture)
    {
        [_rootView removeGestureRecognizer:_swipeLeftRightGesture]; _swipeLeftRightGesture = nil;
    }
    
    [_overlay.layer removeAllAnimations];
    [_background.layer removeAllAnimations];
 	[_label removeFromSuperview];		_label = nil;
	[_image removeFromSuperview];		_image = nil;
	[_spinner removeFromSuperview];		_spinner = nil;
	[_overlay removeFromSuperview];		_overlay = nil;
    [_icon removeFromSuperlayer];		_icon = nil;
    [_ringBgIcon removeFromSuperlayer];  _ringBgIcon = nil;
	[_background removeFromSuperview];	_background = nil;

}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineCapRound;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    return slice;
}

- (void)overlayDimensionsWithNotification:(NSNotification *)notification
{
	CGFloat heightKeyboard  = 0;
	NSTimeInterval duration = 0;
    CGRect labelRect = CGRectZero;
    CGFloat overlayWidth, overlayHeight, imagex, imagey;
    
    if (_background != nil) _background.frame = _rootView.bounds;
    
    switch (_overlaySize)
    {
        case tOverlaySizeBar:

            _overlay.layer.cornerRadius = 0;
            overlayWidth  = [[UIScreen mainScreen] bounds].size.width;
            overlayHeight = 100;
            
            if (_label.text != nil)
            {
                NSDictionary *attributes = @{NSFontAttributeName:_label.font};
                NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
                
                CGSize size = CGSizeMake(overlayWidth - 2.0*LABEL_PADDING_X, [self ifValue:667.000 IsValue:300.000 ThenValue:[UIScreen mainScreen].bounds.size.height]);
                
                if (ABOVE_IOS7) {
                    labelRect = [_label.text boundingRectWithSize:size options:options attributes:attributes context:NULL];
                }
                else{
                    labelRect.size = [_label.text sizeWithFont:_label.font
                                             constrainedToSize:size
                                                 lineBreakMode:_label.lineBreakMode];
                }
                
                if (_overlayType == tOverlayTypeText){
                    overlayHeight = (labelRect.size.height + LABEL_PADDING_TEXT_Y) > ([[UIScreen mainScreen] bounds].size.height - 2.0*LABEL_PADDING_X) ? ([[UIScreen mainScreen] bounds].size.height - 2.0*LABEL_PADDING_X) : (labelRect.size.height + LABEL_PADDING_TEXT_Y);
                }
                else{
                    overlayHeight = (labelRect.size.height + 20) > ([[UIScreen mainScreen] bounds].size.height - 2.0*LABEL_PADDING_X) ? ([[UIScreen mainScreen] bounds].size.height - 2.0*LABEL_PADDING_X) : (labelRect.size.height + 80);
                }
                
                
                labelRect.origin.x = overlayWidth/2.0 - labelRect.size.width/2.0;
                
                if (_overlayType == tOverlayTypeText)
                {
                    labelRect = CGRectMake(labelRect.origin.x, labelRect.origin.x, labelRect.size.width, overlayHeight - 2.0*labelRect.origin.x);
                }
                else
                {
                    labelRect.origin.y = LABEL_PADDING_Y;
                }
            }

            if (OptionPresent(self.options, TAOverlayOptionOverlayAnimateTransistions))
            {
                if (CGRectEqualToRect(_overlay.frame, CGRectZero))
                {
                    _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                    _label.frame = labelRect;
                }
                else
                {
                    [UIView animateWithDuration:notification ? ANIMATION_DURATION : 0.0f
                                     animations:^{
                        _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                        _label.frame = labelRect;
                    }];
                }
            }
            else
            {
                _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                _label.frame = labelRect;
            }
            
            imagex = overlayWidth/2;
            imagey = (_label.text == nil) ? overlayHeight/2 : LABEL_PADDING_Y+_iconSize.height/2;
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _image.center = _spinner.center = _icon.position = CGPointMake(imagex, imagey);
            [CATransaction commit];
            break;
            
        case tOverlaySizeFullScreen:

            _overlay.layer.cornerRadius = 0;
            overlayWidth  = [[UIScreen mainScreen] bounds].size.width;
            overlayHeight = [[UIScreen mainScreen] bounds].size.height;
            
            if (_label.text != nil)
            {
                NSDictionary *attributes = @{NSFontAttributeName:_label.font};
                NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
                CGSize size = CGSizeMake(overlayWidth - 2.0*LABEL_PADDING_X, [self ifValue:667.000 IsValue:300.000 ThenValue:[UIScreen mainScreen].bounds.size.height]) ;
            
                if (ABOVE_IOS7) {
                    labelRect = [_label.text boundingRectWithSize:size options:options attributes:attributes context:NULL];
                }
                else{
                    labelRect.size = [_label.text sizeWithFont:_label.font
                                            constrainedToSize:size
                                                lineBreakMode:_label.lineBreakMode];
                }
                
                labelRect.origin.x = overlayWidth/2.0 - labelRect.size.width/2.0;
                
                if (_overlayType == tOverlayTypeText)
                {
                    labelRect = CGRectMake(labelRect.origin.x, labelRect.origin.x, labelRect.size.width, overlayHeight - 2.0*labelRect.origin.x);
                }
                else
                {
                    labelRect.origin.y = (overlayHeight/2.0) + 16.0;
                }
            }
            
            if (OptionPresent(self.options, TAOverlayOptionOverlayAnimateTransistions))
            {
                if (CGRectEqualToRect(_overlay.frame, CGRectZero))
                {
                    _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                    _label.frame = labelRect;
                }
                else
                {
                    [UIView animateWithDuration:notification ? ANIMATION_DURATION : 0.0f
                                     animations:^{
                    
                        _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                        _label.frame = labelRect;
                    }];
                }
            }
            else
            {
                _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                _label.frame = labelRect;
            }

            
            imagex = overlayWidth/2;
            imagey = (_label.text == nil) ? overlayHeight/2 : (overlayHeight/2.0) - 14.0;
            
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _image.center = _spinner.center = _icon.position = CGPointMake(imagex, imagey);
            [CATransaction commit];
            
            break;
            
        case tOverlaySizeRoundedRect:

            _overlay.layer.cornerRadius = 10;
            overlayWidth = _overlayRectSize.width;
            overlayHeight = _overlayRectSize.height;
            if (_label.text != nil)
            {
                NSDictionary *attributes = @{NSFontAttributeName:_label.font};
                NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
                
                CGSize size = CGSizeMake(200, [self ifValue:667.000 IsValue:300.000 ThenValue:[UIScreen mainScreen].bounds.size.height]);
                if (ABOVE_IOS7) {
                    labelRect = [_label.text boundingRectWithSize:size options:options attributes:attributes context:NULL];
                }
                else{
                    labelRect.size = [_label.text sizeWithFont:_label.font
                                            constrainedToSize:size
                                                lineBreakMode:_label.lineBreakMode];
                }
                
                if (_overlayType == tOverlayTypeText){
                    overlayHeight = (labelRect.size.height + LABEL_PADDING_TEXT_Y * 2);
                }
                else{
                    overlayHeight = (labelRect.size.height + _iconSize.height + LABEL_PADDING_TEXT_Y * 2);
                }
                overlayHeight = MAX(_overlayRectSize.height, MIN(overlayHeight, [[UIScreen mainScreen] bounds].size.height - 2.0*LABEL_PADDING_X));
                overlayWidth = MAX(_overlayRectSize.width, labelRect.size.width + 2.0*LABEL_PADDING_X);
                
                labelRect.origin.x = overlayWidth/2 - labelRect.size.width/2;
                if (_overlayType == tOverlayTypeText){
                    labelRect.origin.y = overlayHeight/2 - labelRect.size.height/2;
                }
                else{
                    labelRect.origin.y = (_iconSize.height + LABEL_PADDING_TEXT_Y + overlayHeight)/2 - labelRect.size.height/2;
                }
            }
            
            if (OptionPresent(self.options, TAOverlayOptionOverlayAnimateTransistions))
            {
                if (CGRectEqualToRect(_overlay.frame, CGRectZero))
                {
                    _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                    _label.frame = labelRect;
                }
                else
                {
                    [UIView animateWithDuration:notification ? ANIMATION_DURATION : 0.0f
                                     animations:^{
                        _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                        _label.frame = labelRect;
                    }];
                }
            }
            else
            {
                _overlay.frame = CGRectMake(0, 0, overlayWidth, overlayHeight);
                _label.frame = labelRect;
            }
            
            imagex = overlayWidth/2;
            imagey = (_label.text == nil) ? overlayHeight/2 : LABEL_PADDING_TEXT_Y+_iconSize.height/2;
            
            if (_ringBgIcon) {
                _ringBgIcon.position = _icon.position;
            }
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            _image.center = _spinner.center = _icon.position = CGPointMake(imagex, imagey);
            if (_ringBgIcon) {
                _ringBgIcon.position = _icon.position;
            }
            [CATransaction commit];
            
            break;
    }
    
 	if (notification != nil)
	{
		NSDictionary *info = [notification userInfo];
		CGRect keyboard = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
		duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
		if ((notification.name == UIKeyboardWillShowNotification) || (notification.name == UIKeyboardDidShowNotification))
		{
			heightKeyboard = keyboard.size.height;
		}
	}
	else
    {
        heightKeyboard = [self visibleKeyboardHeight];
    }
 	CGRect screen = _overlay.superview.bounds;
	CGPoint center = CGPointMake(screen.size.width/2, (screen.size.height-heightKeyboard)/2);
//    [UIView animateWithDuration:notification ? duration : 0.0f
//                          delay:0
//                        options:UIViewAnimationOptionAllowUserInteraction animations:^
//    {
		_overlay.center = CGPointMake(center.x, center.y);
//	}
//    completion:nil];
}

- (CGFloat)visibleKeyboardHeight {
    
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")])
            return possibleKeyboard.bounds.size.height;
    }
    
    return 0;
}

- (NSDictionary *)getUserInfo
{
    return (_label.text ? @{TAOverlayLabelTextUserInfoKey : _label.text} : nil);
}

- (void)setProgress:(CGFloat)progress Animated:(BOOL)animated
{
    if (_overlayType == tOverlayTypeProgress)
    {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
        
            if (progress >= 1.0)
            {
                NSDictionary *userInfo = [self getUserInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:TAOverlayProgressCompletedNotification object:nil userInfo:userInfo];
            }
        }];
        
        if (animated)
        {
            [_icon setStrokeEnd:progress];
        }
        else
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [_icon setStrokeEnd:progress];
            [CATransaction commit];
        }
        
        [CATransaction commit];
    }
}

- (void)overlayShow
{
    
	if (![overlays containsObject:self])
	{
        
        if (!overlays) {
            overlays = [NSMutableSet set];
        }
        [overlays addObject:self];
        
        _overlay.alpha = 0.0f;
        NSDictionary *userInfo = [self getUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:TAOverlayWillAppearNotification
                                                            object:nil
                                                          userInfo:userInfo];

		_overlay.alpha = 0;
		_overlay.transform = CGAffineTransformScale(_overlay.transform, SCALE_TO, SCALE_TO);

		NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut;
		[UIView animateWithDuration:ANIMATION_DURATION delay:0 options:options animations:^{
			_overlay.transform = CGAffineTransformScale(_overlay.transform, SCALE_UNITY/SCALE_TO, SCALE_UNITY/SCALE_TO);
			_overlay.alpha = 1;
            _background.alpha = 1;
        } completion:^(BOOL completion){
            [[NSNotificationCenter defaultCenter] postNotificationName:TAOverlayDidAppearNotification
                                                                object:nil
                                                              userInfo:userInfo];
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, _label.text);
        }];
	}
}

- (void)overlayHideWithCompletionBlock:(void (^)(BOOL))completionBlock
{
	if ([overlays containsObject:self])
	{
        self.willHide = YES;
        NSDictionary *userInfo = [self getUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:TAOverlayWillDisappearNotification
                                                            object:nil
                                                          userInfo:userInfo];
        
        NSUInteger options = UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseIn;
        [UIView animateWithDuration:ANIMATION_DURATION delay:0 options:options animations:^{
            _overlay.transform = CGAffineTransformScale(_overlay.transform, SCALE_TO, SCALE_TO);
            _overlay.alpha = 0;
            _background.alpha = 0;
        }
                         completion:^(BOOL finished) {
                             [overlays removeObject:self];
                             
                             self.willHide = NO;
                             [self overlayDestroy];
                             UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:TAOverlayDidDisappearNotification
                                                                                 object:nil
                                                                               userInfo:userInfo];
                             if (completionBlock != nil)
                             {
                                 completionBlock(finished);
                             }
                         }];

	}
}

- (void)autoHide
{
    double length = _label.text.length;
    NSTimeInterval sleep = length * 0.04 + 0.8;
    self.willAutoHide = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sleep * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.willAutoHide){
            self.willAutoHide = NO;
            [self overlayHideWithCompletionBlock:_completionBlock];
        }
    });

}

#pragma mark Gesture Handlers
- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    if (self.userDismissTap){
        [self overlayHideWithCompletionBlock:_completionBlock];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture
{
    
    if (self.userDismissSwipe){
        [self overlayHideWithCompletionBlock:_completionBlock];
    }
}

#pragma mark Property Methods
- (void)setOverlayProgress:(CGFloat)overlayProgress
{
    _overlayProgress = MAX(0.0, overlayProgress);
    _overlayProgress = MIN(1.0, overlayProgress);
    [self setProgress:_overlayProgress Animated:YES];
}

#pragma mark Helper Methods
- (CGFloat) ifValue:(CGFloat)ifValue IsValue:(CGFloat)isValue ThenValue:(CGFloat)thenValue
{
    return (thenValue * isValue) / ifValue;
}

- (UIBezierPath *)bezierPathOfInfoSymbolWithRect:(CGRect)rect scale:(CGFloat)scale thick:(CGFloat)thick
{
    CGFloat height     = CGRectGetHeight(rect) * scale;
    CGFloat width      = CGRectGetWidth(rect)  * scale;
    CGFloat twoThirdHeight = height * 2.f / 3.f;
    CGFloat halfHeight = height / 2.f + (twoThirdHeight - height / 2.f)/2.f;
    CGFloat halfWidth  = width  / 2.f;
    CGFloat size       = height < width ? height : width;
    
    CGPoint offsetPoint =
    CGPointMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect)  - size) / 2.f,
                CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size) / 2.f);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointWithOffset(CGPointMake(halfWidth, (height - halfHeight) - thick * 2), offsetPoint)];
    [path addArcWithCenter:CGPointWithOffset(CGPointMake(halfWidth, (height - halfHeight) - thick * 2), offsetPoint) radius:thick startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path moveToPoint:CGPointWithOffset(CGPointMake(halfWidth - thick/2.0, (height - halfHeight)), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth + thick/2.0, (height - halfHeight)), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth + thick/2.0, height), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth - thick/2.0, height), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth - thick/2.0, (height - halfHeight)), offsetPoint)];
    [path closePath];
    return path;
}

- (UIBezierPath *)bezierPathOfExcalmationSymbolWithRect:(CGRect)rect scale:(CGFloat)scale thick:(CGFloat)thick
{
    CGFloat height     = CGRectGetHeight(rect) * scale;
    CGFloat width      = CGRectGetWidth(rect)  * scale;
    CGFloat twoThirdHeight = height * 2.f / 3.f;
    CGFloat halfHeight = height / 2.f + (twoThirdHeight - height / 2.f)/2.f;
    CGFloat halfWidth  = width  / 2.f;
    CGFloat size       = height < width ? height : width;
    
    CGPoint offsetPoint =
    CGPointMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect)  - size) / 2.f,
                CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size) / 2.f);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointWithOffset(CGPointMake(halfWidth - thick/2.0, 0.f), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth + thick/2.0, 0.f), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth + thick/2.0, halfHeight), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth - thick/2.0, halfHeight), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth - thick/2.0, 0.f), offsetPoint)];
    [path moveToPoint:CGPointWithOffset(CGPointMake(halfWidth, twoThirdHeight + thick * 3.f/2.f), offsetPoint)];
    [path addArcWithCenter:CGPointWithOffset(CGPointMake(halfWidth, twoThirdHeight + thick * 3.f/2.f), offsetPoint) radius:thick startAngle:0 endAngle:M_PI*2 clockwise:YES];
    [path closePath];
    return path;
}

- (UIBezierPath *)bezierPathOfCheckSymbolWithRect:(CGRect)rect scale:(CGFloat)scale thick:(CGFloat)thick
{
    CGFloat height, width;
    // height : width = 32 : 25
    if (CGRectGetHeight(rect) > CGRectGetWidth(rect)) {
        height = CGRectGetHeight(rect) * scale;
        width  = height * 32.f / 25.f;
    }
    else {
        width  = CGRectGetWidth(rect) * scale;
        height = width * 25.f / 32.f;
    }
    
    CGFloat topPointOffset    = thick / sqrt(2.f);
    CGFloat bottomHeight      = thick * sqrt(2.f);
    CGFloat bottomMarginRight = height - topPointOffset;
    CGFloat bottomMarginLeft  = width - bottomMarginRight;
    
    CGPoint offsetPoint = CGPointMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect)  - width) / 2.f,
                                      CGRectGetMinY(rect) + (CGRectGetHeight(rect) - height) / 2.f);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointWithOffset(CGPointMake(0.f, height - bottomMarginLeft), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(topPointOffset, height - bottomMarginLeft - topPointOffset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(bottomMarginLeft, height - bottomHeight), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(width - topPointOffset, 0.f), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(width, topPointOffset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(bottomMarginLeft, height), offsetPoint)];
    [path closePath];
    return path;
}

- (UIBezierPath *)bezierPathOfCrossSymbolWithRect:(CGRect)rect scale:(CGFloat)scale thick:(CGFloat)thick
{
    CGFloat height     = CGRectGetHeight(rect) * scale;
    CGFloat width      = CGRectGetWidth(rect)  * scale;
    CGFloat halfHeight = height / 2.f;
    CGFloat halfWidth  = width  / 2.f;
    CGFloat size       = height < width ? height : width;
    CGFloat offset     = thick / sqrt(2.f);
    
    CGPoint offsetPoint = CGPointMake(CGRectGetMinX(rect) + (CGRectGetWidth(rect)  - size) / 2.f,
                                      CGRectGetMinY(rect) + (CGRectGetHeight(rect) - size) / 2.f);
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointWithOffset(CGPointMake(0.f, offset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(offset, 0.f), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth, halfHeight - offset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(width - offset, 0.f), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(width, offset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth + offset, halfHeight), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(width, height - offset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(width - offset, height), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth, halfHeight + offset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(offset, height), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(0.f, height - offset), offsetPoint)];
    [path addLineToPoint:CGPointWithOffset(CGPointMake(halfWidth - offset, halfHeight), offsetPoint)];
    [path closePath];
    return path;
}

@end
