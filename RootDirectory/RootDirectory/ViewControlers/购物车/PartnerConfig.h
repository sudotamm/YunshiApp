//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088811244468534"//帐号
//收款支付宝账号
#define SellerID  @"2088811244468534"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"ne6mr7na79yqbth79efql9nb6axuc857"

//商户私钥，自助生成(pkcs8)
#define PartnerPrivKey @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJ86GNnVEInLVbdZjBcbzQNvslaLj+kOJ9nhVIP+Hp9ZqL19kbFOQEJrqG1jD2vJyDKtiy9i8JvgUqgiYYWNMFwgz0yNZw512yjsp39y1CQfO7nwi3ZcvSS0hCo6H+sh7fjAX30JbQmuA6NftO2WTyWfjq0vKx7AdwEJPAhZrVfzAgMBAAECgYAg30OmJSCm8f2ePrR3SNwIa5Tr3SA2wx9jEev63AnCaCY4CKZ9bmRB0iwReTQD0sKsA7wKami2JZeq8n4jrkRfTWGoiRQy3Yc5AHXMrlApiptQv4f39nmT4YtJxf0a1dAxV/gIJfvge1E7fUFe/mvzZlf6nyy+fV9YVjyNDuIOUQJBAMovJv+wJE0UNwj8E9R7eR9JgCKyQDwU9hvHt/3oujU6fHP6BapfaMOj7ivWbNa5ctSjCz520CexS2y6LcU6X28CQQDJm9WUb7w5drXNcPiTxcTLGlAAUOB7rN4fqHDZR8nAGp7YTzaMRhRsjh/emGCWNKziPiW4td1o3h92f0s+5829AkA+nGGAVsS3FeaBIsblSyNUHAfRNtALixY3vh5tQ8++QhFePPPaMdeYlkBgVPO5fw5faOpHerW1RQMtdW5NIGmDAkBDM2t0x+3Qpa4h5ZcmApT/Mi0afdrlvpBnswiylEg+fWEXLwg6p51lNdaPpvEDAFnkK9z8/bnom6mXIQUe2bttAkA8msrgZZXaO901E8o+hDbGyOECUb3el58nufNAj/5tKNbyO0xClriBZUj/8qcjoNvWsA3J/NFxJdKP/IBD4+Vj"

//支付宝公钥（固定）
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#define AlipayNotifyUrl @""

#endif
