//
//  NoticeDetailViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 9/5/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithData:self.noticeDataDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithData:(NSDictionary*)noticeDataDic
{
    self.noticeDataDic = noticeDataDic;
    if (self.noticeTitleLabel == nil) return;
    if (OFFLINE)
    {
        [self testData];
    }else{
        [self requestData];
    }
    // Request read.
    int state = [(NSNumber*)[self.noticeDataDic objectForKey:@"state"] intValue];
    if (state == Notice_State_Not)
    {
        if (OFFLINE)
        {
            [self testReadData];
        }else{
            [self requestReadData];
        }
    }
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":[{\"red_time\":1470844800000,\"reply\":\"ggg\",\"state\":3,\"user_name\":\"txgjgc-yz-1\"},{\"RED_TIME\":1470844800000,\"REPLY\":\"egresseskingdomsBibbGoghthugBibbBBB\",\"STATE\":3,\"USER_NAME\":\"admin\",\"red_time\":1470844800000,\"reply\":\"egresseskingdomsBibbGoghthugBibbBBB\",\"state\":3,\"user_name\":\"admin\"}],\"msg\":\"加载成功\",\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.commentArray = [result objectForKey:@"data"];
        if (self.commentArray == nil || self.commentArray.count == 0)
        {
            [[JTToast toastWithText:@"该公告还没有人回复" configuration:[JTToastConfiguration defaultConfiguration]]show];
        }else{
            [self initViewByDetailData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.commentTableView reloadData];
        });
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestData
{
    if (self.noticeDataDic == nil) return;
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
                           @"id":[self.noticeDataDic objectForKey:@"notice_id"]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_COMMENT_LIST) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.commentArray = [result objectForKey:@"data"];
            if (self.commentArray == nil || self.commentArray.count == 0)
            {
                [[JTToast toastWithText:@"该公告还没有人回复" configuration:[JTToastConfiguration defaultConfiguration]]show];
            }else{
                [self initViewByDetailData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.commentTableView reloadData];
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

-(void)testReadData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state != State_Success)
    {
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestReadData
{
    if (self.noticeDataDic == nil) return;
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
                           @"id":[self.noticeDataDic objectForKey:@"id"]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_READ) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state != State_Success)
        {
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)testCommentData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\": 1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:@"回复成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        [self initViewWithData:self.noticeDataDic];
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestComment
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
                           @"id":[self.noticeDataDic objectForKey:@"id"],
                           @"content":self.commentInput.text};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_NOTICE_COMMENT) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"回复成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            self.commentInput.text = @"";
            [self initViewWithData:self.noticeDataDic];
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)initViewByDetailData
{
    if(self.noticeTitleLabel == nil) return;
    NSDateFormatter *dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.noticeTitleLabel.text = [self.noticeDataDic objectForKey:@"title"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.noticeDataDic objectForKey:@"publish_date"] doubleValue] / 1000.0)];
    self.timeLabel.text = [dtfrm stringFromDate:timeDate];
    self.contentTextView.text = [self.noticeDataDic objectForKey:@"content"];
    self.contentTextViewHeight.constant = [self.contentTextView contentSize].height;
}

- (IBAction)commentBtnClick:(id)sender
{
    if (self.commentInput.text == nil || self.commentInput.text.length < 1)
    {
        [[JTToast toastWithText:@"请输入回复的内容" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    if (OFFLINE)
    {
        [self testCommentData];
    }else{
        [self requestComment];
    }
}

- (IBAction)goBackBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.commentArray == nil) return 0;
    return self.commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NoticeCommentCell = @"NoticeCommentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeCommentCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: NoticeCommentCell];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",
                           [(NSDictionary*)[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"user_name"],
                           [(NSDictionary*)[self.commentArray objectAtIndex:indexPath.row] objectForKey:@"reply"]];
    return cell;
}

@end
