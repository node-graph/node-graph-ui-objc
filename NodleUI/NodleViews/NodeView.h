#import "DraggableView.h"
#import <nodle/nodle.h>

NS_ASSUME_NONNULL_BEGIN

static const CGFloat Spacer = 8.0;

@interface NodeView : DraggableView

@property (nonatomic, strong, readonly) id<Node> node;

- (instancetype)initWithNode:(id<Node>)node;

@end

NS_ASSUME_NONNULL_END
