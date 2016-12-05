#import "Store.h"

@implementation StoreWeakListener

- (instancetype)initWithListener:(id<StoreListener>)listener
{
    self = [super init];
    if (self) {
        _listener = listener;
    }
    return self;
}

@end

@interface Store () <DispatcherListener>

@property (nonatomic, strong) NSMutableDictionary *listeners;
@property (nonatomic, assign) BOOL changed;

@property (nonatomic, weak) Dispatcher *dispatcher;
@property (nonatomic, strong) DispatchToken *dispatchToken;

@end

@implementation Store

- (instancetype)initWithDispatcher:(Dispatcher *)dispatcher
{
    self = [super init];
    if (self) {
        _listeners = [NSMutableDictionary new];
        _changed = NO;
        _dispatcher = dispatcher;
        _dispatchToken = [_dispatcher registerListener:self];
    }
    return self;
}

- (StoreToken *)addListener:(id<StoreListener>)listener
{
    StoreWeakListener *weakListener = [[StoreWeakListener alloc] initWithListener:listener];
    StoreToken *token = [NSString stringWithFormat:@"%ld", (unsigned long)[listener hash]];
    [self.listeners setObject:weakListener forKey:token];
    return token;
}
- (void)removeListener:(StoreToken *)token
{
    [self.listeners removeObjectForKey:token];
}

- (Dispatcher *)getDispatcher
{
    return _dispatcher;
}
- (DispatchToken *)getDispatchToken
{
    return _dispatchToken;
}

- (void)dispatch:(Action *)action
{
    NSLog(@"dispatch method is not overrided in %@", NSStringFromClass([self class]));
}

- (void)emitChange
{
    _changed = YES;
}
- (BOOL)hasChanged
{
    return _changed;
}

- (void)onDispatch:(Action *)action
{
    _changed = NO;
    [self dispatch:action];
    if (_changed) {
        for (StoreToken *token in self.listeners) {
            StoreWeakListener *weakListener = [self.listeners objectForKey:token];
            if ([weakListener.listener respondsToSelector:@selector(onChange)]) {
                [weakListener.listener onChange];
            }
        }
    }
}

@end
