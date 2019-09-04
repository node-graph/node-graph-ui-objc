#import "ViewController.h"
#import "NodeGraphView.h"

@interface ViewController ()

@property (nonatomic, strong) NodeGraphView *nodeGraphView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nodeGraphView = [[NodeGraphView alloc] init];
    self.nodeGraphView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.nodeGraphView];
    [[self.nodeGraphView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
    [[self.nodeGraphView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
    [[self.nodeGraphView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.nodeGraphView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    
    NSUInteger count = 2;
    NSMutableArray<id<Node>> *nodes = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        RGBNode *rgbNode = [RGBNode new];
        [nodes addObject:rgbNode];
    }
    
    self.nodeGraphView.nodes = nodes;
}


@end
