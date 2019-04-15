#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class NodeConnectionView;

@protocol NodeConnectionViewDelegate <NSObject>

- (void)nodeConnectionViewTapped:(NodeConnectionView *)nodeConnectionView;
- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStartPanAtOffset:(CGPoint)offset;
- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didPanToOffset:(CGPoint)offset withTranslation:(CGPoint)translation;
- (void)nodeConnectionView:(NodeConnectionView *)nodeConnectionView didStopPanAtOffset:(CGPoint)offset withTranslation:(CGPoint)translation;

@end

@interface NodeConnectionView : UIView

@property (nonatomic, weak) id<NodeConnectionViewDelegate> delegate;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) UIView *gestureView;

@end

NS_ASSUME_NONNULL_END
