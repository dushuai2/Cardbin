//
//  CBQuery.h
//  CardBin
//
//  Created by 赵勇 on 1/3/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBBank;

@interface CBQuery : NSObject

+ (CBBank *)queryBIN:(NSString *)BIN;

@end
