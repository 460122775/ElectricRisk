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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.checkBtn setHidden:![self getRight:self.checkBtn]];
    [self.verifyBtn setHidden:![self getRight:self.verifyBtn]];
    self.underLineLeading.constant = -1000;
    if (self.checkBtn.hidden == NO)
    {
        [self checkBtnClick:nil];
    }else if (self.verifyBtn.hidden == NO){
        [self verifyBtnClick:nil];
    }
}

-(BOOL)getRight:(UIView*)view
{
    if (view == self.checkBtn)
    {
        switch ([SystemConfig instance].currentUserRole)
        {
            case ROLE_4:
            case ROLE_5:
            case ROLE_6:
            case ROLE_A: return YES; break;
            default: return NO; break;
        }
    }else if(view == self.verifyBtn){
        switch ([SystemConfig instance].currentUserRole)
        {
            case ROLE_8:
            case ROLE_A: return YES; break;
            default: return NO; break;
        }
    }
    return NO;
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
    if (OFFLINE)
    {
        [self testCheckData];
        return;
    }
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
            checkDataArray = (NSArray*)[result objectForKey:@"data"];
            if (checkDataArray == nil || checkDataArray.count == 0)
            {
                [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
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
    NSData *objectData = [@"{\"data\":[{\"CONTENT\":\"tongyi\",\"C_TIME\":1469721600000,\"ID\":17,\"NAME\":\"天祥广场\",\"STATE\":42,\"USER_NAME\":\"admin\",\"c_time\":1469721600000,\"content\":\"tongyi\",\"id\":17,\"name\":\"天祥广场\",\"state\":3,\"user_name\":\"admin\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        checkDataArray = (NSArray*)[result objectForKey:@"data"];
        if (checkDataArray == nil || checkDataArray.count == 0)
        {
            [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [HUD hideByCustomView:YES];
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
    if (OFFLINE)
    {
        [self testVerifyData];
        return;
    }
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
            verifyDataArray = (NSArray*)[result objectForKey:@"data"];
            if (verifyDataArray == nil || verifyDataArray.count == 0)
            {
                [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
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
    NSData *objectData = [@"{\"data\":[{\"c_time\":1471449600000,\"content\":\"sdasfasdf\",\"id\":49,\"name\":\"第六个\",\"state\":4,\"user_name\":\"dlg-jl-1\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        verifyDataArray = (NSArray*)[result objectForKey:@"data"];
        if (verifyDataArray == nil || verifyDataArray.count == 0)
        {
            [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    [HUD hideByCustomView:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isCheckList)
    {
        currentSelectedCheck = [checkDataArray objectAtIndex:indexPath.row];
        if(currentSelectedCheck != nil)
        {
            [self performSegueWithIdentifier:@"ToCheckDetail" sender:self];
        }
    }else{
        currentSelectedVerify = [verifyDataArray objectAtIndex:indexPath.row];
        if(currentSelectedVerify != nil)
        {
            [self performSegueWithIdentifier:@"ToVerifyDetail" sender:self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToCheckDetail"])
    {
        CheckDetailViewController *checkDetailViewController = [segue destinationViewController];
        [checkDetailViewController initViewWithData:currentSelectedCheck];
    }else if ([[segue identifier] isEqualToString:@"ToVerifyDetail"]){
        VerifyDetailViewController *verifyDetailViewController = [segue destinationViewController];
        [verifyDetailViewController initViewWithData:currentSelectedVerify];
        
    }
}


@end
