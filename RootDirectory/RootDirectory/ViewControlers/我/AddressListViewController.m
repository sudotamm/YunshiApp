//
//  AddressListViewController.m
//  RootDirectory
//
//  Created by ryan on 2/7/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddAddressViewController.h"

@interface AddressListViewController ()

@end

@implementation AddressListViewController

#pragma mark - Private methods

#pragma mark - Notification methods
- (void)addressListResponseWithNotification:(NSNotification *)notification
{
    [self.contentTableView reloadData];
}

#pragma mark - BaseViewController methods
- (void)rightItemTapped
{
    AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
    aavc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aavc animated:YES];
}

#pragma mark - Notification methods
- (void)addressEditResponseWithNotification:(NSNotification *)notification
{
    [self.navigationController popToViewController:self animated:YES];
    [[UserInfoDataManager sharedManager] requestAddressListWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId];
}

#pragma mark - UIViewController methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNaviTitle:@"收货地址"];
    [self setRightNaviItemWithTitle:nil imageName:@"ico-add-navi"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressListResponseWithNotification:) name:kAddressListResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressEditResponseWithNotification:) name:kAddressEditResponseNotification object:nil];
    self.contentTableView.tableFooterView = [UIView new];
    [self addressEditResponseWithNotification:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UserInfoDataManager sharedManager].addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableCell"];
    if(nil == cell)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AddressTableCell" owner:self options:nil];
        cell = [nibs lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    AddressModel *am = [[UserInfoDataManager sharedManager].addressArray objectAtIndex:indexPath.row];
    [cell reloadWithAddressModel:am];
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        AddressModel *am = [[UserInfoDataManager sharedManager].addressArray objectAtIndex:indexPath.row];
        [[UserInfoDataManager sharedManager] requestEditAddressWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                                 editType:kAddressEditTypeDelete
                                                                addressId:am.aId
                                                                 xingming:am.contactor
                                                                   shouji:am.phoneNum
                                                                 regionId:am.rId
                                                                  address:am.addr
                                                                isDefault:am.isDefault
                                                                      lat:am.lat
                                                                      lon:am.lon];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.forChosen)
    {
        AddressModel *am = [[UserInfoDataManager sharedManager].addressArray objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddressChosenNotification object:am];
    }
}

#pragma mark - AddressTableCellDelegate methods
- (void)didEditAddressWithCell:(AddressTableCell *)cell
{
    NSIndexPath *indexPath = [self.contentTableView indexPathForCell:cell];
    AddressModel *am = [[UserInfoDataManager sharedManager].addressArray objectAtIndex:indexPath.row];
    AddAddressViewController *aavc = [[AddAddressViewController alloc] init];
    aavc.addressModel = am;
    aavc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aavc animated:YES];
}

@end
