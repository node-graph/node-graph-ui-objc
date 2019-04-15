#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DraggableView;

@protocol DraggableViewDelegate <NSObject>
@required

- (void)draggableViewTapped:(DraggableView *)draggableView;
- (void)draggableViewPickedUp:(DraggableView *)draggableView;
- (void)draggableViewDropped:(DraggableView *)draggableView;
- (void)draggableView:(DraggableView *)draggableView movedToPosition:(CGPoint)position;

@end

@interface DraggableView : UIView

@property (nonatomic, assign) id<DraggableViewDelegate> delegate;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign, readonly, getter=isPickedUp) BOOL pickedUp;

@end

NS_ASSUME_NONNULL_END
