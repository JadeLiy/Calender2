//
//  SelectView.m
//  Calendar1
//
//  Created by apple on 17/11/6.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import "SelectView.h"

@interface SelectView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *subtractBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, copy) NSString *pickString;

@end


@implementation SelectView

+ (instancetype)SelectView {
    SelectView *selectView = [[NSBundle mainBundle] loadNibNamed:@"SelectView" owner:nil options:nil].lastObject;

    // 添加点击方法
    [selectView.subtractBtn addTarget:selectView action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    
    [selectView.addBtn addTarget:selectView action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    return selectView;
}

+ (instancetype)SelectViewWithFrame:(CGRect)frame style:(SelectViewStyle)style defaultString:(NSString *)defaultString {
    SelectView *selectView = [[NSBundle mainBundle] loadNibNamed:@"SelectView" owner:nil options:nil].lastObject;
    
    selectView.frame = frame;
    selectView.defaultStrng = defaultString;
    selectView.style = style;
    
    // 添加点击方法
    [selectView.subtractBtn addTarget:selectView action:@selector(subtractAction) forControlEvents:UIControlEventTouchUpInside];
    
    [selectView.addBtn addTarget:selectView action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    return selectView;
}

#pragma mark - 点击方法
- (void)subtractAction {
    if ([self.pickView selectedRowInComponent:0]+1 ==1) {
        return;
    }
    [self.pickView selectRow:[self.pickView selectedRowInComponent:0]-1 inComponent:0 animated:YES];
    [self pickerView:self.pickView didSelectRow:[self.pickView selectedRowInComponent:0] inComponent:0];
}
- (void)addAction {
    
    if ([self.pickView selectedRowInComponent:0]+1 == self.dataSource.count) {
        return;
    }
    [self.pickView selectRow:[self.pickView selectedRowInComponent:0]+1 inComponent:0 animated:YES];
    [self pickerView:self.pickView didSelectRow:[self.pickView selectedRowInComponent:0] inComponent:0];
    
}

#pragma mark - pickView datasorce
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (self.style == DayOfView) {
        return [self getNumberOfDaysInMonthWithDate:[self strToDateWithString:self.dateString]];

    }
    return self.dataSource.count;
}

//  该方法返回的NSString值将作为该UIPickerView控件中指定列的列表项的文本标题。
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.dataSource.count) {
        return self.dataSource[row];
    }
    return @"";
}

//点击选中的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.pickString = self.dataSource[row];
    if (self.selectAction!=nil) {
        self.selectAction(self.dataSource[row]);
    }
    
    self.selectRow = row;
    [pickerView reloadComponent:0];
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor orangeColor];
        }
    }
    
    UILabel *pickLabel = (UILabel *)view;
    if (!pickLabel) {
        pickLabel = [[UILabel alloc] init];
        [pickLabel setBackgroundColor:[UIColor clearColor]];
        [pickLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    
    if (row == self.selectRow) {
        pickLabel.textColor = [UIColor redColor];
    }
    
    pickLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickLabel.textAlignment = NSTextAlignmentCenter;
    return pickLabel;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    return 44;
}

- (NSInteger)getNumberOfDaysInMonthWithDate:(NSDate *)date
{
    if (!date) {
        return 0;
    }
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法
//    NSDate * currentDate = [NSDate date];
    // 只要个时间给日历,就会帮你计算出来。这里的时间取当前的时间。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate:date];
    return range.length;
}

// 日期和字符串之间的转换
- (NSDate *)strToDateWithString:(NSString *)dateStr
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"]; // 年-月-日 时:分:秒
    // 这个格式可以随便定义,比如：@"yyyy,MM,dd,HH,mm,ss"
    
    NSDate * date = [formatter dateFromString:dateStr];
    return date;
}

- (NSString *)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:dateNow];
    NSLog(@"time = %@",currentTimeString);
    return currentTimeString;
}

//
- (void)setDateString:(NSString *)dateString {
    _dateString = dateString;
    // 刷新
    [self.pickView reloadAllComponents];
    [self pickerView:self.pickView didSelectRow:[self.pickView selectedRowInComponent:0] inComponent:0];
}

- (void)setDefaultStrng:(NSString *)defaultStrng {
    _defaultStrng = defaultStrng;
    
    for (NSString *str in self.dataSource) {
        if ([str containsString:defaultStrng]) {
            [self.pickView selectRow:[self.dataSource indexOfObject:str] inComponent:0 animated:YES];
            [self pickerView:self.pickView didSelectRow:[self.dataSource indexOfObject:str] inComponent:0];
        }
    }
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        switch (self.style) {
            case YearOfView:{
                
                NSString *year = [[self getCurrentTimes] componentsSeparatedByString:@"-"].firstObject;
                
                for (int i = 1900; i<=year.intValue; i++) {
                    NSString *str = [NSString stringWithFormat:@"%d%@",i,@"年"];
                    [_dataSource addObject:str];
                }
            }
                break;
            case MonthOfView:{
                for (int i = 1; i<13; i++) {
                    NSString *str = [NSString stringWithFormat:@"%d%@",i,@"月"];
                    [_dataSource addObject:str];
                }
            }
                break;
            case DayOfView:{
                for (int i = 1; i<32; i++) {
                    NSString *str = [NSString stringWithFormat:@"%d%@",i,@"日"];
                    [_dataSource addObject:str];
                }
            }
                break;
                
            default:
                break;
        }
  
    }
    return _dataSource;
}


@end
