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
}

-(void)requestNoticeListData
{
    [self testNoticeData];
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
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [noticeDataArray removeAllObjects];
            NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
            if (dataDic == nil)
            {
                [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [noticeDataArray addObject:dataDic];
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
    NSData *objectData = [@"{\"state\":1,\"data\":{\"content\":\"报审标题\",\"publish_date\":1237892000,\"name\":\"姓名\",\"state\":1,\"id\":1,\"title\":\"项目名称\"}}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
    [noticeDataArray removeAllObjects];
    [noticeDataArray addObject:dataDic];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)warnBtnClick:(id)sender
{
    [self.noticeBtn setTitleColor:Color_black forState:UIControlStateNormal];
    [self.warnBtn setTitleColor:Color_me forState:UIControlStateNormal];
    self.underLineLeading.constant = self.noticeBtn.frame.size.width;
    isNoticeList = NO;
    [self requestWarnListData];
}

-(void)requestWarnListData
{
    [self testWarnData];
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
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_WARN_LSIT) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [warnDataArray removeAllObjects];
            NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
            if (dataDic == nil)
            {
                [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [warnDataArray addObject:dataDic];
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
    NSData *objectData = [@"{\"state\":1,\"data\":{\"content\":\"内容\",\"creat_time\":1237892000,\"name\":\"姓名\",\"state\":1,\"id\":1,\"title\":\"标题\",\"address\":\"项目的地质\",\"plan_end_time\":\"计划结束时间\",\"real_start_tim\":\"实际开始时间\",\"real_end_time\":\"实际结束时间\",\"plan_start_time\":\"计划开始时间\",\"project_id\":11}}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    NSDictionary* dataDic = (NSDictionary*)[result objectForKey:@"data"];
    [warnDataArray removeAllObjects];
    [warnDataArray addObject:dataDic];
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

@end
