#import "NodeConnectionView.h"
#import <nodle/NodeInput.h>

NS_ASSUME_NONNULL_BEGIN

@class NodeInputView;

@interface NodeInputView : NodeConnectionView

@property (nonatomic, strong, readonly) NodeInput *nodeInput;

- (instancetype)initWithNodeInput:(NodeInput *)nodeInput NS_DESIGNATED_INITIALIZER;

#pragma mark - Unavailable Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
