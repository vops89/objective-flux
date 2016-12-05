#import <Foundation/Foundation.h>
#import "Action.h"

typedef NSString DispatchToken;

@protocol DispatcherListener <NSObject>

@required
- (void)onDispatch:(Action *)action;

@end

@interface Dispatcher : NSObject

- (DispatchToken *)registerListener:(id<DispatcherListener>)listener;
- (void)unregisterListener:(DispatchToken *)dispatchToken;

- (void)waitFor:(NSArray<NSString *> *)dispatchTokens;
- (void)dispatch:(Action *)action;

- (BOOL)isDispatching;

@end
