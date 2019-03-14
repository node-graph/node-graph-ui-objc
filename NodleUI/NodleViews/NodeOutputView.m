#import "NodeOutputView.h"

@interface NodeOutputView ()

@property (nonatomic, strong) UIView *connectionPointView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation NodeOutputView

- (instancetype)initWithNodeOutput:(NodeOutput *)nodeOutput {
    self = [super initWithFrame:CGRectMake(0, 0, 40, 20)];
    if (self) {
        _nodeOutput = nodeOutput;
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
    self.titleLabel.text = self.nodeOutput.key ?: @"";
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.titleLabel];
}

- (void)setupLayout {
    [[self.connectionPointView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[self.connectionPointView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[self.connectionPointView.heightAnchor constraintEqualToAnchor:self.heightAnchor multiplier:0.6] setActive:YES];
    [[self.connectionPointView.widthAnchor constraintEqualToAnchor:self.connectionPointView.heightAnchor] setActive:YES];
    
    [[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[self.titleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor] setActive:YES];
    [[self.titleLabel.heightAnchor constraintEqualToAnchor:self.heightAnchor] setActive:YES];
    [[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.connectionPointView.leadingAnchor constant:-4.0] setActive:YES];
}

@end
