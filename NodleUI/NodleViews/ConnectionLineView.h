#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ConnectionViewLineType) {
    ConnectionViewLineTypeSquareRounded,
    ConnectionViewLineTypeSquare,
    ConnectionViewLineTypeCurvy,
    ConnectionViewLineTypeStraightLine
};

@interface ConnectionLineView : UIView

@property (nonatomic, weak, readonly) UIView *leadingView;
@property (nonatomic, weak, readonly) UIView *trailingView;
@property (nonatomic, assign) CGFloat spacer;
@property (nonatomic, assign) ConnectionViewLineType lineType;

- (instancetype)initWithLeadingView:(UIView *)leadingView trailingView:(UIView *)trailingView;

@end

NS_ASSUME_NONNULL_END
