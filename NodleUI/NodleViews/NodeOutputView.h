#import "NodeConnectionView.h"
#import <nodle/NodeOutput.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeOutputView : NodeConnectionView

@property (nonatomic, strong, readonly) NodeOutput *nodeOutput;

- (instancetype)initWithNodeOutput:(NodeOutput *)nodeOutput NS_DESIGNATED_INITIALIZER;

#pragma mark - Unavailable Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
