//
//  CBQueryResultView.m
//  CardBin
//
//  Created by ZhàoYǒng on 16/6/17.
//  Copyright © 2016年 CB. All rights reserved.
//

#import "CBQueryResultView.h"
#import <Masonry/Masonry.h>
#import "UIColor+CBColor.h"
#import "UIFont+CBFont.h"
#import "CBBank.h"

@interface CBLabel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTextAlignment textAlignment;

@end

@implementation CBLabel

- (instancetype)init {
	self = [super init];
	if (self) {
		UILabel *label = [[UILabel alloc] init];
		label.textColor = [UIColor.themeColor colorWithAlphaComponent:0.7];
		label.font = UIFont.defaultFont;
		label.tag = 300;
		label.numberOfLines = 0;
		[self addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.bottom.equalTo(self);
			make.height.lessThanOrEqualTo(self);
		}];
		
		UIView *line = [[UIView alloc] init];
		line.backgroundColor = UIColor.themeColor;
		[self addSubview:line];
		[line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.bottom.equalTo(self);
			make.height.equalTo(@1);
		}];
	}
	return self;
}

- (void)setText:(NSString *)text {
	_text = text;
	UILabel *label = [self viewWithTag:300];
	label.text = text;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
	_textAlignment = textAlignment;
	UILabel *label = [self viewWithTag:300];
	label.textAlignment = textAlignment;
}

@end

@interface CBQueryResultView ()

@property (nonatomic, strong) CBBank *model;

@end

@implementation CBQueryResultView

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (self) {
		_model = model;
		self.backgroundColor = UIColor.clearColor;
		self.clipsToBounds = NO;
		
		CBLabel *nameTitle = [[CBLabel alloc] init];
		nameTitle.text = @"Bank:";
		[self addSubview:nameTitle];
		
		CBLabel *nameContent = [[CBLabel alloc] init];
		nameContent.text = self.model.bankName;
		nameContent.textAlignment = NSTextAlignmentCenter;
		[self addSubview:nameContent];
		
		CBLabel *typeTitle = [[CBLabel alloc] init];
		typeTitle.text = @"Card type:";
		[self addSubview:typeTitle];
		
		CBLabel *typeContent = [[CBLabel alloc] init];
		typeContent.text = self.model.cardType;
		typeContent.textAlignment = NSTextAlignmentCenter;
		[self addSubview:typeContent];
		
		CBLabel *countryTitle = [[CBLabel alloc] init];
		countryTitle.text = @"Country:";
		[self addSubview:countryTitle];
		
		CBLabel *countryContent = [[CBLabel alloc] init];
		countryContent.text = self.model.country;
		countryContent.textAlignment = NSTextAlignmentCenter;
		[self addSubview:countryContent];
		
		CBLabel *phoneTitle = [[CBLabel alloc] init];
		phoneTitle.text = @"Phone:";
		[self addSubview:phoneTitle];
		
		CBLabel *phoneContent = [[CBLabel alloc] init];
		phoneContent.text = self.model.bankPhone;
		phoneContent.textAlignment = NSTextAlignmentCenter;
		[self addSubview:phoneContent];
		
		UILabel *cardNumber = [[UILabel alloc] init];
		cardNumber.font = UIFont.defaultFont;
		cardNumber.textColor = [UIColor.themeColor colorWithAlphaComponent:0.7f];
		cardNumber.text = self.model.cardNumber;
		[self addSubview:cardNumber];
		
		[nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.width.equalTo(@80);
			make.top.equalTo(self);
		}];
		[cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(nameTitle.mas_top).offset(-40);
		}];
		[nameContent mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(nameTitle.mas_right).offset(20);
			make.right.equalTo(self).offset(-20);
			make.top.equalTo(self);
			make.height.equalTo(nameTitle);
		}];
		[typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.width.equalTo(@80);
			make.top.equalTo(nameContent.mas_bottom).offset(20);
		}];
		[typeContent mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(typeTitle.mas_right).offset(20);
			make.right.equalTo(self).offset(-20);
			make.top.equalTo(nameContent.mas_bottom).offset(20);
			make.height.equalTo(typeTitle);
		}];
		[countryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.width.equalTo(@80);
			make.top.equalTo(typeContent.mas_bottom).offset(20);
		}];
		[countryContent mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(countryTitle.mas_right).offset(20);
			make.right.equalTo(self).offset(-20);
			make.top.equalTo(typeContent.mas_bottom).offset(20);
			make.height.equalTo(countryTitle);
		}];
		[phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.width.equalTo(@80);
			make.top.equalTo(countryContent.mas_bottom).offset(20);
		}];
		[phoneContent mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(phoneTitle.mas_right).offset(20);
			make.right.bottom.equalTo(self).offset(-20);
			make.top.equalTo(countryContent.mas_bottom).offset(20);
			make.bottom.equalTo(self);
			make.height.equalTo(phoneTitle);
		}];
		
		nameTitle.tag = 200;
		nameContent.tag = 201;
		typeTitle.tag = 202;
		typeContent.tag = 203;
		countryTitle.tag = 204;
		countryContent.tag = 205;
		phoneTitle.tag = 206;
		phoneContent.tag = 207;
		
		[self show];
	}
	return self;
}

- (void)show {
	for (int i = 0; i < 8; i ++) {
		UIView *view = [self viewWithTag:200 + i];
		view.alpha = 0;
		view.transform = CGAffineTransformMakeTranslation(0, 20);
		[UIView animateWithDuration:0.4f delay:(i / 2) * 0.3 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			view.alpha = 1;
			view.transform = CGAffineTransformIdentity;
		} completion:nil];
	}
}

@end
