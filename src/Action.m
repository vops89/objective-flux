#import "Action.h"

@implementation Action

+ (instancetype)actionWithType:(NSInteger)type
{
    return [[self alloc] initWithType:type];
}
+ (instancetype)actionWithType:(NSInteger)type payload:(NSDictionary *)payload
{
    return [[self alloc] initWithType:type payload:payload];
}

- (instancetype)initWithType:(NSInteger)type
{
    return [self initWithType:type payload:nil];
}
- (instancetype)initWithType:(NSInteger)type payload:(NSDictionary *)payload
{
    self = [super init];
    if (self) {
        _type = type;
        _payload = payload;
    }
    return self;
}

@end
