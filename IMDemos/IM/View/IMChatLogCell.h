//
//  IMChatLogCell.h
//  IMDemos
//
//  Created by oumeng on 2019/3/18.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMChatLogCell : UITableViewCell
@property (nonatomic ,strong) UILabel *titleLbl;
@property (nonatomic ,strong) UILabel *contentLbl;

@property (nonatomic ,assign) CGFloat cellHeight;

- (CGFloat)setModel:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
