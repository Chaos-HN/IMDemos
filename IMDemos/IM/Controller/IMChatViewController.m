//
//  IMChatViewController.m
//  IMDemos
//
//  Created by oumeng on 2019/3/7.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "IMChatViewController.h"
#import "IMSocketUtils.h"
#import "IMChatModel.h"
#import "IMChatLogCell.h"
#import "LoginViewController.h"
#import "BDIPAlertView.h"

@interface IMChatViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,BDIPAlertViewDelegate>
{
    UITextField *msgTF;
    UIButton *selectBtn;
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *datasArr;

@end

@implementation IMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"IM测试";
    self.view.backgroundColor = [UIColor whiteColor];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(recLog:) name:@"logCenter" object:nil];
    //监听对方发送来的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(communicate:) name:@"rceMsg" object:nil];
    self.datasArr = [NSMutableArray array];
    [self setUpViews];
    [[IMSocketUtils sharedManager] getIMServer];
}

- (void)setUpViews
{
    msgTF = [[UITextField alloc] init];
    msgTF.placeholder = @"请输入发送内容";
    msgTF.text = @"IM测试消息发送";
    msgTF.layer.borderColor = [UIColor orangeColor].CGColor;
    msgTF.layer.borderWidth = 1;
    msgTF.textColor = [UIColor blueColor];
    msgTF.clearButtonMode = UITextFieldViewModeUnlessEditing;
    msgTF.delegate = self;
    [self.view addSubview:msgTF];
    [msgTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(ECTopHeight+20);
    }];
    
    selectBtn = [[UIButton alloc] init];
    [selectBtn setTitle:@"选择接收人" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    selectBtn.layer.borderWidth = 1;
    [self.view addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.left.equalTo(self->msgTF.mas_right).offset(10);
        make.top.equalTo(self->msgTF);
    }];
    
    UIButton *clearBtn = [[UIButton alloc] init];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    clearBtn.layer.borderWidth = 1;
    [self.view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.left.equalTo(self->msgTF);
        make.top.equalTo(self->msgTF.mas_bottom).offset(10);
    }];
    
    UIButton *sendBtn = [[UIButton alloc] init];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    sendBtn.layer.borderWidth = 1;
    [self.view addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.left.equalTo(clearBtn.mas_right).offset(15);
        make.centerY.equalTo(clearBtn);
    }];
    
    UIButton *outBtn = [[UIButton alloc] init];
    [outBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [outBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [outBtn addTarget:self action:@selector(outClick) forControlEvents:UIControlEventTouchUpInside];
    outBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    outBtn.layer.borderWidth = 1;
    [self.view addSubview:outBtn];
    [outBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.equalTo(sendBtn.mas_right).offset(15);
        make.centerY.equalTo(clearBtn);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setTitle:@"返回登录" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    backBtn.layer.borderWidth = 1;
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.left.equalTo(outBtn.mas_right).offset(15);
        make.centerY.equalTo(clearBtn);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->msgTF);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(sendBtn.mas_bottom).offset(15);
        make.bottom.equalTo(self.view).offset(-ECBottomHeight-55);
    }];
    
    UIView *footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    footView.layer.borderColor = [UIColor orangeColor].CGColor;
    footView.layer.borderWidth = 1;
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom).offset(5);
        make.bottom.equalTo(self.view).offset(-ECBottomHeight);
    }];
    
    UIButton *offBtn = [[UIButton alloc] init];
    [offBtn setTitle:@"断开" forState:UIControlStateNormal];
    [offBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [offBtn addTarget:self action:@selector(offClick) forControlEvents:UIControlEventTouchUpInside];
    offBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    offBtn.layer.borderWidth = 1;
    [footView addSubview:offBtn];
    [offBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.left.equalTo(footView).offset(15);
        make.top.equalTo(footView).offset(5);
    }];
    
    UIButton *onBtn = [[UIButton alloc] init];
    [onBtn setTitle:@"连接" forState:UIControlStateNormal];
    [onBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [onBtn addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    onBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    onBtn.layer.borderWidth = 1;
    [self.view addSubview:onBtn];
    [onBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.left.equalTo(offBtn.mas_right).offset(15);
        make.centerY.equalTo(offBtn);
    }];
    
}

- (void)recLog:(NSNotification *)noti
{
    NSString *titleStr = noti.object;
    if ([titleStr rangeOfString:@"失败"].location != NSNotFound) {
        [XHToast showTopWithText:[NSString stringWithFormat:@"**%@**",titleStr] duration:1.0];
    } else {
        NSArray *datas = [noti.userInfo getArray:@"datas"];
        NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
        [dicts setObject:noti.object forKey:@"title"];
        [dicts setObject:datas forKey:@"content"];
        [self.datasArr insertObject:dicts atIndex:0];
        [self.tableView reloadData];
    }
}

- (void)sendClick
{
    NSString *str = selectBtn.titleLabel.text;
    if ([StringUtils isNUllOrEmpty:msgTF.text]) {
        [XHToast showTopWithText:@"**发送内容不能为空**" duration:1.0];
    } else if ([str isEqualToString:@"选择接收人"]) {
        [XHToast showTopWithText:@"**请选择接收人**" duration:1.0];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *proId = [defaults objectForKey:@"profileId"];
        NSString *receId = [defaults objectForKey:@"receiverId"];
        if ([proId isEqualToString:receId]) {
            [XHToast showTopWithText:@"不可给自己发送信息" duration:1.0];
        } else {
            IMChatModel *chatModel = [[IMChatModel alloc] init];
            NSString *senderName = [defaults objectForKey:@"userName"];
            chatModel.msg = msgTF.text;
            chatModel.senderName = senderName;
            chatModel.clientMsgId = @"55";
            chatModel.receiverId = [defaults objectForKey:@"receiverId"];
            chatModel.messageContentTypeCd = @"1";
            
            [[IMSocketUtils sharedManager] sendMessages:chatModel andBlock:^(NSDictionary *sendDict) {
                NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
                [dicts setObject:[sendDict getString:@"senderName"] forKey:@"title"];
                [dicts setObject:[sendDict getString:@"msg"] forKey:@"content"];
                [self.datasArr insertObject:dicts atIndex:0];
                [self.tableView reloadData];
            }];
        }
    }
}

- (void)clearClick
{
    msgTF.text = @"";
}

- (void)outClick
{
    [[LoginUtil sharedManager] loginOutBlock:^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"isLogin"];
        [defaults synchronize];
        [[IMSocketUtils sharedManager] cutOffSocket];
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
        [UIApplication sharedApplication].delegate.window.rootViewController = nav;
    }];
}

- (void)backClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"0" forKey:@"isLogin"];
    [defaults removeObjectForKey:@"receiverId"];
    [defaults synchronize];
    [[IMSocketUtils sharedManager] cutOffSocket];
    LoginViewController *loginVc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVc];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (void)offClick
{
    [[IMSocketUtils sharedManager] cutOffSocket];
}

- (void)onClick
{
    [[IMSocketUtils sharedManager] getIMServer];
//    [[IMSocketUtils sharedManager] reconnectToServer];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"IMChatLogCell";
    IMChatLogCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell ==nil) {
        cell = [[IMChatLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *model = self.datasArr[indexPath.row];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMChatLogCell *cell = [[IMChatLogCell alloc] init];
    NSDictionary *model = self.datasArr[indexPath.row];
    [cell setModel:model];
    return cell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [msgTF resignFirstResponder];
    return YES;
}

//监听对方发送来的信息
-(void)communicate:(NSNotification *)notification
{
    NSString *msg = notification.object;
    NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
    [dicts setObject:@"对方发送：" forKey:@"title"];
    [dicts setObject:msg forKey:@"content"];
    [self.datasArr insertObject:dicts atIndex:0];
    [self.tableView reloadData];
}

- (void)selectClick
{
    NSString *urlPlistPath = [[NSBundle mainBundle] pathForResource:@"recever" ofType:@"plist"];
    NSMutableArray *datas = [[NSMutableArray alloc] initWithContentsOfFile:urlPlistPath];
    BDIPAlertView *selectVc = [[BDIPAlertView alloc]initWithTitle:@"接收人" datas:datas];
    selectVc.delegate = self;
    [selectVc show];
}
- (void)singleChoiceBlock:(NSDictionary *)urlDict
{
    [selectBtn setTitle:[urlDict getString:@"rename"] forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[urlDict getString:@"reId"] forKey:@"receiverId"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
