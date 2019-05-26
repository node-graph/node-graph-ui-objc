#import "NodeConnectionView.h"

@interface NodeConnectionView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) CGPoint panStartPosition;
@property (nonatomic, assign) CGPoint touchDownPosition;
@property (nonatomic, assign, getter=isPanning) BOOL panning;

@end

@implementation NodeConnectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __setup];
    }
    return self;
}

- (void)__setup {
    // Only handle one interaction at a time
    self.multipleTouchEnabled = NO;
    
    self.panGestureRecognizer = \
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerChanged:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    
    self.tapGestureRecognizer = \
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerChanged:)];
    self.tapGestureRecognizer.numberOfTouchesRequired = 1;
    self.tapGestureRecognizer.numberOfTapsRequired = 1;

    [self setGestureView:self];
}

- (void)panGestureRecognizerChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self.gestureView];
    CGPoint realPosition = [self addPoint1:self.panStartPosition andPoint2:translation];

    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.panning = YES;
            self.panStartPosition = self.touchDownPosition;
            realPosition = [self addPoint1:self.panStartPosition andPoint2:translation];
            [self.delegate nodeConnectionView:self didStartPanAtOffset:realPosition];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self.delegate nodeConnectionView:self didPanToOffset:realPosition withTranslation:translation];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            self.panning = NO;
            [self.delegate nodeConnectionView:self didStopPanAtOffset:realPosition withTranslation:translation];
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureRecognizerChanged:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.delegate nodeConnectionViewTapped:self];
}

- (void)setGestureView:(UIView *)gestureView {
    if (_gestureView == gestureView) {
        return;
    }
    
    [_gestureView removeGestureRecognizer:self.tapGestureRecognizer];
    [_gestureView removeGestureRecognizer:self.panGestureRecognizer];
    
    _gestureView = gestureView;
    
    [_gestureView addGestureRecognizer:self.tapGestureRecognizer];
    [_gestureView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.touchDownPosition = [[touches anyObject] locationInView:self.gestureView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.isPanning) {
        return;
    }
    self.touchDownPosition = [[touches anyObject] locationInView:self.gestureView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.touchDownPosition = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.touchDownPosition = CGPointZero;
}

- (CGPoint)addPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

@end
