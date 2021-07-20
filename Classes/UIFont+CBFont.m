//
//  UIFont+CBFont.m
//  CardBin
//
//  Created by 赵勇 on 1/3/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import "UIFont+CBFont.h"

@implementation UIFont(CBFont)

+ (UIFont *)defaultFont {
  return [UIFont fontWithName:@"STHeitiTC-Light" size:20.f];
}

+ (UIFont *)largeFont {
  return [UIFont fontWithName:@"STHeitiTC-Light" size:50.f];
}

+ (UIFont *)smallFont {
  return [UIFont fontWithName:@"STHeitiTC-Light" size:15.f];
}

@end
