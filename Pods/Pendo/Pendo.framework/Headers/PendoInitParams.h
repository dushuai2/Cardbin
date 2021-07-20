
#import <Foundation/Foundation.h>
#import "PendoOptions.h"

@interface PendoInitParams : NSObject

/** @brief The visitor's id */
@property (nonatomic, copy, nullable) NSString *visitorId;

/** @brief The account's id */
@property (nonatomic, copy, nullable) NSString *accountId;

/** @brief The data that are used by Pendo Mobile visitor level data. */
@property (nonatomic, copy, nullable) NSDictionary *visitorData;

/** @brief the data that are used by Pendo Mobile for account level data. */
@property (nonatomic, copy, nullable) NSDictionary *accountData;

/** @brief additional options for pendo initialization. */
@property (nonatomic, copy, nullable) NSDictionary *pendoOptions DEPRECATED_MSG_ATTRIBUTE("use options instead");

/** @brief additional options for pendo initialization. */
@property (nonatomic, copy, nullable) PendoOptions *options;

/** @brief environment type. */
@property (nonatomic, nullable) NSString *environmentName  DEPRECATED_MSG_ATTRIBUTE("use environmentName in the PendoOptions instead");

- (instancetype _Nonnull)init NS_DESIGNATED_INITIALIZER;

@end
