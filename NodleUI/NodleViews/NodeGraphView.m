#import "NodeGraphView.h"
#import "NodeView.h"
#import "ConnectionLineView.h"

static const CGFloat connectionSnapDistance = 30;

@interface DraggningConnectionModel : NSObject
@property (nonatomic, strong) NodeConnectionView *nodeConnectionView;
@property (nonatomic, strong) ConnectionLineView *connectionLineView;
@property (nonatomic, strong) UIView *handleView;
- (instancetype)initWithNodeConnectionView:(NodeConnectionView *)nodeConnectionView
                        connectionLineView:(ConnectionLineView *)connectionLineView
                                handleView:(UIView *)handleView;
@end
@implementation DraggningConnectionModel
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

@interface NodeGraphView () <DraggableViewDelegate, NodeConnectionViewDelegate>

@property (nonatomic, strong) NSMapTable<id<Node>, NodeView *> *nodesMap;
@property (nonatomic, strong) NSMutableArray<ConnectionLineView *> *connectionLineViews;
@property (nonatomic, strong) NSMapTable<NodeConnectionView *, DraggningConnectionModel *> *draggingConnections;

@end

@implementation NodeGraphView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNodes:(NSArray<id<Node>> *)nodes {
    self = [self initWithFrame:CGRectMake(0, 0, 320, 320)];
    if (self) {
        
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];

    self.nodesMap = [NSMapTable strongToStrongObjectsMapTable];
    self.connectionLineViews = [NSMutableArray array];
    self.draggingConnections = [NSMapTable weakToStrongObjectsMapTable];
}

#pragma mark - Actions

- (void)addNode:(id<Node>)node {
    // Insert node in map
    NodeView *nodeView = [[NodeView alloc] initWithNode:node];
    nodeView.delegate = self;
    [self.nodesMap setObject:nodeView forKey:node];
    
    // Add NodeView to graph.
    [self addSubview:nodeView];
    [self refreshAllConnections];
}

- (void)refreshAllConnections {
    // Remove all connections
    [self removeAllConnectionViews];
    
    // Recreate connections
    for (NodeView *nodeView in [[self.nodesMap objectEnumerator] allObjects]) {
        [self refreshConnectionsForNodeView:nodeView];
    }
}

- (void)refreshConnectionsForNodeView:(NodeView *)nodeView {
    for (NodeOutput *output in nodeView.node.outputs) {
        for (NodeInput *input in [output.connections allObjects]) {
            // Connect views
            UIView *fromView = [nodeView outputViewForNodeOutput:output];
            UIView *toView = [[self.nodesMap objectForKey:input.node] inputViewForNodeInput:input];
            [self createConnectionLineViewFromLeadingView:fromView toTrailingView:toView];
        }
    }
}

- (void)removeAllConnectionViews {
    // TODO - Implement!
}

- (nullable ConnectionLineView *)createConnectionLineViewFromLeadingView:(nullable UIView *)leadingView
                                                          toTrailingView:(nullable UIView *)trailingView {
    if (!leadingView || !trailingView) {
        return nil;
    }
    ConnectionLineView *connectionLineView = \
    [[ConnectionLineView alloc] initWithLeadingView:leadingView trailingView:trailingView];
    connectionLineView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.2];
    [self addSubview:connectionLineView];
    [self.connectionLineViews addObject:connectionLineView];
    return connectionLineView;
}

#pragma mark - Setters & Getters

- (void)setNodes:(NSArray<id<Node>> *)nodes {
    // Remove all current connection views
    [self removeAllConnectionViews];
    
    // for each node add to set
    for (id<Node> node in nodes) {
        [self addNode:node];
    }
    
    // Add connection views
    [self refreshAllConnections];
}

- (NSArray<id<Node>> *)nodes {
    return [[self.nodesMap keyEnumerator] allObjects];
}

#pragma mark - NodeConnectionViewDelegate

- (void)nodeConnectionViewTapped:(NodeConnectionView *)nodeConnectionView {
    // no-op
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStartPanAtOffset:(CGPoint)offset {
    CGPoint point = [nodeConnectionView.gestureView convertPoint:CGPointZero toView:self];
    
    // Create handle view
    UIView *handleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    handleView.backgroundColor = UIColor.blueColor;
    handleView.center = offset;
    [self addSubview:handleView];
    
    // Create connection line view
    ConnectionLineView *connectionLineView = \
    [self createConnectionLineViewFromLeadingView:nodeConnectionView.gestureView toTrailingView:handleView];
    
    // Store pair
    DraggningConnectionModel *draggningConnection = \
    [[DraggningConnectionModel alloc] initWithNodeConnectionView:nodeConnectionView
                                              connectionLineView:connectionLineView
                                                      handleView:handleView];
    
    [self.draggingConnections setObject:draggningConnection forKey:nodeConnectionView];
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didPanToOffset:(CGPoint)offset withTranslation:(CGPoint)translation {
    CGPoint point = [nodeConnectionView.gestureView convertPoint:offset toView:self];
    // Move handle view
    DraggningConnectionModel *draggingConnection = [self.draggingConnections objectForKey:nodeConnectionView];
    draggingConnection.handleView.center = offset;
    // If close to node view, snap to closest compatible connection view
}

- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStopPanAtOffset:(CGPoint)offset withTranslation:(CGPoint)translation {
    
    BOOL isOutput = [nodeConnectionView isKindOfClass:[NodeOutputView class]];
    DraggningConnectionModel *draggingConnection = [self.draggingConnections objectForKey:nodeConnectionView];

    NodeConnectionView *closestConnectionView = [self connectionViewCompatibleWithConnectionView:nodeConnectionView closestToPosition:offset maxDistance:connectionSnapDistance];
    if (closestConnectionView) {
        [self createConnectionLineViewFromLeadingView:nodeConnectionView.gestureView toTrailingView:closestConnectionView.gestureView];
    }
    
    // Remove connection line view (connectionLineViews && draggingConnections)
    [self.connectionLineViews removeObject:draggingConnection.connectionLineView];
    [draggingConnection.connectionLineView removeFromSuperview];
    [draggingConnection.handleView removeFromSuperview];
    [self.draggingConnections removeObjectForKey:nodeConnectionView];
}

#pragma mark - DraggableViewDelegate

- (void)draggableViewTapped:(DraggableView *)draggableView {
    [self addSubview:draggableView]; // Put at top of stack
    
    for (NSUInteger i = 0; i < self.connectionLineViews.count; i++) {
        ConnectionLineView *connectionView = self.connectionLineViews[i];
        connectionView.lineType = (ConnectionViewLineType)((connectionView.lineType + 1) % 4);
    }
}

- (void)draggableViewPickedUp:(DraggableView *)draggableView {
    [self addSubview:draggableView]; // Put at top of stack
}

- (void)draggableView:(DraggableView *)draggableView movedToPosition:(CGPoint)position {
    // no-op
}

- (void)draggableViewDropped:(DraggableView *)draggableView {
    // no-op
}

#pragma mark - Helpers

- (NodeConnectionView *)connectionViewCompatibleWithConnectionView:(NodeConnectionView *)fromConnectionView
                                                 closestToPosition:(CGPoint)position
                                                       maxDistance:(CGFloat)maxDistance {
    NSArray<NodeView *> *nodeViews = [[self.nodesMap objectEnumerator] allObjects];
    BOOL isOutput = [fromConnectionView isKindOfClass:[NodeOutputView class]];
    
    CGFloat closestConnectionDistance = MAXFLOAT;
    NodeConnectionView *closestConnectionView = nil;
    
    for (NodeView *nodeView in nodeViews) {
        if ([nodeView.inputViews containsObject:fromConnectionView] || [nodeView.outputViews containsObject:fromConnectionView]) {
            continue;
        }
        NSArray<NodeConnectionView *> *connectionViews = isOutput ? nodeView.inputViews : nodeView.outputViews;
        for (NodeConnectionView *connectionView in connectionViews) {
            CGPoint connectionViewPosition = \
            [connectionView convertPoint:connectionView.gestureView.center toView:self];
            CGPoint distanceToConnectionView = CGPointMake(connectionViewPosition.x - position.x, connectionViewPosition.y - position.y);
            CGFloat distance = sqrt(pow(fabs(distanceToConnectionView.x), 2) + pow(fabs(distanceToConnectionView.y), 2));
            
            if (distance <= closestConnectionDistance && distance <= maxDistance) {
                closestConnectionDistance = distance;
                closestConnectionView = connectionView;
            }
        }
    }
    return closestConnectionView;
}

@end
