//
//  CBPurchaseViewController.m
//  CardBin
//
//  Created by 赵勇 on 25/12/2016.
//  Copyright © 2016 CB. All rights reserved.
//

#import "CBPurchaseViewController.h"
#import <Masonry/Masonry.h>
#import <StoreKit/StoreKit.h>
#import "CBBmob.h"

@interface CBPurchaseViewController ()
<UITableViewDelegate,
UITableViewDataSource,
SKProductsRequestDelegate,
SKPaymentTransactionObserver>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) NSInteger index;

@end

@implementation CBPurchaseViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = UIColor.whiteColor;
	self.navigationItem.title = @"Purchase";
	
    NSString *bundleId = NSBundle.mainBundle.bundleIdentifier;
    
	_dataArray = @[@[@"50 queries", @"$0.99"],
                   @[@"180 queries", @"$2.99"],
                   @[@"350 queries", @"$4.99"],
                    @[@"800 queries", @"$9.99"],
                    @[@"1800 queries", @"$19.99"],
                    @[@"5000 queries", @"$49.99"],
                    @[@"11000 queries", @"$99.99"]];
	_products = @[[bundleId stringByAppendingString:@".0"],
                  [bundleId stringByAppendingString:@".1"],
                  [bundleId stringByAppendingString:@".2"],
                  [bundleId stringByAppendingString:@".3"],
                  [bundleId stringByAppendingString:@".4"],
                  [bundleId stringByAppendingString:@".5"],
                  [bundleId stringByAppendingString:@".6"],];
    
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.scrollEnabled = NO;
	tableView.tableFooterView = UIView.new;
	[self.view addSubview:tableView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"PurchaseCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
		cell.textLabel.font = [UIFont systemFontOfSize:17.f];
		cell.textLabel.textColor = UIColor.blackColor;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:17.f];
		cell.detailTextLabel.textColor = UIColor.redColor;
	}
	cell.textLabel.text = self.dataArray[indexPath.row][0];
	cell.detailTextLabel.text = self.dataArray[indexPath.row][1];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.index = indexPath.row;
	[self purchase];
}

- (void)showInfo:(NSString *)title message:(NSString *)message {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"I know." style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:actionCancel];
	[self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Purchase

- (void)purchase {
  NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
  for (SKPaymentTransaction *transaction in transactions) {
    if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
      [self completeTransaction:transaction];
    }
  }
	if([SKPaymentQueue canMakePayments]){
		[self requestProductData:self.products[self.index]];
	}else{
		NSLog(@"不允许程序内付费");
		[self showInfo:@"Error!" message:@"Can not access to In App Purchase."];
	}
}

//请求商品
- (void)requestProductData:(NSString *)type {
	NSLog(@"-------------请求对应的产品信息----------------");
	NSSet *nsset = [NSSet setWithArray:@[type]];
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
	request.delegate = self;
	[request start];
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	NSLog(@"--------------收到产品反馈消息---------------------");
	NSArray *product = response.products;
	if([product count] == 0){
		NSLog(@"--------------没有商品------------------");
		[self showInfo:@"Error!" message:@"There is no commodity."];
		return;
	}
	NSLog(@"productID:%@", response.invalidProductIdentifiers);
	NSLog(@"产品付费数量:%ld", (long)[product count]);
	
	SKProduct *p = nil;
	for (SKProduct *pro in product) {
		NSLog(@"%@", [pro description]);
		NSLog(@"%@", [pro localizedTitle]);
		NSLog(@"%@", [pro localizedDescription]);
		NSLog(@"%@", [pro price]);
		NSLog(@"%@", [pro productIdentifier]);
		if([pro.productIdentifier isEqualToString:self.products[self.index]]){
			p = pro;
			break;
		}
	}
	SKPayment *payment = [SKPayment paymentWithProduct:p];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
	NSLog(@"------------------错误-----------------:%@", error);
	[self showInfo:@"Error!" message:@"Request failed."];
}

- (void)requestDidFinish:(SKRequest *)request{
	NSLog(@"------------反馈信息结束-----------------");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  NSLog(@" 监听购买结果 -----paymentQueue--------");
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchased: {
        NSLog(@"-----交易完成 --------");
        [self completeTransaction:transaction];
        int number = 0;
        switch (self.index) {
          case 0: number = 50; break;
          case 1: number = 200; break;
          case 2: number = 400; break;
          default: break;
        }
        if (number > 0) {
          [CBBmob addQueryNumber:number completion:^(BOOL isSuccessful, NSError *error) {
            NSLog(@"Bmob 购买成功");
          }];
        }
        break;
      }
      case SKPaymentTransactionStateFailed: {
        NSLog(@"-----交易失败 --------");
        [self completeTransaction:transaction];
        break;
      }
      case SKPaymentTransactionStateRestored: {
        NSLog(@"-----已经购买过该商品(重复支付) --------");
        [self completeTransaction:transaction];
        break;
      }
      case SKPaymentTransactionStatePurchasing:  {
        NSLog(@"-----商品添加进列表 --------");
        break;
      }
      default: break;
    }
  }
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
	NSLog(@"交易结束");
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
