#import "NodeView.h"

@interface NodeView () <NodeConnectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIStackView *inputsStackView;
@property (nonatomic, strong) UIStackView *outputsStackView;

@end

@implementation NodeView
@dynamic delegate;

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
    [self addSubview:self.inputsStackView];

    self.outputsStackView = [UIStackView new];
    self.outputsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.outputsStackView.axis = UILayoutConstraintAxisVertical;
    [self addSubview:self.outputsStackView];
    
    for (NodeInput *input in self.node.inputs) {
        NodeInputView *inputView = [[NodeInputView alloc] initWithNodeInput:input];
        inputView.delegate = self;
        [self.panGestureRecognizer requireGestureRecognizerToFail:inputView.panGestureRecognizer];
        [self.inputsStackView addArrangedSubview:inputView];
    }

    for (NodeOutput *output in self.node.outputs) {
        NodeOutputView *outputView = [[NodeOutputView alloc] initWithNodeOutput:output];
        outputView.delegate = self;
        [self.panGestureRecognizer requireGestureRecognizerToFail:outputView.panGestureRecognizer];
        [self.outputsStackView addArrangedSubview:outputView];
    }
}

- (void)setupLayout {
    // Title
    [[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:Spacer] setActive:YES];
    [[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-Spacer] setActive:YES];
    [[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:Spacer] setActive:YES];
    
    // Inputs
    [[self.inputsStackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:Spacer] setActive:YES];
    [[self.inputsStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor] setActive:YES];
    [[self.inputsStackView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5] setActive:YES];

    // Outputs
    [[self.outputsStackView.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:Spacer] setActive:YES];
    [[self.outputsStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor] setActive:YES];
    [[self.outputsStackView.widthAnchor constraintEqualToAnchor:self.widthAnchor multiplier:0.5] setActive:YES];
}

- (void)updateData {
    self.titleLabel.text = self.node.nodeName;
}

- (void)updateTheme {
    self.backgroundColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    self.titleLabel.textColor = UIColor.whiteColor;
}

#pragma mark - Setters & Getters

- (NSArray<NodeInputView *> *)inputViews {
    return [self.inputsStackView subviews];
}

- (NSArray<NodeOutputView *> *)outputViews {
    return [self.outputsStackView subviews];
}

- (NodeInputView *)inputViewForNodeInput:(NodeInput *)nodeInput {
    for (NodeInputView *inputView in self.inputViews) {
        if (inputView.nodeInput == nodeInput) {
            return inputView;
        }
    }
    return nil;
}

- (NodeOutputView *)outputViewForNodeOutput:(NodeOutput *)nodeOutput {
    for (NodeOutputView *outputView in self.outputViews) {
        if (outputView.nodeOutput == nodeOutput) {
            return outputView;
        }
    }
    return nil;
}

#pragma mark - NodeConnectionViewDelegate

- (void)nodeConnectionViewTapped:(NodeConnectionView *)nodeConnectionView {
    [self.delegate nodeConnectionViewTapped:nodeConnectionView];
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStartPanAtOffset:(CGPoint)offset {
    CGPoint realPosition = [nodeConnectionView.gestureView convertPoint:offset toView:self.superview];
    [self.delegate nodeConnectionView:nodeConnectionView didStartPanAtOffset:realPosition];
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didPanToOffset:(CGPoint)offset withTranslation:(CGPoint)translation {
    CGPoint realPosition = [nodeConnectionView.gestureView convertPoint:offset toView:self.superview];
    [self.delegate nodeConnectionView:nodeConnectionView didPanToOffset:realPosition withTranslation:translation];
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStopPanAtOffset:(CGPoint)offset withTranslation:(CGPoint)translation {
    CGPoint realPosition = [nodeConnectionView.gestureView convertPoint:offset toView:self.superview];
    [self.delegate nodeConnectionView:nodeConnectionView didStopPanAtOffset:realPosition withTranslation:translation];
}

@end
