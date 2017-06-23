//
//  RiskDetailViewController.m
//  ElectricRisk
//
//  Created by yasin zhang on 16/8/27.
//  Copyright © 2016年 com.yasin.electric. All rights reserved.
//

#import "RiskAddViewController.h"

@interface RiskAddViewController ()

@end

@implementation RiskAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dtfrm = [[NSDateFormatter alloc] init];
    [dtfrm setDateFormat:@"yyyy-MM-dd"];
    // Do any additional setup after loading the view from its nib.
    self.ryImgArray = [[NSMutableArray alloc] init];
    self.sgImgArray = [[NSMutableArray alloc] init];
    self.xcImgArray = [[NSMutableArray alloc] init];
    self.zgImgArray = [[NSMutableArray alloc] init];
    
    self.ryContentView.layer.borderWidth = 1;
    self.ryContentView.layer.borderColor = Color_border.CGColor;
    self.sgContentView.layer.borderWidth = 1;
    self.sgContentView.layer.borderColor = Color_border.CGColor;
    self.xcContentView.layer.borderWidth = 1;
    self.xcContentView.layer.borderColor = Color_border.CGColor;
    self.zgContentView.layer.borderWidth = 1;
    self.zgContentView.layer.borderColor = Color_border.CGColor;
    
    self.ryContentView.delegate = self;
    self.sgContentView.delegate = self;
    self.xcContentView.delegate = self;
    self.zgContentView.delegate = self;
    self.sgProcessInput.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initViewWithRisk:self.riskDataDic andDetail:self.riskDetailDataDic];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewWithRisk:(NSDictionary*)riskDataDic andDetail:(NSDictionary*) riskDetailDic
{
    self.riskDataDic = riskDataDic;
    self.riskDetailDataDic = riskDetailDic;
    if (self.addressLabel == nil) return;
    if (OFFLINE)
    {
        [self testGetWrongData];
    }else{
        [self requestGetWrongData];
    }
    [self initViewByDetailData];
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        [[JTToast toastWithText:@"提交成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil) [self.delegate riskExecutiveInfoAddSuccess];
            [self dismissViewControllerAnimated:YES completion:nil];
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
    HUD.labelText = @"正在保存数据...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%.f", [[NSDate date] timeIntervalSince1970] * 1000] forKey:@"c_time"];
    [dict setObject:[SystemConfig instance].currentUserId forKey:@"uid"];
    [dict setObject:[self.riskDataDic objectForKey:@"id"] forKey:@"id"];
    [dict setObject:self.sgProcessInput.text forKey:@"progressValue"];
    NSMutableDictionary *xcDic = [[NSMutableDictionary alloc] init];
    [xcDic setObject:self.xcContentView.text forKey:@"content"];
    [xcDic setObject:self.xcImgArray forKey:@"imgids"];
    [dict setObject:xcDic forKey:@"work"];
    NSMutableDictionary *zgDic = [[NSMutableDictionary alloc] init];
    [zgDic setObject:self.zgContentView.text forKey:@"content"];
    [zgDic setObject:self.zgImgArray forKey:@"imgids"];
    [zgDic setObject:(!(self.zgSwitch.isOn) || currentSelectWrongDic == nil) ? @"":[currentSelectWrongDic objectForKey:@"id"] forKey:@"id"];
    [dict setObject:zgDic forKey:@"check"];
    NSMutableDictionary *sgDic = [[NSMutableDictionary alloc] init];
    [sgDic setObject:self.sgContentView.text forKey:@"content"];
    [sgDic setObject:self.sgImgArray forKey:@"imgids"];
    [dict setObject:sgDic forKey:@"progress"];
    NSMutableDictionary *ryDic = [[NSMutableDictionary alloc] init];
    [ryDic setObject:self.ryContentView.text forKey:@"content"];
    [ryDic setObject:self.ryImgArray forKey:@"imgids"];
    
    if ([SystemConfig instance].currentUserRole == ROLE_4)
    {
        [dict setObject:ryDic forKey:@"personYZ"];
    }else if ([SystemConfig instance].currentUserRole == ROLE_5){
        [dict setObject:ryDic forKey:@"personJL"];
    }else if ([SystemConfig instance].currentUserRole == ROLE_6){
        [dict setObject:ryDic forKey:@"personSG"];
    }
    
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_ADD) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            [[JTToast toastWithText:@"提交成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate != nil) [self.delegate riskExecutiveInfoAddSuccess];
                [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)testImgUploadData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"original\": \"无标题4.png\",    \"size\": 21339,    \"state\": \"SUCCESS\",    \"title\": \"/project/getImg.do?id=e1566f6b614f4c8b91aacb173496ea43\",    \"type\": \"4.png\",    \"url\": \"/project/getImg.do?id=e1566f6b614f4c8b91aacb173496ea43\",    \"id\": \"e1566f6b614f4c8b91aacb173496ea43\"}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    NSString *state = [result objectForKey:@"state"];
    if ([state isEqualToString:@"SUCCESS"])
    {
        [[JTToast toastWithText:@"图片上传成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        NSString *imgId = [result objectForKey:@"id"];
        [currentImgArray addObject:imgId];
        [self addImgToScrollView];
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestImgUploadData:(NSData*)imageData
{
    if (HUD == nil)
    {
        HUD = [[MBProgressHUD alloc]init];
    }
    [self.view addSubview:HUD];
    HUD.dimBackground =YES;
    HUD.labelText = @"正在上传图片...";
    [HUD removeFromSuperViewOnHide];
    [HUD showByCustomView:YES];
    
    [RequestModal uploadPhoto:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_UPLOADIMG) parameter:imageData success:^(id responseData) {
        NSDictionary *result = responseData;
        NSString *state = [result objectForKey:@"state"];
        if ([state isEqualToString:@"SUCCESS"])
        {
            [[JTToast toastWithText:@"图片上传成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            NSString *imgId = [result objectForKey:@"id"];
            [currentImgArray addObject:imgId];
            [self addImgToScrollView];
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

-(void)addImgToScrollView
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTag:currentScrollView.tag];
    [btn setImage:currentImage forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteImgControl:) forControlEvents:UIControlEventTouchUpInside];
    currentScrollViewHeight.constant = HEIGHT_SCROLLVIEW;
    int x = 0;
    for (UIButton *subImgView in currentScrollView.subviews)
    {
        x += subImgView.frame.size.width;
    }
    btn.frame = CGRectMake(x + [currentScrollView subviews].count * ImgPadding, 0, (currentImage.size.width * HEIGHT_SCROLLVIEW) / currentImage.size.height, HEIGHT_SCROLLVIEW);
    [currentScrollView addSubview:btn];
    currentScrollView.contentSize = CGSizeMake(btn.frame.origin.x + btn.frame.size.width, HEIGHT_SCROLLVIEW);
}

-(void)deleteImgControl:(UIButton*)sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:@"确定要删除所选择的图片吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        DLog(@"%li", (long)sender.tag)
        [self setCurrentByTag:sender.tag];
        BOOL notFound = YES;
        int x = sender.frame.origin.x;
        UIButton *btn = nil;
        for (int i = 0; i < currentScrollView.subviews.count; i++)
        {
            btn = (UIButton*)[currentScrollView.subviews objectAtIndex:i];
            if (sender == btn)
            {
                [currentImgArray removeObjectAtIndex:i];
                notFound = NO;
            }else if (!notFound){
                btn.frame = CGRectMake(x, 0, btn.frame.size.width, btn.frame.size.height);
                x += btn.frame.size.width + ImgPadding;
            }
        }
        [sender removeFromSuperview];
        if (currentScrollView.subviews.count == 0)
        {
            currentScrollViewHeight.constant = 1;
        }else{
            currentScrollView.contentSize = CGSizeMake(currentScrollView.contentSize.width - sender.frame.size.width - ImgPadding, currentScrollView.contentSize.height);
        }
     }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)testGetWrongData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"state\": 1,\"data\": [{\"id\": \"73056ba2fdce4d528f53081365790813\",\"content\": \"nnn\"}]}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        self.wrongDataArray = [result objectForKey:@"data"];
        currentSelectWrongDic = nil;
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
    }
}

-(void)requestGetWrongData
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
                           @"uid":[SystemConfig instance].currentUserId,
                           @"id":[self.riskDataDic objectForKey:@"id"]};
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_RISK_WRONG) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        if (state == State_Success)
        {
            self.wrongDataArray = [result objectForKey:@"data"];
            currentSelectWrongDic = nil;
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
    if(self.riskDetailDataDic == nil) return;
    
    self.projectNameLabel.text = [self.riskDetailDataDic objectForKey:@"NAME"];
    self.addressLabel.text = [self.riskDetailDataDic objectForKey:@"ADDRESS"];
    NSDate *startTimeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.riskDetailDataDic objectForKey:@"plan_start_time"] doubleValue] / 1000.0)];
    self.startTimeLabel.text = [dtfrm stringFromDate:startTimeDate];
    NSDate *endTimeDate = [NSDate dateWithTimeIntervalSince1970:([(NSNumber*)[self.riskDetailDataDic objectForKey:@"plan_end_time"] doubleValue] / 1000.0)];
    self.endTimeLabel.text = [dtfrm stringFromDate:endTimeDate];
    NSDate *nowTimeDate = [[NSDate alloc] init];
    self.currentDateLabel.text = [dtfrm stringFromDate:nowTimeDate];
}

- (IBAction)zgWzBtnClick:(id)sender
{
    RiskWrongListViewController *riskWrongListViewController = [[RiskWrongListViewController alloc] initWithNibName:@"RiskWrongListViewController" bundle:nil];
    riskWrongListViewController.modalPresentationStyle = UIModalPresentationCustom;
    riskWrongListViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    riskWrongListViewController.delegate = self;
    [riskWrongListViewController initViewWithData:self.wrongDataArray];
    [self presentViewController:riskWrongListViewController animated:YES completion:nil];
}

- (IBAction)zgSwitchChanged:(id)sender
{
    [self.zgWzBtn setHidden:!(self.zgSwitch.isOn)];
    [self.zgWzLabel setHidden:!(self.zgSwitch.isOn)];
    currentSelectWrongDic = nil;
    self.zgWzLabel.text = @"";
}

- (IBAction)imgBtnClick:(id)sender
{
    [self setCurrentByTag:((UIButton*)sender).tag];
    if(imagePickerController == nil)
    {
        imagePickerController = [[UIImagePickerController alloc] init];
    }
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self.view addSubview:imagePickerController.view];
    [imagePickerController viewWillAppear:YES];
    [imagePickerController viewDidAppear:YES];
//    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void) navigationController: (UINavigationController *) navigationController  willShowViewController: (UIViewController *) viewController animated: (BOOL) animated {
    if (imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
//        UIBarButtonItem* button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCamera:)];
//        viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:button1];
//    } else {
        UIBarButtonItem* button2 = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showLibrary:)];
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:button2];
        viewController.navigationController.navigationBarHidden = NO; // important
    }
}

- (void) showCamera: (id) sender {
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
}

- (void) showLibrary: (id) sender {
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    currentImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (OFFLINE)
    {
        [self testImgUploadData];
    }else{
        [self requestImgUploadData: UIImageJPEGRepresentation(currentImage, 0)];
    }
    [imagePickerController.view removeFromSuperview];
//    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backBtnClick:(id)sender
{
    [self resignKeyboard];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:@"确定放弃本次填报的内容吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)finishBtnClick:(id)sender
{
    [self resignKeyboard];
    if (self.ryContentView.text == nil || self.ryContentView.text.length == 0)
    {
        [[JTToast toastWithText:@"请填写人员到岗情况" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (self.xcContentView.text == nil || self.xcContentView.text.length == 0){
        [[JTToast toastWithText:@"请填写施工现场执行情况" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (self.zgSwitch.isOn && currentSelectWrongDic == nil){
        [[JTToast toastWithText:@"请选择违章内容" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
//    }else if (self.zgContentView.text == nil || self.zgContentView.text.length == 0){
//        [[JTToast toastWithText:
//          [NSString stringWithFormat:@"请填写%@情况", (self.zgSwitch.isOn) ? @"违章" : @"整改"] configuration:[JTToastConfiguration defaultConfiguration]]show];
//        return;
    }else if (self.sgContentView.text == nil || self.sgContentView.text.length == 0){
        [[JTToast toastWithText:@"请填写施工进度情况" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (self.sgProcessInput.text == nil || self.sgProcessInput.text.length == 0){
        [[JTToast toastWithText:@"请填写施工进度" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    NSString *pattern = @"^\\d{1,3}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self.sgProcessInput.text];
    int proccess = [self.sgProcessInput.text intValue];
    int currentProccess = [(NSNumber*)[self.riskDataDic objectForKey:@"schedule"] intValue];
    if (!isMatch || proccess > 100)
    {
        [[JTToast toastWithText:@"施工进度填写错误" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }else if (proccess < currentProccess){
        [[JTToast toastWithText:@"进度值应大于已完成进度" configuration:[JTToastConfiguration defaultConfiguration]]show];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请确认" message:@"确定提交本次填报的内容吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        if (OFFLINE)
        {
            [self testData];
        }else{
            [self requestData];
        }
    }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)resignKeyboard
{
    if([self.ryContentView isFirstResponder])
    {
        [self.ryContentView resignFirstResponder];
    }else if([self.ryContentView isFirstResponder]){
        [self.sgContentView resignFirstResponder];
    }else if([self.sgContentView isFirstResponder]){
        [self.ryContentView resignFirstResponder];
    }else if([self.xcContentView isFirstResponder]){
        [self.xcContentView resignFirstResponder];
    }else if([self.zgContentView isFirstResponder]){
        [self.zgContentView resignFirstResponder];
    }else if([self.sgProcessInput isFirstResponder]){
        [self.sgProcessInput resignFirstResponder];
    }
}

-(void)setCurrentByTag:(NSInteger)tag
{
    switch (tag)
    {
        case 1:
            currentImgArray = self.ryImgArray;
            currentScrollView = self.ryImgScrollView;
            currentScrollViewHeight = self.ryScrollViewHeight;
            break;
        case 2:
            currentImgArray = self.xcImgArray;
            currentScrollView = self.xcImgScrollView;
            currentScrollViewHeight = self.xcImgScrollViewHeight;
            break;
        case 3:
            currentImgArray = self.zgImgArray;
            currentScrollView = self.zgImgScrollView;
            currentScrollViewHeight = self.zgImgScrollViewHeight;
            break;
        case 4:
            currentImgArray = self.sgImgArray;
            currentScrollView = self.sgImgScrollView;
            currentScrollViewHeight = self.sgImgScrollViewHeight;
            break;
        default:
            break;
    }
}

-(void)wrongListChooseControl:(NSDictionary*)wrongDic
{
    currentSelectWrongDic = wrongDic;
    self.zgWzLabel.text = [NSString stringWithFormat:@"：%@", [wrongDic objectForKey:@"content"]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignKeyboard];
    return YES;
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    currentKeyboardHeight = kbSize.height;
    self.paddingBottom.constant = currentKeyboardHeight + 20;
//    self.mainScrollView.contentOffset = CGPointMake(self.mainScrollView.contentOffset.x, self.mainScrollView.contentOffset.y + currentKeyboardHeight);
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    int y = self.mainScrollView.contentOffset.y - currentKeyboardHeight;
    self.paddingBottom.constant = 20;
    self.mainScrollView.contentOffset = CGPointMake(self.mainScrollView.contentOffset.x, (y < 0) ? 0 : y);
}

@end
