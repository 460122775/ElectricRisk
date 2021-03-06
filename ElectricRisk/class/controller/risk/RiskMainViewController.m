//
//  RiskMainViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskMainViewController.h"

@interface RiskMainViewController ()

@end

@implementation RiskMainViewController

static NSString *RiskMainListCellId = @"RiskMainListCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerNameArray = [[NSMutableArray alloc] init];
    totalDataArray = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RiskMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RiskMainListCellId];
    [[UITabBar appearance] setTintColor:Color_me];
    
    [self initRefreshView];
    
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    selectedDataDic = nil;
}

-(void)initRefreshView
{
    // Pull Down.
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.delegate = self;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    // Pull Down.
    if (refreshView == _header)
    {
        if (OFFLINE)
        {
            [self testData];
        }else{
            [self requestData:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"content\":[{\"address\":\"卡升级卢萨卡的减肥还是啦快点发货\",\"content\":\"施工准备\",\"id\":47,\"is_active\":1,\"schedule\":10,\"time\":1469980800000,\"title\":\"测试项目测试项目\"}],\"grade\":1},{\"content\":[{\"address\":\"dfgd\",\"content\":\"施工准备\",\"id\":76,\"is_active\":0,\"schedule\":20,\"time\":1470844800000,\"title\":\"第六个\"}],\"grade\":2},{\"content\":[{\"address\":\"dfgd\",\"content\":\"架设架空线路\",\"id\":89,\"is_active\":0,\"schedule\":30,\"time\":1471449600000,\"title\":\"第六个\"}],\"grade\":4},{\"content\":[{\"address\":\"dfgd\",\"content\":\"配电箱及开关箱安装\",\"id\":88,\"is_active\":1,\"schedule\":40,\"time\":1471449600000,\"title\":\"第六个\"}],\"grade\":5}],\"projects\":[{\"id\":17,\"name\":\"天祥广场\"},{\"id\":18,\"name\":\"新希望中心\"},{\"id\":19,\"name\":\"test111\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        projectArray = (NSArray*)[result objectForKey:@"projects"];
        NSArray* dataArr = (NSArray*)[result objectForKey:@"data"];
        [totalDataArray removeAllObjects];
        if (dataArr == nil || dataArr.count == 0)
        {
            [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            // Sort by grade
            for (int i = 10; i > 0; i--)
            {
                for (NSDictionary *tempDic in dataArr)
                {
                    int grade = [(NSNumber*)[tempDic objectForKey:@"grade"] intValue];
                    if (i == grade)
                    {
                        [totalDataArray addObject:tempDic];
                    }
                }
            }
            dataDic = [[NSMutableDictionary alloc] init];
            [headerNameArray removeAllObjects];
            NSMutableArray* dataArrTemp = nil;
            for (NSDictionary* tempDic in totalDataArray)
            {
                int grade = [(NSNumber*)[tempDic objectForKey:@"grade"] intValue];
                dataArrTemp = [dataDic objectForKey:[NSString stringWithFormat:@"%i", grade]];
                if (dataArrTemp == nil)
                {
                    dataArrTemp = [tempDic objectForKey:@"content"];
                    [dataDic setObject:dataArrTemp forKey:[NSString stringWithFormat:@"%i", grade]];
                    [headerNameArray addObject:[NSString stringWithFormat:@"%i", grade]];
                }
            }
        }
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.header endRefreshing];
    });
}

-(void)requestData:(NSDictionary*)dict
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
    if(dict == nil) dict = @{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                           @"uid":[SystemConfig instance].currentUserId,
                           @"area":@"",
                           @"projectid":@"",
                           @"levelStart":@"",
                           @"levelEnd":@""};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            projectArray = (NSArray*)[result objectForKey:@"projects"];
            NSArray* dataArr = (NSArray*)[result objectForKey:@"data"];
            [totalDataArray removeAllObjects];
            if (dataArr == nil || dataArr.count == 0)
            {
                [[JTToast toastWithText:@"未获取到数据，或数据为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                // Sort by grade
                for (int i = 10; i > 0; i--)
                {
                    for (NSDictionary *tempDic in dataArr)
                    {
                        if ([[tempDic objectForKey:@"grade"] rangeOfString:[NSString stringWithFormat:@"%i", i]].location != NSNotFound)
                        {
                            [totalDataArray addObject:tempDic];
                        }
                    }
                }
                dataDic = [[NSMutableDictionary alloc] init];
                [headerNameArray removeAllObjects];
                NSMutableArray* dataArrTemp = nil;
                for (NSDictionary* tempDic in totalDataArray)
                {
                    dataArrTemp = [dataDic objectForKey:[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"grade"]]];
                    if (dataArrTemp == nil)
                    {
                        dataArrTemp = [tempDic objectForKey:@"content"];
                        [dataDic setObject:dataArrTemp forKey:[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"grade"]]];
                        [headerNameArray addObject:[NSString stringWithFormat:@"%@", [tempDic objectForKey:@"grade"]]];
                    }
                }
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

- (IBAction)searchBtnClick:(id)sender
{
    if(riskSearchViewController == nil)
    {
        riskSearchViewController = [[RiskSearchViewController alloc] initWithNibName:@"RiskSearchViewController" bundle:nil];
        riskSearchViewController.delegate = self;
        riskSearchViewController.modalPresentationStyle = UIModalPresentationCustom;
        riskSearchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self presentViewController:riskSearchViewController animated:YES completion:nil];
    [riskSearchViewController initViewWithData:projectArray];
}

-(void)riskSearchWithArea:(NSString*)area andProjectid:(NSString*)projectid andSLevel:(NSString*)startLevel andEndLevel:(NSString*)endLevel
{
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData:@{@"c_time":[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000],
                                   @"uid":[SystemConfig instance].currentUserId,
                                   @"area":area,
                                   @"projectid":projectid,
                                   @"levelStart":startLevel,
                                   @"levelEnd":endLevel}
         ];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (headerNameArray == nil) return 0;
    return headerNameArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataDic == nil || headerNameArray == nil) return 0;
    NSString *key = [headerNameArray objectAtIndex:section];
    if ([dataDic objectForKey:key] == nil) return 0;
    NSArray *rowArr = (NSArray*)[dataDic objectForKey:key];
    return rowArr.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 7, 200, 17)];
    titleLabel.text = [NSString stringWithFormat:@"%@级风险", [headerNameArray objectAtIndex:section]];
    titleLabel.textColor = [UIColor darkGrayColor];
    [headerView addSubview:titleLabel];
    [headerView setBackgroundColor:[UIColor colorWithWhite:0.88 alpha:1.0]];
//    if([[headerNameArray objectAtIndex:section] isEqualToString:@"1"])
//    {
//        [headerView setBackgroundColor:Color_oneGrade];
//    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"2"]){
//        [headerView setBackgroundColor:Color_twoGrade];
//    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"3"]){
//        [headerView setBackgroundColor:Color_threeGrade];
//    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"4"]){
//        [headerView setBackgroundColor:Color_fourGrade];
//    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"5"]){
//        [headerView setBackgroundColor:Color_fiveGrade];
//    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RiskMainListCell *cell= [tableView dequeueReusableCellWithIdentifier:RiskMainListCellId];
    NSString *key = [headerNameArray objectAtIndex:indexPath.section];
    NSArray *rowArr = (NSArray*)[dataDic objectForKey:key];
    cell.dataDic = [rowArr objectAtIndex:indexPath.row];
    [cell setViewByData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = [headerNameArray objectAtIndex:indexPath.section];
    NSArray *rowArr = (NSArray*)[dataDic objectForKey:key];
    selectedDataDic = [rowArr objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"RiskToDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"RiskToDetail"])
    {
        RiskDetailViewController *riskDetailViewController = [segue destinationViewController];
        [riskDetailViewController initViewWithData:selectedDataDic];
    }
}

- (IBAction)statisticsBtnClick:(id)sender
{
    [self performSegueWithIdentifier:@"RiskToStatistics" sender:self];
}

@end
