//
//  CBLaunchViewController.m
//  CardBin
//
//  Created by 赵勇 on 25/12/2016.
//  Copyright © 2016 CB. All rights reserved.
//

#import "CBLaunchViewController.h"
#import <Masonry/Masonry.h>
#import <UIColor-Hex/UIColor+Hex.h>
#import "CBBmob.h"

@interface CBLaunchViewController ()

@end

@implementation CBLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:0xf1f2f3];
    [CBBmob setUp:^(BOOL success) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    /*
    
#if ASIA
	self.view.backgroundColor = [UIColor colorWithHex:0x26D640];
#elif AMERICA
	self.view.backgroundColor = [UIColor colorWithHex:0xD91F66];
#elif EUROPE
	self.view.backgroundColor = [UIColor colorWithHex:0x1F93D9];
#elif AFRICA
    self.view.backgroundColor = [UIColor colorWithHex:0x333333];
#elif SOUTHAMERICA
    self.view.backgroundColor = [UIColor colorWithHex:0x666666];
#else
	self.view.backgroundColor = [UIColor colorWithHex:0x26D640];
#endif

	UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bin"]];
	[self.view addSubview:logo];
	[logo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.bottom.equalTo(self.view);
		make.width.equalTo(self.view).multipliedBy(0.6);
		make.height.equalTo(logo.mas_width).multipliedBy(0.8412);
	}];
	
	[CBBmob setUp:^(BOOL success) {
		[self.view removeFromSuperview];
		[self removeFromParentViewController];
	}];
*/
}

@end
