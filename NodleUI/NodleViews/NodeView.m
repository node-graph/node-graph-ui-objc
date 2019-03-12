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
    
    self.inputsStackView = [UIStackView new];
    self.inputsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputsStackView.axis = UILayoutConstraintAxisVertical;
//    self.inputsStackView.directionalLayoutMargins
    [self addSubview:self.inputsStackView];
    
    for (NodeInput *input in self.node.inputs) {
        UILabel *inputLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        inputLabel.text = input.key ?: @"no_key";
        inputLabel.textColor = UIColor.whiteColor;
        inputLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:0.2];
        [self.inputsStackView addArrangedSubview:inputLabel];
    }
}

- (void)setupLayout {
    // Title
    [[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:Spacer] setActive:YES];
    [[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-Spacer] setActive:YES];
    [[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:Spacer] setActive:YES];
    
    // Inputs
    [[self.inputsStackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:Spacer] setActive:YES];
    [[self.inputsStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:Spacer] setActive:YES];
    [[self.inputsStackView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5] setActive:YES];
}

- (void)updateData {
    self.titleLabel.text = self.node.nodeName;
}

- (void)updateTheme {
    self.backgroundColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    self.titleLabel.textColor = UIColor.whiteColor;
}

@end
