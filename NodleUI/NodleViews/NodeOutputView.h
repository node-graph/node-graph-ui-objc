#import <UIKit/UIKit.h>
#import <nodle/NodeOutput.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeOutputView : UIView

@property (nonatomic, strong, readonly) NodeOutput *nodeOutput;

- (instancetype)initWithNodeOutput:(NodeOutput *)nodeOutput NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
