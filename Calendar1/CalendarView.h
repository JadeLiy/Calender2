//
//  CalanderView.h
//  Calendar1
//
//  Created by apple on 17/11/6.
//  Copyright © 2017年 Jade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@property (weak, nonatomic) IBOutlet UIView *yearView;
@property (weak, nonatomic) IBOutlet UIView *monthView;
@property (weak, nonatomic) IBOutlet UIView *dayView;

+ (instancetype)CalendarView;

@end
