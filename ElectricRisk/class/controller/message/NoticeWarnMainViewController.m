//
//  NoticeWarnMainViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/2/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "NoticeWarnMainViewController.h"

@interface NoticeWarnMainViewController ()

@end

@implementation NoticeWarnMainViewController

static NSString *NoticeMainListCellId = @"NoticeMainListCell";
static NSString *WarnMainListCellId = @"WarnMainListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    noticeDataArray = [[NSMutableArray alloc] init];
    warnDataArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NoticeMainListCellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"WarnMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WarnMainListCellId];
    
    [self noticeBtnClick:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noticeBtnClick:(id)sender
{
    [self.noticeBtn setTitleColor:Color_me forState:UIControlStateNormal];
    [self.warnBtn setTitleColor:Color_black forState:UIControlStateNormal];
    self.underLineLeading.constant = 0;
    isNoticeList = YES;
    [self requestNoticeListData];
//    [self.addBtn setHidden:NO];
    [self.myNoticeBtn setHidden:NO];
}

-(void)requestNoticeListData
{
    if (OFFLINE)
    {
        [self testNoticeData];
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
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            noticeDataArray = (NSArray*)[result objectForKey:@"data"];
            if (noticeDataArray == nil || noticeDataArray.count == 0)
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

-(void)testNoticeData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"content\":\"thisismessage\",\"id\":2499,\"name\":\"admin\",\"notice_id\":61,\"publish_date\":1471449600000,\"state\":0,\"title\":\"title\"},{\"content\":\"hello world\",\"id\":2499,\"name\":\"yasin\",\"notice_id\":61,\"publish_date\":1471448800000,\"state\":1,\"title\":\"Helloworld\"},{\"content\":\"hello world\",\"id\":2499,\"name\":\"yasin\",\"notice_id\":61,\"publish_date\":1471448800000,\"state\":2,\"title\":\"Helloworld\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        noticeDataArray = (NSArray*)[result objectForKey:@"data"];
        if (noticeDataArray == nil || noticeDataArray.count == 0)
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

- (IBAction)warnBtnClick:(id)sender
{
    [self.noticeBtn setTitleColor:Color_black forState:UIControlStateNormal];
    [self.warnBtn setTitleColor:Color_me forState:UIControlStateNormal];
    self.underLineLeading.constant = self.noticeBtn.frame.size.width;
    isNoticeList = NO;
    [self requestWarnListData];
    [self.myNoticeBtn setHidden:YES];
}

- (IBAction)myNoticeBtnClick:(id)sender
{
    [self performSegueWithIdentifier:@"ToMyNoticeView" sender:self];
}

-(void)requestWarnListData
{
    if (OFFLINE)
    {
        [self testWarnData];
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
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_WARN_LSIT) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            warnDataArray = (NSArray*)[result objectForKey:@"data"];
            if (warnDataArray == nil || warnDataArray.count == 0)
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

-(void)testWarnData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"address\":\"dfgd\",\"content\":\"架设架空线路\",\"creat_time\":1471449600000,\"gy_risk_id\":2,\"id\":89,\"is_active\":0,\"is_gy_risk\":2,\"k_value\":\"0.2\",\"level\":4,\"name\":\"第六个\",\"plan_end_time\":1471968000000,\"plan_start_time\":1471881600000,\"project_id\":55,\"real_start_time\":1471449600000,\"risk_type\":\"高大模板支撑\",\"state\":3,\"user_id\":\"a2a6adfc78f043cbb50150f9921b34e0\"},{\"address\":\"dfgd\",\"content\":\"配电箱及开关箱安装\",\"creat_time\":1471449600000,\"gy_risk_id\":6,\"id\":88,\"is_active\":1,\"is_gy_risk\":2,\"k_value\":\"0.1\",\"level\":5,\"name\":\"第六个\",\"plan_end_time\":1472572800000,\"plan_start_time\":1471968000000,\"project_id\":55,\"real_start_time\":1471449600000,\"risk_type\":\"高大模板支撑\",\"state\":3,\"user_id\":\"a2a6adfc78f043cbb50150f9921b34e0\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        warnDataArray = (NSArray*)[result objectForKey:@"data"];
        if (warnDataArray == nil || warnDataArray.count == 0)
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

- (IBAction)writeBtnClick:(id)sender
{
    if (isNoticeList)
    {
        [self performSegueWithIdentifier:@"ToAddNotice" sender:self];
    }else{
//        [self performSegueWithIdentifier:@"ToAddWarn" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isNoticeList)
    {
        if (noticeDataArray == nil) return 0;
        return noticeDataArray.count;
    }else{
        if (warnDataArray == nil) return 0;
        return warnDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isNoticeList)
    {
        NoticeMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:NoticeMainListCellId];
        cell.dataDic = [noticeDataArray objectAtIndex:indexPath.row];
        [cell setViewByData];
        return cell;
    }else{
        WarnMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:WarnMainListCellId];
        cell.dataDic = [warnDataArray objectAtIndex:indexPath.row];
        [cell setViewByData];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isNoticeList)
    {
        currentSelectedNotice = [noticeDataArray objectAtIndex:indexPath.row];
        if(currentSelectedNotice != nil)
        {
            [self performSegueWithIdentifier:@"ToNoticeDetail" sender:self];
        }
    }else{
        currentSelectedWarn = [warnDataArray objectAtIndex:indexPath.row];
        if(currentSelectedWarn != nil)
        {
//            [self performSegueWithIdentifier:@"ToWarnDetail" sender:self];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToNoticeDetail"])
    {
        NoticeDetailViewController *noticeDetailViewController = [segue destinationViewController];
        [noticeDetailViewController initViewWithData:currentSelectedNotice];
    }else if ([[segue identifier] isEqualToString:@"ToAddNotice"]){
        NoticeAddViewController *noticeAddViewController = [segue destinationViewController];
        noticeAddViewController.delegate = self;
    }
}

-(void)noticeAddSuccessControl
{
    [self requestNoticeListData];
}

@end
