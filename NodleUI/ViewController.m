#import "ViewController.h"
#import "NodeView.h"
#import "ConnectionLineView.h"

static const CGFloat connectionSnapDistance = 30;

@interface DraggningConnection : NSObject
@property (nonatomic, strong) NodeConnectionView *nodeConnectionView;
@property (nonatomic, strong) ConnectionLineView *connectionLineView;
@property (nonatomic, strong) UIView *handleView;
- (instancetype)initWithNodeConnectionView:(NodeConnectionView *)nodeConnectionView
                        connectionLineView:(ConnectionLineView *)connectionLineView
                                handleView:(UIView *)handleView;
@end
@implementation DraggningConnection
- (instancetype)initWithNodeConnectionView:(NodeConnectionView *)nodeConnectionView
                        connectionLineView:(ConnectionLineView *)connectionLineView
                                handleView:(UIView *)handleView {
    self = [super init];
    if (self) {
        _nodeConnectionView = nodeConnectionView;
        _connectionLineView = connectionLineView;
        _handleView = handleView;
    }
    return self;
}
@end

@interface ViewController () <DraggableViewDelegate, NodeConnectionViewDelegate>

@property (nonatomic, strong) NSMutableArray<NodeView *> *nodeViews;
@property (nonatomic, strong) NSMutableArray<ConnectionLineView *> *connectionLineViews;
@property (nonatomic, strong) NSMapTable<NodeConnectionView *, DraggningConnection *> *draggingConnections;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    
    self.nodeViews = [NSMutableArray array];
    self.connectionLineViews = [NSMutableArray array];
    self.draggingConnections = [NSMapTable weakToStrongObjectsMapTable];

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
    
//    [self createConnectionLineViewFromLeadingView:self.nodeViews[0] toTrailingView:self.nodeViews[2]];
//    [self createConnectionLineViewFromLeadingView:self.nodeViews[1] toTrailingView:self.nodeViews[2]];
//
//    [self createConnectionLineViewFromLeadingView:self.nodeViews[2] toTrailingView:self.nodeViews[3]];
//
//    [self createConnectionLineViewFromLeadingView:self.nodeViews[3] toTrailingView:self.nodeViews[4]];
//    [self createConnectionLineViewFromLeadingView:self.nodeViews[3] toTrailingView:self.nodeViews[5]];

    //[self addConnectionViewFromLeadingNodeView:self.nodeViews[1] toTrailingNodeView:self.nodeViews[2]];
}

- (ConnectionLineView *)createConnectionLineViewFromLeadingView:(UIView *)leadingView toTrailingView:(UIView *)trailingView {
    ConnectionLineView *connectionLineView = \
    [[ConnectionLineView alloc] initWithLeadingView:leadingView trailingView:trailingView];
    connectionLineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
    connectionLineView.spacer = Spacer * 3;
    [self.view addSubview:connectionLineView];
    [self.connectionLineViews addObject:connectionLineView];
    return connectionLineView;
}

#pragma mark - NodeConnectionViewDelegate

- (void)nodeConnectionViewTapped:(NodeConnectionView *)nodeConnectionView {
    // no-op
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStartPanAtOffset:(CGPoint)offset {
    CGPoint point = [nodeConnectionView.gestureView convertPoint:CGPointZero toView:self.view];

    // Create handle view
    UIView *handleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    handleView.backgroundColor = UIColor.blueColor;
    handleView.center = offset;
    [self.view addSubview:handleView];
    
    // Create connection line view
//    ConnectionLineView *connectionLineView = \
//    [self createConnectionLineViewFromLeadingView:nodeConnectionView.gestureView toTrailingView:handleView];
    
    // Store pair
    DraggningConnection *draggningConnection = \
    [[DraggningConnection alloc] initWithNodeConnectionView:nodeConnectionView
                                         connectionLineView:nil //connectionLineView
                                                 handleView:handleView];
    
    [self.draggingConnections setObject:draggningConnection forKey:nodeConnectionView];
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didPanToOffset:(CGPoint)offset withTranslation:(CGPoint)translation {
    CGPoint point = [nodeConnectionView.gestureView convertPoint:offset toView:self.view];
    // Move handle view
    DraggningConnection *draggingConnection = [self.draggingConnections objectForKey:nodeConnectionView];
    draggingConnection.handleView.center = offset;
    // If close to node view, snap to closest compatible connection view
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStopPanAtOffset:(CGPoint)offset withTranslation:(CGPoint)translation {
    
    BOOL isOutput = [nodeConnectionView isKindOfClass:[NodeOutputView class]];
    
    // Remove connection line view (connectionLineViews && draggingConnections)
    DraggningConnection *draggingConnection = [self.draggingConnections objectForKey:nodeConnectionView];
    [self.connectionLineViews removeObject:draggingConnection.connectionLineView];
    [draggingConnection.connectionLineView removeFromSuperview];
    
    // Remove handle view
    [draggingConnection.handleView removeFromSuperview];
    
    [self.draggingConnections removeObjectForKey:nodeConnectionView];
    
    // If close enough to other connection, connect!
    NodeConnectionView *closestConnectionView = nil;
    CGFloat closestConnectionRoughDistance = MAXFLOAT;
    for (NodeView *nodeView in self.nodeViews) {
        NSArray<NodeConnectionView *> *connectionViews = isOutput ? nodeView.inputViews : nodeView.outputViews;
        for (NodeConnectionView *connectionView in connectionViews) {
            CGPoint convertedPosition = [connectionView convertPoint:connectionView.center toView:self.view];
            CGPoint connectionViewOffset = CGPointMake(convertedPosition.x - offset.x,
                                                       convertedPosition.y - offset.y);
            CGFloat roughDistance = (fabs(connectionViewOffset.x) +
                                     fabs(connectionViewOffset.y)) / 2;
            if (roughDistance < closestConnectionRoughDistance) {
                closestConnectionRoughDistance = roughDistance;
                closestConnectionView = connectionView;
            }
        }
    }
    if (closestConnectionRoughDistance <= connectionSnapDistance) {
        [self createConnectionLineViewFromLeadingView:nodeConnectionView toTrailingView:closestConnectionView];
    }
}

#pragma mark - DraggableViewDelegate

- (void)draggableViewTapped:(DraggableView *)draggableView {
    [self.view addSubview:draggableView]; // Put at top of stack
    
    for (NSUInteger i = 0; i < self.connectionLineViews.count; i++) {
        ConnectionLineView *connectionView = self.connectionLineViews[i];
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
