//
//  GouwuQingdanViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwuQingdanViewController.h"
#import "PeisongXuanzeViewController.h"
#import "OrderDetailViewController.h"

@interface GouwuQingdanViewController ()

@end

@implementation GouwuQingdanViewController

#pragma mark - Public methods

- (IBAction)xiayibuButtonClicked:(id)sender
{
    BOOL containYuyueziti = NO;
    BOOL containZhaipei = NO;
    for(id qingdanModel in [GouwucheDataManager sharedManager].qingdanArray)
    {
        if([qingdanModel isKindOfClass:[GouwucheModel class]])
        {
            GouwucheModel *gm = (GouwucheModel *)qingdanModel;
            if(gm.peisongFangshi == kPeisongFangshiYuyueziti)
                containYuyueziti = YES;
            if(gm.peisongFangshi == kPeisongFangshiZaipei)
                containZhaipei = YES;
        }
        else
        {
            ShanginHuikuiModel *shm = (ShanginHuikuiModel *)qingdanModel;
            if(shm.peisongFangshi == kPeisongFangshiYuyueziti)
                containYuyueziti = YES;
            if(shm.peisongFangshi == kPeisongFangshiZaipei)
                containZhaipei = YES;
        }
    }
    if(!containZhaipei && !containYuyueziti)
    {
        [[GouwucheDataManager sharedManager] requestUpdateDeliverInfoWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                                        orderId:[GouwucheDataManager sharedManager].qingdanOrderId
                                                                       yyztName:@""
                                                                          sCode:[HomeDataManager sharedManger].currentDianpu.sCode
                                                                      yyztPhone:@""
                                                                       yyztTime:@""
                                                                       zpAddrId:@""
                                                                         zpTime:@""
                                                                           list:[GouwucheDataManager sharedManager].qingdanArray];
    }
    else
    {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PeisongXuanzeViewController *pxvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"PeisongXuanzeViewController"];
        if(containYuyueziti && containZhaipei)
            pxvc.viewType = kPeisongViewTypeZitiZhaipei;
        else if(containYuyueziti && !containZhaipei)
            pxvc.viewType = kPeisongViewTypeYuyueziti;
        else if(!containYuyueziti && containZhaipei)
            pxvc.viewType = kPeisongViewTypeZhaiPei;
        [self.navigationController pushViewController:pxvc animated:YES];
    }
}

- (void)reloadZongjiPrice
{
    CGFloat zongji = 0;
    BOOL isAllZiti = YES;
    //商品总价
    for(id qingdanModel in [GouwucheDataManager sharedManager].qingdanArray)
    {
        CGFloat price;
        if([qingdanModel isKindOfClass:[GouwucheModel class]])
        {
            GouwucheModel *gm = (GouwucheModel *)qingdanModel;
            if(gm.peisongFangshi == kPeisongFangshiZaipei)
                isAllZiti = NO;
            price = [gm.price floatValue];
            zongji += price*[gm.num integerValue];
        }
        else
        {
            ShanginHuikuiModel *shm = (ShanginHuikuiModel *)qingdanModel;
            if(shm.peisongFangshi == kPeisongFangshiZaipei)
                isAllZiti = NO;
            price = [shm.gnewPrice floatValue];
            zongji += price*1;
        }
    }
    if([GouwucheDataManager sharedManager].discount > 0 && [GouwucheDataManager sharedManager].discount < 100)
    {
        //折扣提示
        zongji = zongji*[GouwucheDataManager sharedManager].discount/100;
    }
    
    if(zongji > 0)
    {
        self.xiayibuButton.enabled = YES;
    }
    else
        self.xiayibuButton.enabled = NO;
    NSInteger yunfei;
    if(isAllZiti)
        yunfei = 0;
    else
    {
        //计算运费
        if([GouwucheDataManager sharedManager].deliverFee == 0)
        {
            //免运费
            yunfei = 0;
        }
        else
        {
            if([GouwucheDataManager sharedManager].deliverThreshold == 99999999)
            {
                //不包邮
                yunfei = [GouwucheDataManager sharedManager].deliverFee;
            }
            else
            {
                //阀值包邮
                if(zongji >= [GouwucheDataManager sharedManager].deliverThreshold)
                    yunfei = 0;
                else
                    yunfei = [GouwucheDataManager sharedManager].deliverFee;
            }
        }
}
    zongji = zongji+yunfei;
    self.zongjiLabel.text = [NSString stringWithFormat:@"￥%.2f",zongji];
    self.zongjiYunfeiLabel.text = [NSString stringWithFormat:@"￥%.2f",(CGFloat)yunfei];
}

- (void)reloadJiesuanView
{
    NSInteger deliverFee = [GouwucheDataManager sharedManager].deliverFee;
    NSInteger deliverThreshold = [GouwucheDataManager sharedManager].deliverThreshold;
    if(deliverFee == 0)
    {
        //免运费
        self.yunfeiTipLabel.hidden = YES;
        self.yunfeiLabel.hidden = NO;
        self.yunfeiLabel.text = @"免运费（指定区域）";
//        self.zongjiYunfeiLabel.text = @"￥0.00";
    }
    else
    {
//        self.zongjiYunfeiLabel.text = [NSString stringWithFormat:@"￥%@",@(deliverFee)];
        if(deliverThreshold == 99999999)
        {
            //不包邮
            self.yunfeiTipLabel.hidden = YES;
            self.yunfeiLabel.hidden = NO;
            self.yunfeiLabel.text = [NSString stringWithFormat:@"运费%@元",@(deliverFee)];
        }
        else
        {
            //阀值包邮
            self.yunfeiTipLabel.hidden = NO;
            self.yunfeiLabel.hidden = NO;
            self.yunfeiTipLabel.text = [NSString stringWithFormat:@"单笔消费满%@元免运费（指定区域）",@(deliverThreshold)];
            self.yunfeiLabel.text = [NSString stringWithFormat:@"单笔消费未满%@元运费%@元",@(deliverThreshold),@(deliverFee)];
        }
    }
}

- (void)showZhekouInfo
{
    if([GouwucheDataManager sharedManager].discount > 0 && [GouwucheDataManager sharedManager].discount < 100)
    {
        //折扣提示
        NSString *discountStr = [NSString stringWithFormat:@"当前折扣为%@折", @([GouwucheDataManager sharedManager].discount)];
        [[RYHUDManager sharedManager] showWithMessage:discountStr customView:nil hideDelay:4.f];
    }
}

#pragma mark - Notification methods
- (void)updateDeliverResponseWithNotification:(NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:NO];
    [self performSegueWithIdentifier:@"QingdanListToOrderDetail" sender:nil];
}

- (void)updateDeliverTimeoutWithNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowShouyeViewNotification object:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)cancelOrderResponseWithNotification:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BaseViewController methods
- (void)leftItemTapped
{
    [[GouwucheDataManager sharedManager] requestCancelOrderWithOrderId:[GouwucheDataManager sharedManager].qingdanOrderId
                                                            cancelType:kOrderCancelTypeCancel];
}

#pragma mark - UIViewController methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNaviTitle:@"购物清单"];
    [self setLeftNaviItemWithTitle:@"取消" imageName:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeliverResponseWithNotification:) name:kUpdateDeliverResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrderResponseWithNotification:) name:kCancelOrderResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeliverTimeoutWithNotification:) name:kUpdateDeliverTimeoutNotification object:nil];
    self.contentTableView.tableFooterView = [UIView new];

    [self performSelector:@selector(showZhekouInfo) withObject:nil afterDelay:0.3f];
    
    [self reloadJiesuanView];
    [self reloadZongjiPrice];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"QingdanListToOrderDetail"])
    {
        OrderDetailViewController *odvc = (OrderDetailViewController *)segue.destinationViewController;
        odvc.orderId = [GouwucheDataManager sharedManager].qingdanOrderId;
        odvc.orderType = kOrderTypeWeifukuan;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GouwucheDataManager sharedManager].qingdanArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GouwuQingdanTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GouwuQingdanTableCell"];
    cell.delegate = self;
    if(IsIos8)
    {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
    }
    id gouwuQingdanModel = [[GouwucheDataManager sharedManager].qingdanArray objectAtIndex:indexPath.row];
    [cell reloadWithGouwuQingdanModel:gouwuQingdanModel];
    return cell;
}

#pragma mark - GouwuQingdanTableCellDelegate methods

- (void)didYunsongfangshiChangedWithCell:(GouwuQingdanTableCell *)cell
{
    [self reloadZongjiPrice];
}
@end
