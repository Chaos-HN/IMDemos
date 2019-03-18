//
//  BDIPAlertView.h
//  IMDemos
//
//  Created by oumeng on 2019/3/18.
//  Copyright © 2019 OYKM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BDIPAlertViewDelegate;
// 代理协议
@protocol BDIPAlertViewDelegate <NSObject>

- (void)singleChoiceBlock:(NSDictionary *)urlDict;

@end

@interface BDIPAlertView : UIView<UITableViewDelegate,UITableViewDataSource>
// 代理
@property (nonatomic,assign) id<BDIPAlertViewDelegate>delegate;
// 初始化
-(instancetype)initWithTitle:(NSString *)title datas:(NSArray *)datas;
// 展示
-(void)show;

@end

NS_ASSUME_NONNULL_END
