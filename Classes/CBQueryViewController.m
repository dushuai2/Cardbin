//
//  CBQueryViewController.m
//  CardBin
//
//  Created by 赵勇 on 1/3/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import "CBQueryViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#import "CBQuery.h"
#import "CBBank.h"

#import "UIColor+CBColor.h"
#import "UIFont+CBFont.h"

#import "CBQueryResultView.h"
#import "CBPurchaseViewController.h"
#import "CBLaunchViewController.h"

#import "CBBmob.h"

@interface CBQueryViewController ()

@property (nonatomic, strong) CBQueryResultView *resultView;
@property (nonatomic, copy) NSString *record;

@end

@implementation CBQueryViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    NSString *defaultBIN = nil;
    NSString *sloganString = nil;
#if ASIA
    defaultBIN = @"Example:422244";
    sloganString = @"Query Asian BIN here.";
#elif AMERICA
    defaultBIN = @"Example:402598";
    sloganString = @"Query North American BIN here.";
#elif EUROPE
    defaultBIN = @"Example:410034";
    sloganString = @"Query European BIN here.";
#elif AFRICA
    defaultBIN = @"Example:417231";
    sloganString = @"Query African BIN here.";
#elif SOUTHAMERICA
    defaultBIN = @"Example:400615";
    sloganString = @"Query South American BIN here.";
#else
    defaultBIN = @"Example:402598";
    sloganString = @"Query North American BIN here.";
#endif
	
	UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleDefault;

  self.view.backgroundColor = UIColor.backgroundColor;
  
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.font = UIFont.largeFont;
  titleLabel.textColor = UIColor.themeColor;
  titleLabel.text = NSBundle.mainBundle.infoDictionary[@"CFBundleDisplayName"];
  [self.view addSubview:titleLabel];
	
	UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	buyButton.tintColor = UIColor.themeColor;
	[buyButton addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:buyButton];
  
  UILabel *slogan = [[UILabel alloc] init];
  slogan.font = UIFont.defaultFont;
  slogan.textColor = [UIColor.themeColor colorWithAlphaComponent:0.7f];
  slogan.text = NSLocalizedString(sloganString,);
  slogan.tag = 101;
  [self.view addSubview:slogan];
  
  UIView *container = [[UIView alloc] init];
  container.backgroundColor = UIColor.whiteColor;
  [self.view addSubview:container];

    UITextField *input = [[UITextField alloc] init];
	input.font = UIFont.defaultFont;
	input.placeholder = @"Input BIN here.";
	input.textColor = UIColor.themeColor;
	input.keyboardType = UIKeyboardTypeNumberPad;
  input.textAlignment = NSTextAlignmentCenter;
  input.tag = 100;
	[container addSubview:input];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
	[button setTitle:@"Query" forState:UIControlStateNormal];
	[button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
  button.titleLabel.font = UIFont.defaultFont;
	button.backgroundColor = UIColor.themeColor;
	button.layer.cornerRadius = 2.f;
  button.hidden = YES;
	[button addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchUpInside];
	[container addSubview:button];

  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(64.f);
    make.centerX.equalTo(self.view);
  }];
	[buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(titleLabel);
		make.right.equalTo(self.view).offset(-20);
	}];
  [slogan mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
  }];
	[container mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.view);
    make.height.equalTo(@72.f);
  }];
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(container);
    make.height.equalTo(@(UIFont.defaultFont.pointSize + 16));
    make.right.equalTo(container).offset(-10);
    make.width.equalTo(@72.f);
  }];
	[input mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.top.equalTo(container).offset(92.f);
		make.right.equalTo(container).offset(-92);
		make.top.bottom.equalTo(container);
	}];
  
  CGFloat h = (CGRectGetHeight(self.view.frame) - UIFont.defaultFont.pointSize) / 2 - 64.f - UIFont.largeFont.pointSize - 20.f;
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil] subscribeNext:^(NSNotification *x) {
    CGRect rect = [x.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [x.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat curve = [x.userInfo[UIKeyboardAnimationCurveUserInfoKey] doubleValue];
    if (rect.origin.y == CGRectGetMaxY(self.view.frame)) {
      button.hidden = YES;
      input.placeholder = @"Input BIN here.";
      input.text = nil;
      if (self.resultView) self.resultView.hidden = NO;
      [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        container.transform = CGAffineTransformIdentity;
        if (!self.resultView) {
          slogan.transform = CGAffineTransformIdentity;
        }
      } completion:nil];
    } else {
      button.hidden = NO;
      input.placeholder = defaultBIN;
      slogan.text = NSLocalizedString(sloganString,);
      self.resultView.hidden = YES;
      [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        container.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(rect));
        slogan.transform = CGAffineTransformMakeTranslation(0, -h);
      } completion:nil];
    }
  }];
	
	CBLaunchViewController *launch = [[CBLaunchViewController alloc] init];
	[self addChildViewController:launch];
	[self.view addSubview:launch.view];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)buy {
	int i = [CBBmob restNumebr];
	[self showAlert:[NSString stringWithFormat:@"Number of queries remaining %d times", i]];
}

- (void)query {
	int i = [CBBmob restNumebr];
	if (i == 0) {
		[self showAlert:@"Number of queries remaining 0 times"];
		return;
	}
  UITextField *input = (UITextField *)[self.view viewWithTag:100];
  if (input.text.length == 0) {
    [input resignFirstResponder];
    return;
  } else {
    _record = input.text;
		UILabel *slogan = (UILabel *)[self.view viewWithTag:101];
		slogan.text = nil;
    CBBank *bank = [CBQuery queryBIN:_record];
    if (bank.bankName.length == 0) {
      [_resultView removeFromSuperview];
      _resultView = nil;
      slogan.text = @"Bank Information not found.";
    } else {
			[CBBmob use:1 completion:^(BOOL isSuccessful, NSError *error) {
				if (error) {
					NSLog(@"使用次数记录失败");
					[self showInfo:@"Query failed!"];
				} else {
					NSLog(@"使用次数记录成功");
					[_resultView removeFromSuperview];
					_resultView = [[CBQueryResultView alloc] initWithModel:bank];
					[self.view addSubview:_resultView];
					[_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
						make.left.right.equalTo(self.view);
						make.centerY.equalTo(self.view).offset(40);
					}];
				}
			}];
    }
    [input resignFirstResponder];
  }
}

- (void)showAlert:(NSString *)message {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Information" message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *actionBuy = [UIAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		CBPurchaseViewController *purchase = [[CBPurchaseViewController alloc] init];
		[self.navigationController pushViewController:purchase animated:YES];
	}];
	UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:actionCancel];
	[alert addAction:actionBuy];
	[self presentViewController:alert animated:YES completion:nil];
}

- (void)showInfo:(NSString *)message {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error!" message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"I know." style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:actionCancel];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
