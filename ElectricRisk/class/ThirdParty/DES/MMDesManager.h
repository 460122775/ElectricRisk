//
//  MMDesManager.h
//  MasMobile
//
//  Created by poxiao on 15/11/30.
//  Copyright © 2015年 poxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMDesManager : NSObject

+ (NSString *)doubleAES128Encrypt:(NSString *)content;

+ (NSString *)AES128Encrypt:(NSString *)content;
//解密
+ (NSString *)AES128Decrypt:(NSString *)content;

+ (NSString *)doubleAES128Decrypt:(NSString *)content;


/**
 *  3des加密
 *
 *  @param encryptString 待加密的string
 *  @param keyString     约定的密钥
 *  @param ivString      约定的密钥
 *
 *  @return 3des加密后的string
 */
+(NSString*)getEncryptWithString:(NSString*)encryptString keyString:(NSString*)keyString ivString:(NSString*)ivString;

/**
 *  3des解密
 *
 *  @param decryptString 待解密的string
 *  @param keyString     约定的密钥
 *  @param ivString      约定的密钥
 *
 *  @return 3des解密后的string
 */
+(NSString*)getDecryptWithString:(NSString*)decryptString keyString:(NSString*)keyString ivString:(NSString*)ivString;

@end
