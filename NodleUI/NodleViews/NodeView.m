#import "NodeView.h"

@interface NodeView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *inputsStackView;
@property (nonatomic, strong) UIStackView *outputsStackView;

@end

@implementation NodeView

- (instancetype)initWithNode:(id<Node>)node {
    self = [super init];
    if (self) {
        _node = node;
        [self setup];
        [self setupLayout];
        [self updateData];
        [self updateTheme];
    }
    return self;
}

- (void)setup {
    
    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

- (void)setupLayout {
    [[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:Spacer] setActive:YES];
    [[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-Spacer] setActive:YES];
    [[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:Spacer] setActive:YES];
}

- (void)updateData {
    self.titleLabel.text = self.node.nodeName;
}

- (void)updateTheme {
    self.backgroundColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    self.titleLabel.textColor = UIColor.whiteColor;
}

@end
