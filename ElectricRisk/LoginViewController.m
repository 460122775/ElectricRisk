//
//  LoginViewController.m
//  ElectricRisk
//
//  Created by Yachen Dai on 8/26/16.
//  Copyright © 2016 com.yasin.electric. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pwdTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.pwdTF.layer.borderWidth = 1;
    self.pwdTF.layer.cornerRadius = 20;
    UIImageView *pwdLeftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.pwdTF.frame.size.height)];
    [pwdLeftImg setImage:[UIImage imageNamed:@"login_input_mima.png"]];
    [pwdLeftImg setContentMode:UIViewContentModeCenter];
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(pwdLeftImg.frame.size.width - 1, 0, 1.0, pwdLeftImg.frame.size.height);
    [rightBorder setBackgroundColor:(__bridge CGColorRef _Nullable)([UIColor lightGrayColor])];
    [pwdLeftImg.layer addSublayer:rightBorder];
    self.pwdTF.leftView = pwdLeftImg;
    self.pwdTF.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTF.delegate = self;
    
    self.nameTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.nameTF.layer.borderWidth = 1;
    self.nameTF.layer.cornerRadius = 20;
    UIImageView *pwdRightImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.nameTF.frame.size.height)];
    [pwdRightImg setImage:[UIImage imageNamed:@"login_input_tubiao.png"]];
    [pwdRightImg setContentMode:UIViewContentModeCenter];
    self.nameTF.leftView = pwdRightImg;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    self.nameTF.delegate = self;
    
    self.loginBtn.layer.cornerRadius = 20;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserName"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUserPwd"];
    [self loginBtnClick:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardDidShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillHideNotification];
}

-(void)testData
{
    NSError *jsonError;
    NSData *objectData = [@"{\"data\":{\"baidu_token\":\"3856325673642991365\",\"createTimeCaption\":\"\",\"id_card\":\"\",\"organ_id\":\"1\",\"user_email\":\"\",\"user_id\":\"1\",\"user_mobile\":\"\",\"user_name\":\"admin\",\"user_nickname\":\"admin\",\"user_password\":\"E10ADC3949BA59ABBE56E057F20F883E\",\"user_status\":\"0\",\"user_telephone\":\"\",\"user_type\":\"1\"},\"msg\":\"登录成功\",\"role\":5,\"roles\":[{\"ROLE_ID\":\"5\",\"role_id\":\"1\"}],\"state\":1}" dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:objectData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&jsonError];
    int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
    if (state == State_Success)
    {
        NSDictionary* userData = (NSDictionary*)[result objectForKey:@"data"];
        if (userData == nil) return;
        [[JTToast toastWithText:@"登录成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
        // Save data.
        [SystemConfig instance].currentUserRole = [(NSNumber*)[result objectForKey:@"role"]
                                                   intValue];
        [SystemConfig instance].currentUserName = self.nameTF.text;
        [SystemConfig instance].currentUserPwd = self.pwdTF.text;
        [SystemConfig instance].currentUserId = [userData objectForKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SystemConfig instance].currentUserRole] forKey:@"currentUserRole"];
        [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserId forKey:@"currentUserId"];
        [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserName forKey:@"currentUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserPwd forKey:@"currentUserPwd"];
        [self performSegueWithIdentifier:@"LoginToHome" sender:self];
        self.nameTF.text = @"";
        self.pwdTF.text = @"";
    // Pwd wrong.
    }else{
        [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
        self.pwdTF.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnClick:(id)sender
{
    // Auto fill.
    if ((self.nameTF.text == nil || self.nameTF.text.length == 0) && [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"] != nil)
    {
        self.nameTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserName"];
    }
    if ((self.pwdTF.text == nil || self.pwdTF.text.length == 0) && [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserPwd"] != nil)
    {
        self.pwdTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserPwd"];
    }
    [self.nameTF resignFirstResponder];
    [self.pwdTF resignFirstResponder];
    // Login.
    if ((self.nameTF.text == nil || [self.nameTF.text isEqualToString:@""] ||
        self.pwdTF.text == nil || [self.pwdTF.text isEqualToString:@""]))
    {
        if (sender != nil) [[JTToast toastWithText:@"用户名和密码不能为空" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }else{
        if (OFFLINE)
        {
            [self testData];
        }else{
//            if (sender == nil) return;
            if (HUD == nil)
            {
                HUD = [[MBProgressHUD alloc]init];
            }
            [self.view addSubview:HUD];
            HUD.dimBackground =YES;
            HUD.labelText = @"登录中...";
            [HUD removeFromSuperViewOnHide];
            [HUD showByCustomView:YES];
            [self login];
        }
    }
}

-(void)login
{
    NSString *ipStr = [self getIPAddress];
    NSString *macStr =[NSString stringWithFormat:@"%@", [self getMacAddress]];
    //设置登录参数
    NSDictionary *dict = @{@"username":self.nameTF.text,
                           @"password":self.pwdTF.text,
                           @"channelId": ipStr,
                           @"mac": macStr};
    //设置请求
    [RequestModal requestServer:HTTP_METHED_POST Url:SERVER_URL_WITH(PATH_LOGIN) parameter:dict header:nil content:nil success:^(id responseData) {
        NSDictionary *result = responseData;
        int state = [(NSNumber*)[result objectForKey:@"state"] intValue];
        // Pwd right.
        if (state == State_Success)
        {
            NSDictionary* userData = (NSDictionary*)[result objectForKey:@"data"];
            if (userData == nil) return;
            [[JTToast toastWithText:@"登录成功" configuration:[JTToastConfiguration defaultConfiguration]]show];
            // Save data.
            [SystemConfig instance].currentUserRole = [(NSNumber*)[result objectForKey:@"role"] intValue];
            [SystemConfig instance].currentUserName = self.nameTF.text;
            [SystemConfig instance].currentUserPwd = self.pwdTF.text;
            [SystemConfig instance].currentUserId = [userData objectForKey:@"user_id"];
            [SystemConfig instance].currentUserToken = [result objectForKey:@"token"];
            [RequestModal setUserId:[userData objectForKey:@"user_id"]];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:[SystemConfig instance].currentUserRole] forKey:@"currentUserRole"];
            [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserId forKey:@"currentUserId"];
            [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserName forKey:@"currentUserName"];
            [[NSUserDefaults standardUserDefaults] setObject:[SystemConfig instance].currentUserPwd forKey:@"currentUserPwd"];
            self.nameTF.text = @"";
            self.pwdTF.text = @"";
            [self performSegueWithIdentifier:@"LoginToHome" sender:self];
        // Pwd wrong.
        }else{
            [[JTToast toastWithText:(NSString*)[result objectForKey:@"msg"] configuration:[JTToastConfiguration defaultConfiguration]]show];
            self.pwdTF.text = @"";
        }
        [HUD hideByCustomView:YES];
    } failed:^(id responseData) {
        [HUD hideByCustomView:YES];
        [[JTToast toastWithText:@"网络错误，请重新尝试。" configuration:[JTToastConfiguration defaultConfiguration]]show];
    }];
}

// TextFieldDelegate.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (textField == self.nameTF && newLength <= 20) || (textField == self.pwdTF && newLength <= 20);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTF && textField.text.length >= 5)
    {
        [self.nameTF resignFirstResponder];
        [self.pwdTF becomeFirstResponder];
    }else if(textField == self.pwdTF && textField.text.length >= 8){
        [self.pwdTF resignFirstResponder];
    }
    return NO;
}

// Keyboard visiable.
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.mainScrollView.contentInset = contentInsets;
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
    CGRect activeFrame = self.nameTF.isFirstResponder ? self.nameTF.frame : self.pwdTF.frame;
    [self.mainScrollView scrollRectToVisible:activeFrame animated: YES];
//    CGSize kbSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.mainScrollView.contentInset = contentInsets;
//    self.mainScrollView.scrollIndicatorInsets = contentInsets;
//    CGRect aRect = self.mainScrollView.frame;
//    aRect.size.height -= kbSize.height;
//    [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.origin.x, self.nameTF.frame.origin.y - kbSize.height) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.mainScrollView.contentInset = contentInsets;
    self.mainScrollView.scrollIndicatorInsets = contentInsets;
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

- (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                  macAddress[0], macAddress[1], macAddress[2],
                                  macAddress[3], macAddress[4], macAddress[5]];
    NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

@end
