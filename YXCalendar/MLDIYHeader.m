//
//  MLDIYHeader.m
//  Exchange
//
//  Created by Milodongg on 2021/4/13.
//  Copyright © 2021 alpha. All rights reserved.
//

#import "MLDIYHeader.h"
#import "Masonry.h"

#define itemW (40)

@interface MLDIYHeader()

@property (weak, nonatomic) UIImageView *logoImageView;
@property (nonatomic, strong) UIImage *hudImage;
@end

@implementation MLDIYHeader

- (UIImage *)hudImage{
    if (!_hudImage) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loading"ofType:@"gif"];
        NSData *data =[NSData dataWithContentsOfFile:path];
        _hudImage = [self sd_animatedGIFWithData:data];
    }
    
    return _hudImage;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 60;
    
    UIImageView *logo = [UIImageView new];
//    logo.image = _hudImage;
    [self addSubview:logo];
    self.logoImageView = logo;
    self.logoImageView.image = self.hudImage;
    
    UILabel *titlelLabel = [[UILabel alloc] init];
    titlelLabel.textColor = UIColor.blueColor;
    titlelLabel.font = [UIFont boldSystemFontOfSize:12];
    titlelLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titlelLabel];
    self.titlelLabel = titlelLabel;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];

    
    [self.titlelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.bottom.equalTo(@-10);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(itemW));
        make.bottom.mas_equalTo(self.titlelLabel.mas_top).offset(0);
        make.centerX.equalTo(self.titlelLabel);
    }];
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;

    switch (state) {
        case MJRefreshStateIdle:
            self.titlelLabel.text = @"coolshine";
            break;
        case MJRefreshStatePulling:
            self.titlelLabel.text = @"coolshine";
            break;
        case MJRefreshStateRefreshing:
            self.titlelLabel.text = @"coolshine";
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent{
    [super setPullingPercent:pullingPercent];
    
    if (pullingPercent > 1) {
        pullingPercent = 1;
    }
    
    if (pullingPercent <= 0.3) {
        pullingPercent = 0.3;
    }
    
    self.titlelLabel.font = [UIFont boldSystemFontOfSize:12 * pullingPercent];
    CGFloat logoWH = itemW * pullingPercent;
    
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(logoWH));
        make.bottom.mas_equalTo(self.titlelLabel.mas_top).offset(0);
        make.centerX.equalTo(self.titlelLabel);
    }];
}

- (UIImage *)sd_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:1.2];
    }
    
    CFRelease(source);
    return animatedImage;
}
@end
