//
//  GouwucheDataManager.m
//  RootDirectory
//
//  Created by ryan on 2/4/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwucheDataManager.h"

#define kManehuikuiDownlaoderKey        @"ManehuikuiDownlaoderKey"
#define kSaveOrderDownloaderKey         @"SaveOrderDownloaderKey"
#define kUpdadteDeliverDownloaderKey    @"UpdadteDeliverDownloaderKey"
#define kCancelOrderDownloaderKey       @"CancelOrderDownloaderKey"
#define kShijianDownloaderKey           @"ShijianDownloaderKey"

@interface GouwucheDataManager()

@end

@implementation GouwucheDataManager

@synthesize qingdanArray,qingdanOrderId;

+ (instancetype)sharedManager
{
    static GouwucheDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[GouwucheDataManager alloc] init];
    });
    return manager;
}

- (NSString *)discountStr
{
    NSMutableString *finalStr = [NSMutableString string];
    NSString *numstr = [NSString stringWithFormat:@"%@",@(self.discount)];
    for(NSInteger i = 0; i < numstr.length; i++)
    {
        NSString *subNumStr = [numstr substringWithRange:NSMakeRange(i, 1)];
        NSInteger subnum = [subNumStr integerValue];
        switch (subnum) {
            case 1:
                [finalStr appendString:@"一"];
                break;
            case 2:
                [finalStr appendString:@"二"];
                break;
            case 3:
                [finalStr appendString:@"三"];
                break;
            case 4:
                [finalStr appendString:@"四"];
                break;
            case 5:
                [finalStr appendString:@"五"];
                break;
            case 6:
                [finalStr appendString:@"六"];
                break;
            case 7:
                [finalStr appendString:@"七"];
                break;
            case 8:
                [finalStr appendString:@"八"];
                break;
            case 9:
                [finalStr appendString:@"九"];
                break;
            default:
                break;
        }
    }
    return finalStr;
}

- (void)requestManehuikuiWithUserId:(NSString *)userId
                          mendianId:(NSString *)mendianId
                         gouwuArray:(NSMutableArray *)gouwuArray
{
    self.selctedGouwuArray = gouwuArray;
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kManehuikuiUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    NSMutableArray *list = [NSMutableArray array];
    for(GouwucheModel *gm in gouwuArray)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        [dictTemp setObject:gm.gId forKey:@"gId"];
        [dictTemp setObject:gm.gType forKey:@"gType"];
        [dictTemp setObject:gm.num forKey:@"num"];
        [list addObject:dictTemp];
    }
    [paramDict setObject:list forKey:@"list"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kManehuikuiDownlaoderKey];
}

- (void)requestSaveOrderWithUserId:(NSString *)userId
                         mendianId:(NSString *)mendianId
                        gouwuArray:(NSMutableArray *)gouwuArray
                       fankuiArray:(NSMutableArray *)fankuiArray
{
    self.qingdanArray = [NSMutableArray array];
    [self.qingdanArray addObjectsFromArray:gouwuArray];
    [self.qingdanArray addObjectsFromArray:fankuiArray];
    
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kSaveOrderUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:mendianId forKey:@"sCode"];
    NSMutableArray *list = [NSMutableArray array];
    //购物车选中商品列表
    for(GouwucheModel *gm in gouwuArray)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        [dictTemp setObject:gm.gId forKey:@"gId"];
        [dictTemp setObject:gm.gType forKey:@"gType"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwucheXiadannShangpinNormal)] forKey:@"valveType"];
        [dictTemp setObject:gm.num forKey:@"gNum"];
        [list addObject:dictTemp];
    }
    //满额回馈选中商品列表
    for(ShanginHuikuiModel *shm in fankuiArray)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        [dictTemp setObject:shm.gId forKey:@"gId"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwuTypeShangpin)] forKey:@"gType"];
        [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwucheXiadannShangpinHuikui)] forKey:@"valveType"];
        [dictTemp setObject:@"1" forKey:@"gNum"];
        [list addObject:dictTemp];
    }
    [paramDict setObject:list forKey:@"list"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kSaveOrderDownloaderKey];
}

- (void)requestUpdateDeliverInfoWithUserId:(NSString *)userId
                                   orderId:(NSString *)orderId
                                  yyztName:(NSString *)yyztName
                                     sCode:(NSString *)sCode
                                 yyztPhone:(NSString *)yyztPhone
                                  yyztTime:(NSString *)yyztTime
                                  zpAddrId:(NSString *)zpAddrId
                                    zpTime:(NSString *)zpTime
                                      list:(NSMutableArray *)list
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kUpdateDeliverUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userId forKey:@"userId"];
    [paramDict setObject:orderId forKey:@"ordered"];
    
    [paramDict setObject:yyztName==nil?@"":yyztName forKey:@"yyztName"];
    [paramDict setObject:sCode forKey:@"sCode"];
    [paramDict setObject:yyztPhone==nil?@"":yyztPhone forKey:@"yyztPhone"];
    [paramDict setObject:yyztTime==nil?@"":yyztTime forKey:@"yyztTime"];
    [paramDict setObject:zpAddrId==nil?@"":zpAddrId forKey:@"zpAddrId"];
    [paramDict setObject:zpTime==nil?@"":zpTime forKey:@"zpTime"];
    NSMutableArray *array = [NSMutableArray array];
    for(id qingdanModel in list)
    {
        NSMutableDictionary *dictTemp = [NSMutableDictionary dictionary];
        if([qingdanModel isKindOfClass:[GouwucheModel class]])
        {
            GouwucheModel *gm = (GouwucheModel *)qingdanModel;
            [dictTemp setObject:gm.gId forKey:@"gId"];
            [dictTemp setObject:[NSString stringWithFormat:@"%@",@(gm.peisongFangshi+1)] forKey:@"deliverType"];
            [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwucheXiadannShangpinNormal)] forKey:@"valveType"];
        }
        else
        {
            ShanginHuikuiModel *shm = (ShanginHuikuiModel *)qingdanModel;
            [dictTemp setObject:shm.gId forKey:@"gId"];
            [dictTemp setObject:[NSString stringWithFormat:@"%@",@(shm.peisongFangshi+1)] forKey:@"deliverType"];
            [dictTemp setObject:[NSString stringWithFormat:@"%@",@(kGouwucheXiadannShangpinHuikui)] forKey:@"valveType"];
        }
        [array addObject:dictTemp];
    }
    [paramDict setObject:array forKey:@"list"];
    
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kUpdadteDeliverDownloaderKey];
}

- (void)requestCancelOrderWithOrderId:(NSString *)orderId
                           cancelType:(OrderCancelType)cancelType
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kCancelOrderUrl];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[ABCMemberDataManager sharedManager].loginMember.userId forKey:@"userId"];
    [paramDict setObject:orderId forKey:@"oId"];
    [paramDict setObject:[NSString stringWithFormat:@"%@",@(cancelType)] forKey:@"type"];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:paramDict
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kCancelOrderDownloaderKey];
}

- (void)requestPeisongshijian
{
    [[RYHUDManager sharedManager] startedNetWorkActivityWithText:@"加载中..."];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServerAddress,kPeisongshijianUrl];
    [[RYDownloaderManager sharedManager] requestDataByPostWithURLString:url
                                                             postParams:nil
                                                            contentType:@"application/json"
                                                               delegate:self
                                                                purpose:kShijianDownloaderKey];
}

- (NSMutableArray *)shijianArrayForString:(NSString *)shijian containShouwei:(BOOL)containShouwei
{
    NSDate *todayDate = [NSDate date];
    NSDate *tomorrowDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:todayDate];
    NSString *todayStr = [NSDate dateToStringByFormat:@"yyyy-MM-dd" date:todayDate];
    NSString *tomorrowStr = [NSDate dateToStringByFormat:@"yyyy-MM-dd" date:tomorrowDate];
    
    //处理预约时间
    NSMutableArray *shijianArray = [NSMutableArray array];
    NSArray *yuyueArray = [shijian componentsSeparatedByString:@"-"];
    @try {
        if(yuyueArray.count == 2)
        {
            NSString *yuyueStart = [yuyueArray firstObject];
            NSString *yuyueEnd = [yuyueArray lastObject];
            NSInteger start = [[[yuyueStart componentsSeparatedByString:@":"] firstObject] integerValue];
            NSInteger end = [[[yuyueEnd componentsSeparatedByString:@":"] firstObject] integerValue];
            if(!containShouwei)
            {
//                start += 1;
                end -= 1;
            }
            for(NSInteger i = start; i <= end; i++)
            {
                NSString *todayHour = [NSString stringWithFormat:@"%@ %@:00",todayStr,@(i)];
                [shijianArray addObject:todayHour];
            }
            for(NSInteger i = start; i <= end; i++)
            {
                NSString *tomorrowHour = [NSString stringWithFormat:@"%@ %@:00",tomorrowStr,@(i)];
                [shijianArray addObject:tomorrowHour];
            }
        }
    }
    @catch (NSException *exception) {
        shijianArray = [NSMutableArray array];
    }
    return shijianArray;
}

#pragma mark - RYDownloaderDelegate methods
- (void)downloader:(RYDownloader*)downloader completeWithNSData:(NSData*)data
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if([downloader.purpose isEqualToString:kManehuikuiDownlaoderKey])
    {
        //满额回馈返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            self.shangpinHuikuiArray = [NSMutableArray array];
            NSArray *array = [dict objectForKey:@"list"];
            if(array.count > 0)
            {
                //显示满额回馈页面
                [[RYHUDManager sharedManager] stoppedNetWorkActivity];
                for(NSDictionary *dictHuikui in array)
                {
                    ShanginHuikuiModel *shm = [[ShanginHuikuiModel alloc] initWithRYDict:dictHuikui];
                    shm.isSelected = NO;
                    [self.shangpinHuikuiArray addObject:shm];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kShangpinhuiKuiResponseNotification object:nil];
            }
            else
            {
                //满额回馈商品为空，跳转下单
                [self requestSaveOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                       mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                      gouwuArray:self.selctedGouwuArray
                                     fankuiArray:nil];
            }
        }
        else if([[dict objectForKey:kCodeKey] integerValue] == 0)
        {
            //无满额回馈，跳转下单
            [self requestSaveOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                   mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                  gouwuArray:self.selctedGouwuArray
                                 fankuiArray:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"满额回馈获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kSaveOrderDownloaderKey])
    {
        //保存订单返回
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            NSString *zhekouStr = [dict objectForKey:@"discount"];
            if(zhekouStr.length > 0)
            {
                NSInteger zhekou = [[dict objectForKey:@"discount"] integerValue];
                self.discount = zhekou;
            }
            NSString *orderId = [dict objectForKey:@"ordered"];
            if(orderId.length > 0)
            {
                self.qingdanOrderId = orderId;
                //跳转购物清单页面
                [[NSNotificationCenter defaultCenter] postNotificationName:kDingdanResponseNotification object:nil];
            }
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"生成订单失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kUpdadteDeliverDownloaderKey])
    {
        //更新订单配送信息
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeliverResponseNotification object:nil];
        }
        else if([[dict objectForKey:kCodeKey] integerValue] == 2)
        {
            //订单过期
            [[RYHUDManager sharedManager] showWithMessage:@"订单操作超时，请重新下单。" customView:nil hideDelay:3.f];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateDeliverTimeoutNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"更新订单配送信息失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kCancelOrderDownloaderKey])
    {
        //取消订单返回信息
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCancelOrderResponseNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"取消订单失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
    else if([downloader.purpose isEqualToString:kShijianDownloaderKey])
    {
        //预约时间返回信息
        if([[dict objectForKey:kCodeKey] integerValue] == kSuccessCode)
        {
            [[RYHUDManager sharedManager] stoppedNetWorkActivity];
            
            NSString *appointTime = [dict objectForKey:@"appointTime"];
            NSString *regionIn = [dict objectForKey:@"regionIn"];
            NSString *regionOut = [dict objectForKey:@"regionOut"];
            //处理预约时间
            self.yuyueshijianArray = [NSMutableArray arrayWithArray:[self shijianArrayForString:appointTime containShouwei:NO]];
            //处理区内时间
            self.quneishijianArray = [NSMutableArray arrayWithArray:[self shijianArrayForString:regionIn containShouwei:NO]];
            //处理区外时间
            self.quwaishijianArray = [NSMutableArray array];
            NSArray *quwaiArray = [regionOut componentsSeparatedByString:@"/"];
            for(NSString *quwaiStr in quwaiArray)
            {
                NSMutableArray *tempArray = [self shijianArrayForString:quwaiStr containShouwei:YES];
                [self.quwaishijianArray addObjectsFromArray:tempArray];
            }
            [self.quwaishijianArray sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:kShijianResponseSucceedNotification object:nil];
        }
        else
        {
            NSString *message = [dict objectForKey:kMessageKey];
            if(message.length == 0)
                message = @"配送时间获取失败";
            [[RYHUDManager sharedManager] showWithMessage:message customView:nil hideDelay:2.f];
        }
    }
}
- (void)downloader:(RYDownloader*)downloader didFinishWithError:(NSString*)message
{
    [[RYHUDManager sharedManager] showWithMessage:kNetWorkErrorString customView:nil hideDelay:2.f];
}

@end
