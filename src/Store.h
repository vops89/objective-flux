#import <Foundation/Foundation.h>
#import "Dispatcher.h"

typedef NSString StoreToken;

@protocol StoreListener <NSObject>

- (void)onChange;

@end

@interface StoreWeakListener : NSObject

@property (nonatomic, weak) id<StoreListener> listener;

- (instancetype)initWithListener:(id<StoreListener>)listener;

@end

@interface Store : NSObject

- (instancetype)initWithDispatcher:(Dispatcher *)dispatcher;

- (StoreToken *)addListener:(id<StoreListener>)listener;
- (void)removeListener:(StoreToken *)token;

- (Dispatcher *)getDispatcher;
- (DispatchToken *)getDispatchToken;
- (void)dispatch:(Action *)action;

- (void)emitChange;
- (BOOL)hasChanged;

@end
