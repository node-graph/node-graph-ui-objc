#import <Foundation/Foundation.h>
#import <nodle/Node.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A collection of nodes combined with a key. A registry can have another instance of a
 registry as a fallback if no node was found in this registry.
 */
@interface NodeRegistry : NSObject

/**
 An optional fallback registry to look up nodes in.
 */
@property (nonatomic, strong, nullable) NodeRegistry *fallbackRegistry;

/**
 Register a node that later can be fetched by key and instantiated.
 @param node The node you want to register into the registry.
 @param key The key for the node, used when fetching the same node again.
 */
- (void)registerNode:(id<Node>)node forKey:(NSString *)key;

/**
 Get a node for a specified key from the registry or the fallback registry.
 @param key The key for the node you want to fetch.
 */
- (id<Node>)nodeForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
