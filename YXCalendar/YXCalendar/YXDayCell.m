//
//  YXDayCell.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXDayCell.h"
#import "Masonry.h"

@interface YXDayCell ()

@property (strong, nonatomic) UIView* leftView;
@property (strong, nonatomic) UIView* rightView;
@property (strong, nonatomic) UILabel *dayL;     //日期

@end

@implementation YXDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    self.leftView = [[UIView alloc]init];
    self.leftView.backgroundColor = [UIColor colorWithRed:218.f/255.f green:232.f/255.f blue:253.f/255.f alpha:1.f];
    [self.contentView addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(@0);
        make.height.equalTo(@25);
    }];
    
    self.rightView = [[UIView alloc]init];
    self.rightView.backgroundColor = [UIColor colorWithRed:218.f/255.f green:232.f/255.f blue:253.f/255.f alpha:1.f];
    [self.contentView addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(@0);
        make.height.equalTo(@25);
    }];
    
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    
    self.dayL = [[UILabel alloc]init];
    self.dayL.font = [UIFont systemFontOfSize:16];
    self.dayL.textColor = UIColor.blackColor;
    self.dayL.backgroundColor = UIColor.clearColor;
    self.dayL.textAlignment = NSTextAlignmentCenter;
    self.dayL.adjustsFontSizeToFitWidth = YES;
    self.dayL.layer.masksToBounds = YES;
    self.dayL.layer.cornerRadius = 12.5f;
    [self.contentView addSubview:self.dayL];
    [self.dayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.height.equalTo(@25);
    }];
}

- (void)setDayModel:(MLDayModel *)dayModel {
    
    _dayModel = dayModel;
    
    self.dayL.text = dayModel.dayText;
    
    self.dayL.backgroundColor = UIColor.clearColor;
    self.dayL.textColor = UIColor.blackColor;
    self.leftView.hidden = YES;
    self.rightView.hidden = YES;
    
    if (dayModel.isToday) {
        
        self.dayL.textColor = UIColor.blueColor;
    }
    
    if (!dayModel.isCanClick) {
        
        self.dayL.textColor = UIColor.grayColor;
    }else {
        
        self.leftView.hidden = !dayModel.isShowLeft;
        self.rightView.hidden = !dayModel.isShowRight;
        
        if (dayModel.isStartOrEndDate) {
            
            self.dayL.backgroundColor = UIColor.blueColor;
            self.dayL.textColor = UIColor.whiteColor;
        }
    }
}

@end
