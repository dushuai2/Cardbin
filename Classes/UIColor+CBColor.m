//
//  UIColor+CBColor.m
//  CardBin
//
//  Created by 赵勇 on 1/3/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import "UIColor+CBColor.h"
#import <UIColor-Hex/UIColor+Hex.h>

@implementation UIColor(CBColor)
/*
+ (UIColor *)themeColor {
#if ASIA
	return [UIColor colorWithHex:0x1FD951];
#elif AMERICA
	return [UIColor colorWithHex:0xD91F66];
#elif EUROPE
	return [UIColor colorWithHex:0x1F93D9];
#elif AFRICA
    return [UIColor colorWithHex:0x333333];
#elif SOUTHAMERICA
    return [UIColor colorWithHex:0x666666];
#else
	return [UIColor colorWithHex:0xD91F66];
#endif
}*/

+ (UIColor *)themeColor {
    return [UIColor colorWithHex:0x666666];
}

+ (UIColor *)backgroundColor {
  return [UIColor colorWithHex:0xf1f2f3];
}

@end
