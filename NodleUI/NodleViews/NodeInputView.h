#import <UIKit/UIKit.h>
#import <nodle/NodeInput.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeInputView : UIView

@property (nonatomic, strong, readonly) NodeInput *nodeInput;

- (instancetype)initWithNodeInput:(NodeInput *)nodeInput NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
