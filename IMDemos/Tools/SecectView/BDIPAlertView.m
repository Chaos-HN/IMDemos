//
//  BDIPAlertView.m
//  IMDemos
//
//  Created by oumeng on 2019/3/18.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "BDIPAlertView.h"
#import "BDIPAlertCell.h"

@interface BDIPAlertView ()
{
    // 弹框整体高度，默认240
    float alertViewHeight;
    // 按钮高度，默认40
    float buttonHeight;
}
// 数据源
@property (nonatomic, strong) NSArray *datas;
// 标题label
@property (nonatomic, strong) UILabel *titleLabel;
// 弹框视图
@property (nonatomic, strong) UIView *alertView;
// 选择列表
@property (nonatomic, strong) UITableView *selectTableView;
// 确定按钮
@property (nonatomic, strong) UIButton *confirmButton;
// 取消按钮
@property (nonatomic, strong) UIButton *cancelButton;
// 存储的地址数据
@property (nonatomic, strong) NSMutableDictionary *urlDict;

@end

@implementation BDIPAlertView

-(instancetype)initWithTitle:(NSString *)title datas:(NSArray *)datas{
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.urlDict = [NSMutableDictionary dictionary];
        alertViewHeight = 240;
        buttonHeight = 40;
        
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(50, (kScreenHeight-alertViewHeight)/2.0, kScreenWidth-100, alertViewHeight)];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 8;
        self.alertView.layer.masksToBounds = YES;
        [self addSubview:self.alertView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.alertView.frame.size.width, buttonHeight)];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor orangeColor];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:self.titleLabel];
        
        self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth-100, self.alertView.bounds.size.height-buttonHeight*2) style:UITableViewStylePlain];
        self.selectTableView.delegate = self;
        self.selectTableView.dataSource = self;
        self.selectTableView.estimatedSectionHeaderHeight =0;
        self.selectTableView.estimatedSectionFooterHeight =0;
        self.selectTableView.sectionHeaderHeight = 0;
        self.selectTableView.sectionFooterHeight = 0;
        self.datas = datas;
        [self.alertView addSubview:self.selectTableView];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.frame = CGRectMake(0,CGRectGetMaxY(self.selectTableView.frame), self.alertView.frame.size.width/2, buttonHeight);
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font =[UIFont systemFontOfSize:16];
        [self.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.confirmButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelButton.frame = CGRectMake(CGRectGetMaxX(self.confirmButton.frame),CGRectGetMaxY(self.selectTableView.frame), self.alertView.frame.size.width/2, buttonHeight);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.cancelButton];
        
    }
    return self;
}

-(void)show{
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.alertView.alpha = 1;
    }];
}

#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.datas[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDIPAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BDIPAlertCell"];
    if (!cell) {
        cell = [[BDIPAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BDIPAlertCell"];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *urlName = [defaults objectForKey:@"rename"];
    NSDictionary *model = self.datas[indexPath.section][indexPath.row];
    if ([urlName isEqualToString:[model getString:@"name"]]) {
        cell.selectIV.image = [UIImage imageNamed:@"ic_xz"];
        [self.urlDict setObject:[model getString:@"name"] forKey:@"rename"];
        [self.urlDict setObject:[model getString:@"receiverId"] forKey:@"reId"];
    } else {
        cell.selectIV.image = [UIImage imageNamed:@"ic_wxz"];
    }
    cell.titleLabel.text = [model getString:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *model = self.datas[indexPath.section][indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.urlDict setObject:[model getString:@"name"] forKey:@"rename"];
    [self.urlDict setObject:[model getString:@"receiverId"] forKey:@"reId"];
    [defaults setObject:[model getString:@"name"] forKey:@"rename"];
    [defaults synchronize];
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//点击空白处
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.alertView frame], pt)) {
        [self cancelAction];
    }
}

//点击确定
- (void)confirmAction{
    if (_delegate && [_delegate respondsToSelector:@selector(singleChoiceBlock:)])
    {
        [_delegate singleChoiceBlock:self.urlDict];
    }
    [self cancelAction];
}

//点击取消
- (void)cancelAction {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
