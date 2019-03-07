#import "ConnectionView.h"

@interface NSLayoutConstraint (Helpers)
- (instancetype)withPriority:(UILayoutPriority)priority;
@end

@implementation NSLayoutConstraint (Helpers)
- (instancetype)withPriority:(UILayoutPriority)priority {
    self.priority = priority;
    return self;
}
@end

@interface ConnectionView ()

@property (nonatomic, strong) UIView *leadingConnectionPointView;
@property (nonatomic, strong) UIView *trailingConnectionPointView;
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@end

@implementation ConnectionView

#pragma mark - Lifecycle

- (instancetype)initWithLeadingView:(UIView *)leadingView
                       trailingView:(UIView *)trailingView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _leadingView = leadingView;
        _trailingView = trailingView;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.userInteractionEnabled = NO;
    
    self.leadingConnectionPointView = [UIView new];
    [self addSubview:self.leadingConnectionPointView];
    self.leadingConnectionPointView.backgroundColor = [UIColor.yellowColor colorWithAlphaComponent:0.5];
    self.leadingConnectionPointView.layer.cornerRadius = 5.0;
    self.leadingConnectionPointView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.leadingConnectionPointView.widthAnchor constraintEqualToConstant:10.0] setActive:YES];
    [[self.leadingConnectionPointView.heightAnchor constraintEqualToAnchor:self.leadingConnectionPointView.widthAnchor] setActive:YES];
    
    self.trailingConnectionPointView = [UIView new];
    [self addSubview:self.trailingConnectionPointView];
    self.trailingConnectionPointView.backgroundColor = [UIColor.yellowColor colorWithAlphaComponent:0.5];
    self.trailingConnectionPointView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.trailingConnectionPointView.widthAnchor constraintEqualToAnchor:self.leadingConnectionPointView.widthAnchor] setActive:YES];
    [[self.trailingConnectionPointView.heightAnchor constraintEqualToAnchor:self.trailingConnectionPointView.widthAnchor] setActive:YES];
    
    self.lineLayer = [CAShapeLayer new];
    self.lineLayer.strokeColor = UIColor.whiteColor.CGColor;
    self.lineLayer.lineWidth = 2.0;
    self.lineLayer.fillColor = UIColor.clearColor.CGColor;
    
    [self.layer addSublayer:self.lineLayer];
}

- (void)setupLayout {
    [[self.leadingAnchor constraintLessThanOrEqualToAnchor:self.leadingView.trailingAnchor] setActive:YES];
    [[[self.leadingAnchor constraintEqualToAnchor:self.trailingView.leadingAnchor constant:-self.spacer] withPriority:UILayoutPriorityDefaultLow] setActive:YES];
    
    [[self.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.trailingView.leadingAnchor] setActive:YES];
    [[[self.trailingAnchor constraintEqualToAnchor:self.leadingView.trailingAnchor constant:self.spacer] withPriority:UILayoutPriorityDefaultLow] setActive:YES];
    
    [[self.topAnchor constraintLessThanOrEqualToAnchor:self.leadingView.topAnchor] setActive:YES];
    [[self.topAnchor constraintLessThanOrEqualToAnchor:self.trailingView.topAnchor] setActive:YES];
    [[[self.topAnchor constraintEqualToAnchor:self.leadingView.topAnchor] withPriority:UILayoutPriorityDefaultLow] setActive:YES];
    [[[self.topAnchor constraintEqualToAnchor:self.trailingView.topAnchor] withPriority:UILayoutPriorityDefaultLow] setActive:YES];
    
    [[self.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.leadingView.bottomAnchor] setActive:YES];
    [[self.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.trailingView.bottomAnchor] setActive:YES];
    [[[self.bottomAnchor constraintEqualToAnchor:self.leadingView.bottomAnchor] withPriority:UILayoutPriorityDefaultLow] setActive:YES];
    [[[self.bottomAnchor constraintEqualToAnchor:self.trailingView.bottomAnchor] withPriority:UILayoutPriorityDefaultLow] setActive:YES];
    
    
    [[self.leadingConnectionPointView.centerYAnchor constraintEqualToAnchor:self.leadingView.centerYAnchor] setActive:YES];
    [[self.leadingConnectionPointView.leadingAnchor constraintEqualToAnchor:self.leadingView.trailingAnchor] setActive:YES];

    [[self.trailingConnectionPointView.centerYAnchor constraintEqualToAnchor:self.trailingView.centerYAnchor] setActive:YES];
    [[self.trailingConnectionPointView.trailingAnchor constraintEqualToAnchor:self.trailingView.leadingAnchor] setActive:YES];
}

- (void)didMoveToWindow {
    if (!self.window) {
        return;
    }
    [self setupLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineLayer.path = [self updatedPathForLineType:self.lineType].CGPath;
}

#pragma mark - Setters & Getters

- (void)setSpacer:(CGFloat)spacer {
    if (_spacer == spacer) {
        return;
    }
    _spacer = spacer;
    [self remount];
}

- (void)setLineType:(ConnectionViewLineType)lineType {
    if (_lineType == lineType) {
        return;
    }
    _lineType = lineType;
    self.lineLayer.path = [self updatedPathForLineType:_lineType].CGPath;
}

- (UIBezierPath *)updatedPathForLineType:(ConnectionViewLineType)lineType {
    switch (lineType) {
        case ConnectionViewLineTypeSquareRounded:
            return [self updatedConnectionLinePathSquareRounded];
        case ConnectionViewLineTypeSquare:
            return [self updatedConnectionLinePathSquare];
        case ConnectionViewLineTypeCurvy:
            return [self updatedConnectionLinePathCurvy];
        case ConnectionViewLineTypeStraightLine:
            return [self updatedConnectionLinePathStraightLine];
    }
    return [self updatedConnectionLinePathSquareRounded];
}

#pragma mark - Actions

- (void)remount {
    UIView *superView = self.superview;
    if (!superView) {
        return;
    }
    [self removeFromSuperview];
    [superView addSubview:self];
}

- (UIBezierPath *)updatedConnectionLinePathStraightLine {
    CGPoint startPoint = self.leadingConnectionPointView.center;
    CGPoint endPoint = self.trailingConnectionPointView.center;
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    
    return path;
}

- (UIBezierPath *)updatedConnectionLinePathCurvy {
    CGPoint startPoint = self.leadingConnectionPointView.center;
    CGPoint endPoint = self.trailingConnectionPointView.center;
    CGSize size = self.bounds.size;
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:startPoint];
    
    [path addCurveToPoint:endPoint controlPoint1:CGPointMake(size.width/2, startPoint.y) controlPoint2:CGPointMake(size.width/2, endPoint.y)];
    
    return path;
}

- (UIBezierPath *)updatedConnectionLinePathSquare {
    CGPoint startPoint = self.leadingConnectionPointView.center;
    CGPoint endPoint = self.trailingConnectionPointView.center;
    CGSize size = self.bounds.size;
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(size.width/2, startPoint.y)];
    [path addLineToPoint:CGPointMake(size.width/2, endPoint.y)];
    [path addLineToPoint:endPoint];
    
    return path;
}

- (UIBezierPath *)updatedConnectionLinePathSquareRounded {
    CGSize size = self.bounds.size;
    CGPoint startPoint = self.leadingConnectionPointView.center;
    CGPoint endPoint = self.trailingConnectionPointView.center;
    CGSize lineBounds = CGSizeMake(fabs(startPoint.x - endPoint.x), fabs(startPoint.y - endPoint.y));
    CGFloat arcRadius = MIN(MIN(lineBounds.width, lineBounds.height) / 4, 20.0);
    BOOL lineForward = startPoint.x < endPoint.x;
    BOOL lineUp = startPoint.y > endPoint.y;
    
    // Angles M_PI_2: 0.0 = right, 1.0 = down, 2.0 = left, 3.0 = up
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:startPoint];
    
    // Move to first arc start
    [path addLineToPoint:CGPointMake(size.width/2 + (lineForward ? -arcRadius : arcRadius) * 2, startPoint.y)];

    // First arc
    [path addCurveToPoint:CGPointMake(size.width/2, startPoint.y + (lineUp ? -arcRadius : arcRadius) * 2)
            controlPoint1:CGPointMake(size.width/2 + (lineForward ? -arcRadius : arcRadius), startPoint.y)
            controlPoint2:CGPointMake(size.width/2, startPoint.y + (lineUp ? -arcRadius : arcRadius))];

    // Vertical line
    [path addLineToPoint:CGPointMake(size.width/2, endPoint.y + (lineUp ? arcRadius : -arcRadius) * 2)];

    // Second arc
    [path addCurveToPoint:CGPointMake(size.width/2 + (lineForward ? arcRadius : -arcRadius) * 2, endPoint.y)
            controlPoint1:CGPointMake(size.width/2, endPoint.y + (lineUp ? arcRadius : -arcRadius))
            controlPoint2:CGPointMake(size.width/2 + (lineForward ? arcRadius : -arcRadius), endPoint.y)];

    
    // End
    [path addLineToPoint:endPoint];
    
    return path;
}

@end
