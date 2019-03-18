//
//  IMChatLogCell.m
//  IMDemos
//
//  Created by oumeng on 2019/3/18.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import "IMChatLogCell.h"

@implementation IMChatLogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.cellHeight = self.height = 50;
        //初始化subViews
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews
{
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.backgroundColor = [UIColor whiteColor];
    self.titleLbl.textColor = [UIColor blueColor];
    self.titleLbl.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@100);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    self.contentLbl = [[UILabel alloc] init];
    self.contentLbl.backgroundColor = [UIColor whiteColor];
    self.contentLbl.textColor = [UIColor blackColor];
    self.contentLbl.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 150, 40));
        make.left.equalTo(self.titleLbl.mas_right).offset(15);
        make.top.equalTo(self.titleLbl);
    }];
}

- (CGFloat)setModel:(NSDictionary *)model
{
    self.titleLbl.text = [model getString:@"title"];
    self.contentLbl.text = [model getString:@"content"];
    CGFloat height = [StringUtils adaptionHeightWithLabel:self.contentLbl AndWidth:kScreenWidth - 150];
    if (height<=40) {
        height = 40;
    }
    [self.contentLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 150, height+1));
        make.left.equalTo(self.titleLbl.mas_right).offset(15);
        make.centerY.equalTo(self.contentView);
    }];
    return self.height = self.cellHeight = height + 10;
}
@end
