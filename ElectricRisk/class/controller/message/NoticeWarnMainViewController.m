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
    [self initRefreshView];
    [self noticeBtnClick:nil];
}

-(void)initRefreshView
{
    __unsafe_unretained NoticeWarnMainViewController *vc = self;
    // Pull Down.
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.delegate = self;
    
    // Pull Up.
    self.footer = [MJRefreshFooterView footer];
    self.footer.scrollView = self.tableView;
    
    // Pull Up Function.
    self.footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        if (isNoticeList == YES)
        {
            [vc requestNoticeListDataByPage:currentPage + 1];
        }else{
            [vc requestWarnListData];
        }
    };
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    // Pull Down.
    if (refreshView == _header)
    {
        currentPage = 1;
        if (isNoticeList == YES)
        {
            [self requestNoticeListDataByPage:1];
        }else{
            [self requestWarnListData];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNoticeBtn setHidden:![self getRight:self.myNoticeBtn]];
    [self.addBtn setHidden:![self getRight:self.addBtn]];
    [self.warnBtn setHidden:![self getRight:self.warnBtn]];
}

-(BOOL)getRight:(UIView*)view
{
    if (view == self.myNoticeBtn || view == self.addBtn)
    {
        switch ([SystemConfig instance].currentUserRole)
        {
            case ROLE_1:
            case ROLE_A: return YES; break;
            default: return NO; break;
        }
    }else if(view == self.warnBtn){
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

- (IBAction)noticeBtnClick:(id)sender
{
    [self.noticeBtn setTitleColor:Color_me forState:UIControlStateNormal];
    [self.warnBtn setTitleColor:Color_black forState:UIControlStateNormal];
    self.underLineLeading.constant = 0;
    isNoticeList = YES;
    [self requestNoticeListDataByPage:1];
    [self.myNoticeBtn setHidden:![self getRight:self.myNoticeBtn]];
    [self.addBtn setHidden:![self getRight:self.addBtn]];
    [self.footer setHidden:NO];
}

-(void)requestNoticeListDataByPage:(int)page
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
                           @"uid":[SystemConfig instance].currentUserId,
                           @"page":[NSString stringWithFormat:@"%i", page]};
    currentPage = page;
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            if ((NSArray*)[result objectForKey:@"data"] == nil || ((NSArray*)[result objectForKey:@"data"]).count == 0)
            {
                if(currentPage == 1)
                {
                    [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
                    noticeDataArray = (NSArray*)[result objectForKey:@"data"];
                }else{
                    [[JTToast toastWithText:@"已经是最后一页了" configuration:[JTToastConfiguration defaultConfiguration]]show];
                }
            }else{
                noticeDataArray = (NSArray*)[result objectForKey:@"data"];
            }
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
        });
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

-(void)testNoticeData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"content\":\"thisismessage\",\"id\":2499,\"name\":\"admin\",\"notice_id\":61,\"publish_date\":1471449600000,\"state\":0,\"title\":\"title\"},{\"content\":\"hello world\",\"id\":2499,\"name\":\"yasin\",\"notice_id\":61,\"publish_date\":1471448800000,\"state\":1,\"title\":\"Helloworld\"},{\"content\":\"<p>项目经理：张三</p><p>安全员：历史</p><p>项目经理：张三</p><p>安全员：历史</p><p>项目经理：张三</p><p>安全员：历史</p>\",\"id\":2499,\"name\":\"yasin\",\"notice_id\":61,\"publish_date\":1471448800000,\"state\":2,\"title\":\"Helloworld\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
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
        [self.header endRefreshing];
        [self.footer endRefreshing];
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
    [self.addBtn setHidden:YES];
    [self.myNoticeBtn setHidden:YES];
    [self.footer setHidden:YES];
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
                           @"uid":[SystemConfig instance].currentUserId};
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
            [self.header endRefreshing];
        });
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
        [self.header endRefreshing];
    }];
}

-(void)testWarnData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"address\":\"dfgd\",\"content\":\"架设架空线路\",\"creat_time\":1471449600000,\"gy_risk_id\":2,\"id\":89,\"is_active\":0,\"is_gy_risk\":2,\"k_value\":\"0.2\",\"level\":4,\"name\":\"第六个\",\"plan_end_time\":1471968000000,\"plan_start_time\":1471881600000,\"project_id\":55,\"real_start_time\":1471449600000,\"risk_type\":\"高大模板支撑\",\"state\":3,\"user_id\":\"a2a6adfc78f043cbb50150f9921b34e0\"},{\"address\":\"dfgd\",\"content\":\"配电箱及开关箱安装\",\"creat_time\":1471449600000,\"gy_risk_id\":6,\"id\":88,\"is_active\":1,\"is_gy_risk\":2,\"k_value\":\"0.1\",\"level\":5,\"name\":\"第六个\",\"plan_end_time\":1472572800000,\"plan_start_time\":1471968000000,\"project_id\":55,\"real_start_time\":1471449600000,\"risk_type\":\"高大模板支撑\",\"state\":4,\"user_id\":\"a2a6adfc78f043cbb50150f9921b34e0\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
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
        [self.header endRefreshing];
    });
}

-(void)requestDataForPublish
{
    if (OFFLINE)
    {
        [self testDataForPublish];
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
    
    int state = [(NSNumber*)[currentSelectedWarn objectForKey:@"state"] intValue];
    NSDictionary *dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[SystemConfig instance].currentUserId,
                           @"flag":[NSString stringWithFormat:@"%@", (state == Rish_PUBLISHSTATE_PUBLISH)?@"publish":@"back"],
                           @"id":[currentSelectedWarn objectForKey:@"id"]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_WARN_PUBLISH) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"操作成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self requestNoticeListDataByPage:currentPage];
        });
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testDataForPublish
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:@"操作成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self requestNoticeListDataByPage:1];
    });
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
            WarnDetailViewController *warnDetailViewController = [[WarnDetailViewController alloc] initWithNibName:@"WarnDetailViewController" bundle:nil];
            warnDetailViewController.modalPresentationStyle = UIModalPresentationCustom;
            warnDetailViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [warnDetailViewController initViewWithData:[warnDataArray objectAtIndex:indexPath.row]];
            [self presentViewController:warnDetailViewController animated:YES completion:nil];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return !isNoticeList;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [self performSegueWithIdentifier:@"ToModifyWarn" sender:self];
    }];
    editAction.backgroundColor = [UIColor lightGrayColor];
    
    currentSelectedWarn = [warnDataArray objectAtIndex:indexPath.row];
    int state = [(NSNumber*)[currentSelectedWarn objectForKey:@"state"] intValue];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:(state == Rish_PUBLISHSTATE_PUBLISH)?@"发布":@"撤回"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认"
                                                                        message:[NSString stringWithFormat:@"确定要%@该风险提醒的内容吗？", (state == Rish_PUBLISHSTATE_PUBLISH)?@"发布":@"撤回"]
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:(state == Rish_PUBLISHSTATE_PUBLISH)?@"发布":@"撤回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 if (OFFLINE)
                                 {
                                     [self testDataForPublish];
                                 }else{
                                     [self requestDataForPublish];
                                 }
                             }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction,editAction];
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
    }else if ([[segue identifier] isEqualToString:@"ToModifyWarn"]){
        WarnModifyViewController *warnModifyViewController = [segue destinationViewController];
        [warnModifyViewController initViewWithData:currentSelectedWarn];
        warnModifyViewController.delegate = self;
    }
}

-(void)noticeAddSuccessControl
{
    [self requestNoticeListDataByPage:1];
}

-(void)warnModifySuccess
{
    [self requestWarnListData];
}

@end
