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
    
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RiskMainListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:RiskMainListCellId];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self testData];
//    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1,\"data\":[{\"grade\":1,\"content\":{\"title\":\"title\",\"address\":\"address\",\"content\":\"content\",\"schedule\":1,\"time\":13543035405000,\"id\":1}},{\"grade\":2,\"content\":{\"title\":\"title\",\"address\":\"address\",\"content\":\"content\",\"schedule\":1,\"time\":13543035405000,\"id\":2}}]}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    totalDataArray = (NSArray*)[result objectForKey:@"data"];
    if (totalDataArray == nil) return;
    dataDic = [[NSMutableDictionary alloc] init];
    [headerNameArray removeAllObjects];
    NSMutableArray* dataArrTemp = nil;
    for (NSDictionary* tempDic in totalDataArray)
    {
        int grade = [(NSNumber*)[tempDic objectForKey:@"grade"] intValue];
        dataArrTemp = [dataDic objectForKey:[NSString stringWithFormat:@"%i", grade]];
        if (dataArrTemp == nil)
        {
            dataArrTemp = [[NSMutableArray alloc] init];
            [dataDic setObject:dataArrTemp forKey:[NSString stringWithFormat:@"%i", grade]];
            [headerNameArray addObject:[NSString stringWithFormat:@"%i", grade]];
        }
        [dataArrTemp addObject:[tempDic objectForKey:@"content"]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
                           @"uid":[NSString stringWithFormat:@"%i", [SystemConfig instance].currentUserId],
                           @"area":@"",
                           @"project":@"",
                           @"levelStart":@"1",
                           @"levelEnd":@"9"};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            totalDataArray = (NSArray*)[result objectForKey:@"data"];
            if (totalDataArray == nil || totalDataArray.count == 0)
            {
                [[JTToast toastWithText:(NSString*)[result objectForKey:@"未获取到数据，或数据为空"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                dataDic = [[NSMutableDictionary alloc] init];
                [headerNameArray removeAllObjects];
                NSMutableArray* dataArrTemp = nil;
                for (NSDictionary* tempDic in totalDataArray)
                {
                    int grade = [(NSNumber*)[tempDic objectForKey:@"grade"] intValue];
                    dataArrTemp = [dataDic objectForKey:[NSString stringWithFormat:@"%i", grade]];
                    if (dataArrTemp == nil)
                    {
                        dataArrTemp = [[NSMutableArray alloc] init];
                        [dataDic setObject:dataArrTemp forKey:[NSString stringWithFormat:@"%i", grade]];
                        [headerNameArray addObject:[NSString stringWithFormat:@"%i", grade]];
                    }
                    [dataArrTemp addObject:[tempDic objectForKey:@"content"]];
                }
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

- (IBAction)searchBtnClick:(id)sender
{
    RiskSearchViewController *riskSearchViewController = [[RiskSearchViewController alloc] initWithNibName:@"RiskSearchViewController" bundle:nil];
    riskSearchViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskSearchViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:riskSearchViewController animated:YES completion:nil];
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
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    if([[headerNameArray objectAtIndex:section] isEqualToString:@"1"])
    {
        [headerView setBackgroundColor:[UIColor colorWithRed:92/255.0 green:172/255.0 blue:238/255.0 alpha:1]];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"2"]){
        [headerView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:185/255.0 blue:15/255.0 alpha:1]];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"3"]){
        [headerView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1]];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"4"]){
        [headerView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1]];
    }else if([[headerNameArray objectAtIndex:section] isEqualToString:@"5"]){
        [headerView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:48/255.0 blue:48/255.0 alpha:1]];
    }
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

@end
