//
//  SettingViewController.m
//  password
//
//  Created by kyle on 12/16/13.
//  Copyright (c) 2013 kyle. All rights reserved.
//

#import "SettingViewController.h"
#include "KShareViewManage.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController {
    __weak UISwitch *_passwordProtect;
    __weak UISwitch *_dataProtect;
    
    UIAlertView *_passwordProtectAlertView;
    UIAlertView *_dataProtectAlertView;
    UIAlertView *_cleanAppAlertView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.separatorColor = globalBackgroundColor;
    self.tableView.backgroundColor = globalBackgroundColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark --------- table view delegate -------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 8.0;
    }
    return 18.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 50;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentify = @"commonTableViewCellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(258, 6, 100, 40)];
    sw.tag = 'swch';
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"本地口令";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (![cell viewWithTag:'swch']) {
                    [cell.contentView addSubview:sw];
                    _passwordProtect = sw;
                    [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                }
                break;
            case 1:
                cell.textLabel.text = @"数据保护";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (![cell viewWithTag:'swch']) {
                    [cell.contentView addSubview:sw];
                    _dataProtect = sw;
                    [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                }
                break;
            case 2:
                cell.textLabel.text = @"修改密码";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"去评分";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"分享给小伙伴";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text = @"建议反馈";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text = @"关于";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        UIButton *cleanApp = [[UIButton alloc] initWithFrame:CGRectMake(20, 6, 280, 45)];
        cleanApp.backgroundColor = [UIColor colorWithRed:222/255.0 green:70/255.0 blue:67/255.0 alpha:0.8];
        [cleanApp setTitle:@"初始化应用" forState:UIControlStateNormal];
        [cleanApp setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
        [cleanApp addTarget:self action:@selector(cleanApp) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:cleanApp];
        cell.backgroundColor = globalBackgroundColor;
    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //分享到小伙伴
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSArray * array = [KShareViewManage getShareListWithType:SharedType_SinaWeibo, SharedType_WeChatCircel, SharedType_WeChatFriend, SharedType_TencentWeibo, SharedType_QQChat, nil];
        [KShareViewManage showViewToShareText:@"我发现了一个好玩的应用，从此妈妈再也不担心我记不住密码啦！" platform:array inViewController:self];
    }

    return nil;
}

- (void)cleanApp
{
    _cleanAppAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定初始化应用吗？ 该操作将清除您的所有数据！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [_cleanAppAlertView show];
    
}

- (void)switchChanged:(id)sender
{
    if (sender == _passwordProtect) {
        if (_passwordProtect.on == NO) {
            _passwordProtectAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定取消本地口令吗? 唤醒应用不再需要密码!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [_passwordProtectAlertView show];
        }
    } else if(sender == _dataProtect) {
        if (_dataProtect.on == YES) {
            _dataProtectAlertView = [[UIAlertView alloc] initWithTitle:@"警告" message:@"确定开启数据保护功能吗? 本地口令连续认证错误10次销毁全部数据!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [_dataProtectAlertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _passwordProtectAlertView) {
        switch (buttonIndex) {
                //确定
            case 0:
                break;
                //取消
            case 1:
                [_passwordProtect setOn:YES animated:YES];
                break;
            default:
                break;
        }
    } else if (alertView == _dataProtectAlertView){
        switch (buttonIndex) {
                //确定
            case 0:
                break;
                //取消
            case 1:
                [_dataProtect setOn:NO animated:YES];
                break;
            default:
                break;
        }
    } else if (alertView == _cleanAppAlertView) {
        switch (buttonIndex) {
                //确定
            case 0:
                break;
                //取消
            case 1://
                break;
            default:
                break;
        }
    }
}

@end
