//
//  PendoManager.h
//  Pendo
//

#import <Foundation/Foundation.h>

@class PendoInitParams;
@class PendoOptions;

NS_ASSUME_NONNULL_BEGIN

/**
 *  The SDK will post the following notifications on initialization.
 *  The notifications are posted to the main thread
 *
 *  This notification is sent out after the SDK has successfully initialized
 */
extern NSString *const kPNDDidSuccessfullyInitializeSDKNotification;

/**
 *  This notification is sent out when an error occurs during initialization of the SDK
 */
extern NSString *const kPNDErrorInitializeSDKNotification;

/**
 *  PendoManager. Handles initialization of the Pendo Mobile SDK.
 */
@interface PendoManager : NSObject

/**
 * The app key used when initializing the SDK.
 */
@property (nonatomic, readonly, nonnull) NSString *appKey;

/**
 *  Provide a visitor id to the Pendo Mobile SDK.
 */
@property (nonatomic, strong, readonly, nullable) NSString *visitorId;

/**
 *  Provide an account id to the Pendo Mobile SDK.
 */
@property (nonatomic, strong, nullable) NSString *accountId;

#pragma mark - Initializer

/**
 *  Use [PendoManager sharedManager] instead
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 *  The shared instance of the PendoManager
 */
+ (instancetype)sharedManager;

/**
 *  Call this method on the sharedManger with your application key.
 *  Use this API in case the account and visitor data are not yet known, and they will be known at a later point of the app's lifecycle. In order to update the account and visitor data, call the API: [PendoManager switchVisitor:accountId:visitorData:accountData];
 *
 *  @warning This API is NOT an anonymous API. this should only be used if visitor data will be known at a later point.
 *  @param appKey The app key for your account
 */
- (void)initSDKWithoutVisitor:(NSString *_Nonnull)appKey;

/**
 *  Call this method on the sharedManger with your application key.
 *  Use this API in case the account and visitor data are not yet known, and they will be known at a later point of the app's lifecycle. In order to update the account and visitor data, call the API: [PendoManager switchVisitor:accountId:visitorData:accountData];
 *
 *  @warning This API is NOT an anonymous API. this should only be used if visitor data will be known at a later point.
 *  @param appKey The app key for your account
 *  @param options additional options for internal use only, default nil
 */
- (void)initSDKWithoutVisitor:(NSString *)appKey withOptions:(PendoOptions *_Nullable)options;

/**
 *  Call this method on the sharedManger with your application key.
 *
 *  @param appKey The app key for your account
 *  @param initParams (nullable) Extra initialize parameters (e.g. account id, visitor id...).
 */
- (void)initSDK:(NSString *_Nonnull)appKey initParams:(PendoInitParams *_Nullable)initParams;

/**
 *  Called from your app delegate when launched from a deep link containing an Pendo Mobile pairing URL
 *  @warning This method should always be called after initSDK: with your application key
 *  @param url The pairing URL
 */
- (void)initWithUrl:(NSURL *_Nonnull)url;

/**
 *  Call this method on the sharedManger to end current session and stop gathering analytics.
 *  @warning Must be called <b>after</b> the SDK was initialized.
 */
- (void)endSession;

#pragma mark - Visitor

/**
 * Must be called <b>after</b> the SDK was initialized.
 * @brief Clears the current visitor.
 */
- (void)clearVisitor;

/**
 * Must be called <b>after</b> the SDK was initialized.
 *
 * @brief Switch to a new visitor and restart the session.
 *
 * @param visitorId The visitor's ID.
 * @param accountId The account's ID.
 * @param visitorData The visitor's data.
 * @param accountData The account's data.
 */
- (void)switchVisitor:(NSString *_Nullable)visitorId
            accountId:(NSString *_Nullable)accountId
          visitorData:(NSDictionary *_Nullable)visitorData
          accountData:(NSDictionary *_Nullable)accountData;

/**
 * Set a visitor data value.
 * This data is used by Pendo Mobile for creating audiences or reporting analytics.
 * For instance you might want to provide data on the visitor's age or if the visitor is logged into a service.
 *
 *  @param visitorData additional visitor data.
 */
- (void)setVisitorData:(NSDictionary *_Nonnull)visitorData;

/**
 * Set account data value for a given data name.
 * This data is used by Pendo Mobile for creating audiences or reporting analytics.
 * For instance you might want to provide data on the account's subscription or if the account is active or not.
 *
 * @param accountData the account data.
*/
- (void)setAccountData:(NSDictionary *_Nonnull)accountData;

#pragma mark - Track

/**
 * When your application needs to send additional events about actions your users perform.
 *
 * @param event The event name describing the user’s action.
 * @param properties dictionary event properties (optional).
 * @brief Queue of track events for transmission, optionally including properties as the payload of the event.
 */
- (void)track:(NSString *_Nonnull)event properties:(NSDictionary *_Nullable)properties;

#pragma mark - Guides

/**
 * Call in order to stop showing guides.
 */
- (void)pauseGuides DEPRECATED_MSG_ATTRIBUTE("use pauseGuides:(BOOL)dismissGuides");

/**
 * Call in order to stop showing guides.
 */
- (void)pauseGuides:(BOOL)dismissGuides;

/**
 * Call in order to resume showing guides.
 */
- (void)resumeGuides;

/**
 * Get Pendo SDK unique device id. Used for anonymous visitor id.
 * This id is unique per application. 
 */
- (NSString *)getDeviceId;

/**
 * Dismiss any visible guides
 */
- (void)dismissVisibleGuides;

/**
 * This property is used for debug purposes only to monitor all the Initialization
 * processes of the SDK, (The hosting app should enable severity log in the Info.plist).
 * The method should be executed few later after SDK initialization
*/
- (void)confirmInitialization;

#pragma mark - Debug

/**
 * @param isDebugEnabled - if true will enables debug logs, if false will disable debug logs
 */
- (void)setDebugMode:(BOOL)isDebugEnabled;

@end

NS_ASSUME_NONNULL_END


