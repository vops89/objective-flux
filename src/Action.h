#import <Foundation/Foundation.h>

@interface Action : NSObject

@property (nonatomic, assign, readonly) NSInteger type;
@property (nonatomic, strong, readonly) NSDictionary *payload;

+ (instancetype)actionWithType:(NSInteger)type;
+ (instancetype)actionWithType:(NSInteger)type payload:(NSDictionary *)payload;

- (instancetype)initWithType:(NSInteger)type;
- (instancetype)initWithType:(NSInteger)type payload:(NSDictionary *)payload;

@end
