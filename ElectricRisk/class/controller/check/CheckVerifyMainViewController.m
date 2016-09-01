//
//  CheckVerifyMainViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 9/2/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "CheckVerifyMainViewController.h"

@interface CheckVerifyMainViewController ()

@end

@implementation CheckVerifyMainViewController

static NSString *CheckMainListCellId = @"CheckMainListCell";
static NSString *VerifyMainListCellId = @"VerifyMainListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    checkDataArray = [[NSMutableArray alloc] init];
    verifyDataArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CheckMainListCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"VerifyMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:VerifyMainListCellId];
    
    [self checkBtnClick:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkBtnClick:(id)sender
{
    [self.checkBtn setTitleColor:Color_me forState:UIControlStateNormal];
    [self.verifyBtn setTitleColor:Color_black forState:UIControlStateNormal];
    self.underLineLeading.constant = 0;
    isCheckList = YES;
    [self requestCheckListData];
}

-(void)requestCheckListData
{
    [self testCheckData];
    return;
    
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在加载数据...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"goName":@""};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_CHECKLIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [checkDataArray removeAllObjects];
            NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
            if (dataDic == nil)
            {
                [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [checkDataArray addObject:dataDic];
            }
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testCheckData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1,\"data\":{\"project_name\":\"报审标题\",\"approval_time\":1237892000,\"user_nickname\":\"姓名\",\"approval_state\":2,\"id\":1}}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
    [checkDataArray removeAllObjects];
    [checkDataArray addObject:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)verifyBtnClick:(id)sender
{
    [self.checkBtn setTitleColor:Color_black forState:UIControlStateNormal];
    [self.verifyBtn setTitleColor:Color_me forState:UIControlStateNormal];
    self.underLineLeading.constant = self.checkBtn.frame.size.width;
    isCheckList = NO;
    [self requestVerifyListData];
}

-(void)requestVerifyListData
{
    [self testVerifyData];
    return;
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在加载数据...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"goName":@""};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_VERIFYLIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [verifyDataArray removeAllObjects];
            NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
            if (dataDic == nil)
            {
                [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [verifyDataArray addObject:dataDic];
            }
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testVerifyData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1,\"data\":{\"content\":\"报审标题\",\"create_time\":1237892000,\"user_nickname\":\"姓名\",\"approval_state\":1,\"id\":1,\"name\":\"项目名称\"}}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
    [verifyDataArray removeAllObjects];
    [verifyDataArray addObject:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)searchBtnClick:(id)sender
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isCheckList)
    {
        if (checkDataArray == nil) return 0;
        return checkDataArray.count;
    }else{
        if (verifyDataArray == nil) return 0;
        return verifyDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isCheckList)
    {
        CheckMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:CheckMainListCellId];
        cell.dataDic = [checkDataArray objectAtIndex:indexPath.row];
        [cell setViewByData];
        return cell;
    }else{
        VerifyMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:CheckMainListCellId];
        cell.dataDic = [verifyDataArray objectAtIndex:indexPath.row];
        [cell setViewByData];
        return cell;
    }
}

@end
