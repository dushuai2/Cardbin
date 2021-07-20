//
//  RNInternal.h
//  PendoSDK
//
//  Created by Michael Rozenblat on 28/03/2020.
//  Copyright © 2020 Pendo.io. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const PNDRequiresJSHierarchyScan;

@interface RNInternal : NSObject
@property (nonatomic) BOOL jsListenerReady;
@property (nonatomic) id uiManager;

+ (instancetype)sharedInstance;


/// This method creates a separate queue for pendo execution
- (dispatch_queue_t)reactPendoQueue;

/*!
 *  This method should be call on each new screen/viewController appearance
 * @param screenName of the viewController title
 * @param rootTags  tags of the main screens JS
 * @param clickableNodes  all the clickable elements that were discovered in the JS
 * @param info any additional data
 */
- (void)screenChanged:(NSString *)screenName rootTags:(NSArray *)rootTags nodes:(NSArray *)clickableNodes info:(NSDictionary *)info;

- (instancetype _Nonnull)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (instancetype _Nonnull)new __attribute__((unavailable("new not available, call sharedInstance instead")));
- (instancetype _Nonnull)copy __attribute__((unavailable("copy not available, call sharedInstance instead")));
@end

NS_ASSUME_NONNULL_END
