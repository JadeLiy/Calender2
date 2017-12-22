//
//  SelectView.h
//  Calendar1
//
//  Created by apple on 17/11/6.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YearOfView = 1<<1,
    MonthOfView = 1<<2,
    DayOfView = 1 <<3,
} SelectViewStyle;

@interface SelectView : UIView

/** 数据 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 选择类型 */
@property (nonatomic, assign) SelectViewStyle style;
/** 选择的日期 */
@property (nonatomic, copy) NSString *dateString;
/** 默认值 */
@property (nonatomic, copy) NSString *defaultStrng;

@property (nonatomic, strong) void(^selectAction)(NSString *dateString);

+ (instancetype)SelectView;
+ (instancetype)SelectViewWithFrame:(CGRect)frame style:(SelectViewStyle)style defaultString:(NSString *)defaultString;

@end
