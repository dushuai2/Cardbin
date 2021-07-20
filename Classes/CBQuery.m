//
//  CBQuery.m
//  CardBin
//
//  Created by 赵勇 on 1/3/16.
//  Copyright © 2016 CB. All rights reserved.
//

#import "CBQuery.h"
#import <FMDB/FMDatabase.h>
#import "FMEncryptHelper.h"
#import "CBBank.h"

@implementation CBQuery

+ (CBBank *)queryBIN:(NSString *)BIN {
	if (BIN.length < 6) {
		return nil;
	}
	NSString *dbName = nil;
#if ASIA
	dbName = @"db-asia";
#elif AMERICA
	dbName = @"db-america";
#elif EUROPE
	dbName = @"db-europe";
#elif AFRICA
    dbName = @"db-africa";
#elif SOUTHAMERICA
    dbName = @"db-southAmerica";
#else
	dbName = @"db-america";
#endif

	NSString *sql = [NSString stringWithFormat:@"select * from CardBinSource where CardNumber=%@", [BIN substringToIndex:6]];
	NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:dbName];
	NSString *path = [[NSBundle mainBundle] pathForResource:dbName ofType:nil];
	BOOL unencrypt = [FMEncryptHelper unEncryptDatabase:path targetPath:cache];
	if (!unencrypt) {
		return nil;
	}
	FMDatabase *db = [FMDatabase databaseWithPath:cache];
	if (![db open]) {
		NSLog(@"打开数据库失败！");
	}
	FMResultSet *rs = [db executeQuery:sql];
	CBBank *bank = nil;
	while (rs.next) {
		NSString *param1 = [rs stringForColumn:@"CardNumber"];
		NSString *param2 = [rs stringForColumn:@"BankName"];
		NSString *param3 = [rs stringForColumn:@"CardType"];
		NSString *param4 = [rs stringForColumn:@"Country"];
		NSString *param5 = [rs stringForColumn:@"BankPhone"];
    NSDictionary *json = @{@"cardNumber" : param1 ?: @"",
                           @"bankName" : param2 ?: @"",
                           @"cardType" : param3 ?: @"",
                           @"country" : param4 ?: @"",
                           @"bankPhone" : param5 ?: @""};
		bank = [CBBank modelWithDictionary:json error:nil];
	}
	[db close];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		BOOL deleteCache = [[NSFileManager defaultManager] removeItemAtPath:cache error:nil];
		NSLog(@"删除数据库缓存%@", deleteCache ? @"成功" : @"失败");
	});
	return bank;
}

@end
