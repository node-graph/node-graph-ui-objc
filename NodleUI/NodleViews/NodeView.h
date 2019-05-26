#import "DraggableView.h"
#import "NodeInputView.h"
#import "NodeOutputView.h"

#import <nodle/nodle.h>


NS_ASSUME_NONNULL_BEGIN

static const CGFloat Spacer = 8.0;

@interface NodeView : DraggableView

@property (nonatomic, strong, readonly) id<Node> node;
@property (nonatomic, weak) id<DraggableViewDelegate, NodeConnectionViewDelegate> delegate;
@property (nonatomic, readonly) NSArray<NodeInputView *> *inputViews;
@property (nonatomic, readonly) NSArray<NodeOutputView *> *outputViews;

- (instancetype)initWithNode:(id<Node>)node;
- (nullable NodeInputView *)inputViewForNodeInput:(NodeInput *)nodeInput;
- (nullable NodeOutputView *)outputViewForNodeOutput:(NodeOutput *)nodeOutput;

@end

NS_ASSUME_NONNULL_END
