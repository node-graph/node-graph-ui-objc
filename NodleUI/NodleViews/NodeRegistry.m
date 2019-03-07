#import "NodeRegistry.h"

@interface NodeRegistry ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<Node>> *nodes;

@end

@implementation NodeRegistry

- (instancetype)init {
    self = [super init];
    if (self) {
        _nodes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerNode:(id<Node>)node forKey:(NSString *)key {
    if (!node || !key) {
        return;
    }
    self.nodes[key] = node;
}

- (id<Node>)nodeForKey:(NSString *)key {
    id<Node> node = self.nodes[key];
    return node ?: [self.fallbackRegistry nodeForKey:key];
}

@end
