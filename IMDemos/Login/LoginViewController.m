//
//  LoginViewController.m
//  IMDemos
//
//  Created by oumeng on 2019/3/5.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "LoginViewController.h"
#import "IMChatViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    UITextField *nameTF;
    UITextField *pwdTF;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"登录界面";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];
}

- (void)setUpViews
{
    nameTF = [[UITextField alloc] init];
    nameTF.placeholder = @"请输入账号";
    nameTF.text = @"18505605571";
    nameTF.layer.borderColor = [UIColor orangeColor].CGColor;
    nameTF.layer.borderWidth = 1;
    nameTF.textColor = [UIColor blueColor];
    nameTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    nameTF.keyboardType =  UIKeyboardTypeNumbersAndPunctuation;
    nameTF.delegate = self;
    [self.view addSubview:nameTF];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-200, 40));
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-100);
        make.top.equalTo(self.view).offset(200);
    }];
    
    pwdTF = [[UITextField alloc] init];
    pwdTF.placeholder = @"请输入密码";
    pwdTF.text = @"oykm123";
    pwdTF.layer.borderColor = [UIColor orangeColor].CGColor;
    pwdTF.layer.borderWidth = 1;
    pwdTF.textColor = [UIColor blueColor];
    pwdTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    pwdTF.delegate = self;
    [self.view addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-200, 40));
        make.left.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-100);
        make.top.equalTo(self->nameTF.mas_bottom).offset(30);
    }];
    
    
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    clearBtn.layer.borderWidth = 1;
    [self.view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.equalTo(self.view).offset(100);
        make.bottom.equalTo(self.view).offset(-80);
    }];
    
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    loginBtn.layer.borderWidth = 1;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.right.equalTo(self.view).offset(-100);
        make.bottom.equalTo(self.view).offset(-80);
    }];
}

- (void)loginClick
{
    if ([StringUtils isNUllOrEmpty:nameTF.text] || [StringUtils isNUllOrEmpty:pwdTF.text]) {
        [XHToast showTopWithText:@"**请输入账号和密码**" duration:1.0];
    } else {
        NSDictionary *dicts = @{@"name":nameTF.text,@"pwd":pwdTF.text};
        [[LoginUtil sharedManager] loginAgainWithUser:dicts loginBlock:^{
            IMChatViewController *imVc = [[IMChatViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imVc];
            [UIApplication sharedApplication].delegate.window.rootViewController = nav;
        }];
    }
}

- (void)clearClick
{
    nameTF.text = @"";
    pwdTF.text = @"";
}

- (void)setTokenStr:(NSDictionary *)cdict userInfo:(NSDictionary *)udict
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[cdict getString:@"token"] forKey:@"tokenStr"];
    [defaults setObject:[udict getString:@"companyId"] forKey:@"companyIdStr"];
    [defaults setObject:[udict getString:@"realName"] forKey:@"userName"];
    [defaults synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [nameTF resignFirstResponder];
    [pwdTF resignFirstResponder];
    return YES;
}

@end
