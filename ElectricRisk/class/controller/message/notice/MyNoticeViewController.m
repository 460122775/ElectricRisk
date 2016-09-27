//
//  MyNoticeViewController
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "MyNoticeViewController.h"

@interface MyNoticeViewController ()

@end

@implementation MyNoticeViewController

static NSString *NoticeMainListCellId = @"NoticeMainListCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NoticeMainListCellId];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{    \"data\": [        {            \"content\": \"this is message\",            \"creat_time\": 1471449600000,            \"creat_user\": \"1\",            \"id\": 61,            \"publish_date\": 1471449600000,            \"state\": 2,            \"title\": \"title\"        }    ],    \"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.noticeArray = [result objectForKey:@"data"];
        if (self.noticeArray == nil || self.noticeArray.count == 0)
        {
            [[JTToast toastWithText:@"您的消息列表为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestData
{
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
                           @"uid":[SystemConfig instance].currentUserId};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_MYLIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.noticeArray = [result objectForKey:@"data"];
            if (self.noticeArray == nil || self.noticeArray.count == 0)
            {
                [[JTToast toastWithText:@"您的消息列表为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.noticeArray == nil) return 0;
    return self.noticeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:NoticeMainListCellId];
    cell.dataDic = [self.noticeArray objectAtIndex:indexPath.row];
    [cell setViewByData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    currentSelectedNotice = [self.noticeArray objectAtIndex:indexPath.row];
    if(currentSelectedNotice != nil)
    {
        [self performSegueWithIdentifier:@"ToMyNoticeDetailView" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ToMyNoticeDetailView"])
    {
        NoticeDetailViewController *noticeDetailViewController = [segue destinationViewController];
        [noticeDetailViewController initViewWithData:currentSelectedNotice];
    }
}

@end
