#import "ViewController.h"
#import "NodeView.h"
#import "ConnectionView.h"

@interface ViewController () <DraggableViewDelegate>

@property (nonatomic, strong) NSMutableArray<NodeView *> *nodeViews;
@property (nonatomic, strong) NSMutableArray<ConnectionView *> *connectionViews;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    self.nodeViews = [NSMutableArray array];
    self.connectionViews = [NSMutableArray array];

    NSUInteger count = 6;
    for (NSUInteger i = 0; i < count; i++) {
        RGBNode *rgbNode = [RGBNode new];
        NodeView *nodeView = [[NodeView alloc] initWithNode:rgbNode];
        nodeView.center = CGPointMake(50 + (320 / count * i), (250 / count * i) + 120);
//        nodeView.backgroundColor = [UIColor colorWithWhite:(CGFloat)i/(CGFloat)count alpha:1.0];
        nodeView.delegate = self;
        [self.view addSubview:nodeView];
        [self.nodeViews addObject:nodeView];
    }
    
    [self addConnectionViewFromLeadingNodeView:self.nodeViews[0] toTrailingNodeView:self.nodeViews[2]];
    [self addConnectionViewFromLeadingNodeView:self.nodeViews[1] toTrailingNodeView:self.nodeViews[2]];
    
    [self addConnectionViewFromLeadingNodeView:self.nodeViews[2] toTrailingNodeView:self.nodeViews[3]];
    
    [self addConnectionViewFromLeadingNodeView:self.nodeViews[3] toTrailingNodeView:self.nodeViews[4]];
    [self addConnectionViewFromLeadingNodeView:self.nodeViews[3] toTrailingNodeView:self.nodeViews[5]];

    //[self addConnectionViewFromLeadingNodeView:self.nodeViews[1] toTrailingNodeView:self.nodeViews[2]];
}

- (void)addConnectionViewFromLeadingNodeView:(NodeView *)leadingNodeView toTrailingNodeView:(NodeView *)trailingNodeView {
    ConnectionView *connectionView = [[ConnectionView alloc] initWithLeadingView:leadingNodeView
                                                                    trailingView:trailingNodeView];
    connectionView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
    connectionView.spacer = Spacer * 3;
    [self.view addSubview:connectionView];
    [self.connectionViews addObject:connectionView];
}

#pragma mark - DraggableViewDelegate

- (void)draggableViewTapped:(DraggableView *)draggableView {
    [self.view addSubview:draggableView]; // Put at top of stack
    
    for (NSUInteger i = 0; i < self.connectionViews.count; i++) {
        ConnectionView *connectionView = self.connectionViews[i];
        connectionView.lineType = (ConnectionViewLineType)((connectionView.lineType + 1) % 4);
    }
}

- (void)draggableViewPickedUp:(DraggableView *)draggableView {
    [self.view addSubview:draggableView]; // Put at top of stack
}

- (void)draggableView:(DraggableView *)draggableView movedToPosition:(CGPoint)position {
    // no-op
}

- (void)draggableViewDropped:(DraggableView *)draggableView {
    // no-op
}

@end
