//
//  CBBmob.h
//  CardBin
//
//  Created by 赵勇 on 12/11/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBBmob : NSObject

+ (void)setUp:(void(^)(BOOL success))completion;

+ (int)restNumebr;

+ (void)addQueryNumber:(int)number completion:(void(^)(BOOL isSuccessful, NSError *error))completion;

+ (void)use:(int)number completion:(void(^)(BOOL isSuccessful, NSError *error))completion;

@end
