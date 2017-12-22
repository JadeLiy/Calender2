//
//  ViewController.m
//  Calendar1
//
//  Created by apple on 17/11/6.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"日期选择器";
    
    CalendarView *calendar = [CalendarView CalendarView];
    calendar.frame = CGRectMake(20, 150, self.view.frame.size.width - 40, self.view.frame.size.height - 300);
    [self.view addSubview: calendar];
    
}

@end
