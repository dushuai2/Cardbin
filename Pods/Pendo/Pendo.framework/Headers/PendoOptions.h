
#import <Foundation/Foundation.h>

@interface PendoOptions : NSObject <NSCopying>

/** @brief react plugin number that is used by hosting app. */
@property (nonatomic) NSUInteger reactPlugin;

/** @brief disable analytics collection. */
@property (nonatomic) BOOL disableAnalytics;

/** @brief internal configuration. */
@property (nonatomic, nullable) NSMutableDictionary *configs;

/** @brief environment type. */
@property (nonatomic, nullable) NSString *environmentName;

- (instancetype _Nonnull)init NS_DESIGNATED_INITIALIZER;

@end

