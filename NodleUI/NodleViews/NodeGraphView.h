#import <UIKit/UIKit.h>
#import <nodle/nodle.h>

NS_ASSUME_NONNULL_BEGIN

@interface NodeGraphView : UIView

@property (nonatomic, strong) NSArray<id<Node>> *nodes;

- (instancetype)initWithNodes:(NSArray<id<Node>> *)nodes;

- (void)addNode:(id<Node>)node;

@end

NS_ASSUME_NONNULL_END
