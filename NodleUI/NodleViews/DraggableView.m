
#import "DraggableView.h"

@interface DraggableView ()

@property (nonatomic, assign) CGPoint pickedUpPosition;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation DraggableView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _draggable_view_setup];
    }
    return self;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0, 0, 100, 150)];
    if (self) {
    }
    return self;
}

- (void)_draggable_view_setup {
    self.panGestureRecognizer = \
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerChanged:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.tapGestureRecognizer = \
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerChanged:)];
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    self.tapGestureRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = UIColor.grayColor.CGColor;
    self.layer.borderWidth = 1.0;
}

#pragma mark - Setters & Getters

- (void)setPickedUp:(BOOL)pickedUp {
    if (_pickedUp == pickedUp) {
        return;
    }
    
    _pickedUp = pickedUp;
    
    if (_pickedUp) {
        [self.delegate draggableViewPickedUp:self];
    } else {
        [self.delegate draggableViewDropped:self];
    }
}

#pragma mark - Interaction handling

- (void)panGestureRecognizerChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.pickedUp = YES;
            self.pickedUpPosition = self.frame.origin;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panGestureRecognizer translationInView:self.superview];
            CGPoint viewPosition = CGPointMake(self.pickedUpPosition.x + translation.x, self.pickedUpPosition.y + translation.y);
            self.frame = CGRectMake(viewPosition.x, viewPosition.y, self.frame.size.width, self.frame.size.height);
            [self.delegate draggableView:self movedToPosition:viewPosition];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            self.pickedUp = NO;
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureRecognizerChanged:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (self.pickedUp) {
        return;
    }
    [self.delegate draggableViewTapped:self];
}

@end
