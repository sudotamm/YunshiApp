//
//  GouwuHuikuiView.m
//  RootDirectory
//
//  Created by ryan on 2/6/15.
//  Copyright (c) 2015 Ryan. All rights reserved.
//

#import "GouwuHuikuiView.h"

#define kReuseCellIdentify @"HuikuiCollectionCell"

@implementation GouwuHuikuiView

#pragma mark - Public methods

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (IBAction)quedingButtonClicked:(id)sender
{
    [[RYRootBlurViewManager sharedManger] hideBlurView];
    NSMutableArray *selectedArray = [NSMutableArray array];
    for(ShanginHuikuiModel *shm in [GouwucheDataManager sharedManager].shangpinHuikuiArray)
    {
        if(shm.isSelected)
            [selectedArray addObject:shm];
    }
    [[GouwucheDataManager sharedManager] requestSaveOrderWithUserId:[ABCMemberDataManager sharedManager].loginMember.userId
                                                          mendianId:[HomeDataManager sharedManger].currentDianpu.sCode
                                                         gouwuArray:[GouwucheDataManager sharedManager].selctedGouwuArray
                                                        fankuiArray:selectedArray];
}

#pragma mark - UIView methods
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HuikuiCollectionCell" bundle:nil] forCellWithReuseIdentifier:kReuseCellIdentify];
}

#pragma mark - UICollectionViewDataSource methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [GouwucheDataManager sharedManager].shangpinHuikuiArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HuikuiCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseCellIdentify forIndexPath:indexPath];
    ShanginHuikuiModel *shm = [[GouwucheDataManager sharedManager].shangpinHuikuiArray objectAtIndex:indexPath.row];
    [cell reloadWithShangpinHuikui:shm];
    return cell;
}

#pragma mark - UICollectionViewDelegate methods
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{}


@end
