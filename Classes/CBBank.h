//
//  CBBank.h
//  CardBin
//
//  Created by 赵勇 on 1/3/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CBBank : MTLModel

@property (nonatomic, copy, readonly) NSString *cardNumber;
@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *cardType;
@property (nonatomic, copy, readonly) NSString *country;
@property (nonatomic, copy, readonly) NSString *bankPhone;

@end
