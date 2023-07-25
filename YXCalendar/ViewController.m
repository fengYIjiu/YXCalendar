//
//  ViewController.m
//  YXCalendar
//
//  Created by Mac on 2023/7/25.
//

#import "ViewController.h"
#import "YXCalendarView.h"

@interface ViewController ()

@property (nonatomic, strong) YXCalendarView *calendar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.calendar];
}

/**
 *  日历的懒加载
 */
- (YXCalendarView *)calendar{
    
    if(!_calendar){
        _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-SafeAreaBottomHeight) Date:[NSDate date]];
        KWeakSelf
        _calendar.sendSelectDate = ^(NSDate *startDay, NSDate *endDay) {
            
            if (startDay || endDay) {
                
            }else {
                
            }
        };
    }
    return _calendar;
}


@end
