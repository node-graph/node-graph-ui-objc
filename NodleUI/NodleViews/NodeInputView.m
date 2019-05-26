#import "NodeInputView.h"

@interface NodeInputView ()

@property (nonatomic, strong) UIView *connectionPointView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NodeInputView

- (instancetype)initWithNodeInput:(NodeInput *)nodeInput {
    self = [super initWithFrame:CGRectMake(0, 0, 40, 20)];
    if (self) {
        _nodeInput = nodeInput;
        [self setup];
        [self setupLayout];
    }
    return self;
}

- (void)setup {
    self.connectionPointView = [UIView new];
    self.connectionPointView.translatesAutoresizingMaskIntoConstraints = NO;
    self.connectionPointView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.3];
    self.connectionPointView.layer.cornerRadius = 10;
    [self addSubview:self.connectionPointView];

    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = self.nodeInput.key ?: @"";
    self.titleLabel.textColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    
    [self setGestureView:self.connectionPointView];
}

- (void)setupLayout {
    [[self.connectionPointView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[self.connectionPointView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[self.connectionPointView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.6] setActive:YES];
    [[self.connectionPointView.widthAnchor constraintEqualToAnchor:self.connectionPointView.heightAnchor] setActive:YES];
    
    [[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.connectionPointView.trailingAnchor constant:4.0] setActive:YES];
    [[self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[self.titleLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
    [[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
}

@end
