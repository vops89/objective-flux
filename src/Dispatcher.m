#import "Dispatcher.h"

@interface Dispatcher ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<DispatcherListener>> *listeners;
@property (nonatomic, assign) BOOL isDispatching;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *isHandled;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *isPending;
@property (nonatomic, assign) NSInteger lastID;
@property (nonatomic, strong) Action *pendingAction;

@end

@implementation Dispatcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        _listeners = [NSMutableDictionary new];
        _isDispatching = NO;
        _isHandled = [NSMutableDictionary new];
        _isPending = [NSMutableDictionary new];
        _lastID = 0;
        _pendingAction = nil;
    }
    return self;
}

- (DispatchToken *)registerListener:(id<DispatcherListener>)listener
{
    NSString *dispatchToken = [NSString stringWithFormat:@"ID_%ld", (long)self.lastID++];
    [self.listeners setObject:listener forKey:dispatchToken];
    return dispatchToken;
}
- (void)unregisterListener:(DispatchToken *)dispatchToken
{
    [self.listeners removeObjectForKey:dispatchToken];
}

- (void)waitFor:(nonnull NSArray<NSString *> *)dispatchTokens
{
    for (NSString *dispatchToken in dispatchTokens) {
        if ([[self.isPending objectForKey:dispatchToken] boolValue]) {
            if (![[self.isHandled objectForKey:dispatchToken] boolValue]) {
                NSLog(@"Circular dependency");
            }
            continue;
        }
        [self invokeListenerCallback:dispatchToken];
    }
}
- (void)dispatch:(Action *)action
{
    NSAssert(_isDispatching == NO, @"Dispatch in the middle of dispatch");
    [self startDispatching:action];
    for (NSString *dispatchToken in self.listeners) {
        if ([[self.isPending objectForKey:dispatchToken] boolValue]) {
            continue;
        }
        [self invokeListenerCallback:dispatchToken];
    }
    [self stopDispatching];
}

- (BOOL)isDispatching
{
    return _isDispatching;
}

#pragma mark - Private methods
- (void)invokeListenerCallback:(DispatchToken *)dispatchToken
{
    [self.isPending setObject:@(YES) forKey:dispatchToken];
    id<DispatcherListener> listener = [self.listeners objectForKey:dispatchToken];
    [listener onDispatch:self.pendingAction];
    [self.isHandled setObject:@(YES) forKey:dispatchToken];
}
- (void)startDispatching:(Action *)action
{
    for (NSString *dispatchToken in self.listeners) {
        [self.isPending setObject:@(NO) forKey:dispatchToken];
        [self.isHandled setObject:@(NO) forKey:dispatchToken];
    }
    self.pendingAction = action;
    _isDispatching = YES;
}
- (void)stopDispatching
{
    self.pendingAction = nil;
    _isDispatching = NO;
}

@end
