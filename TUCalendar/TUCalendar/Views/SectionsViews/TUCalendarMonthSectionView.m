//
//  TUCalendarMonthSectionView.m
//  tutu
//
//  Created by Иван Смолин on 21/10/15.
//  Copyright © 2015 Touch Instinct. All rights reserved.
//

#import <UIColor_Hex/UIColor+Hex.h>
#import "TUCalendarMonthSectionView.h"
#import "TUDateFormatter.h"

static NSUInteger const kNumberOfDaysInWeek = 7;
static CGFloat const kMonthLabelTopToSuperviewSpace = 8.f;
static CGFloat const kMonthLabelHeight = 18.f;
static CGFloat const kDaysToMonthVerticalSpace = 10.f;
static CGFloat const kDaysLabelsLeftRightInset = 6.f;
static CGFloat const kDayLabelHeight = 14.f;


@implementation TUCalendarMonthSectionViewAppearance

- (instancetype)init {
    self = [super init];

    if (self) {
        self.titleFont = [UIFont systemFontOfSize:15.f];
        self.titleColor = [UIColor colorWithHex:0x0099FF];

        self.dayFont = [UIFont systemFontOfSize:11.f];

        UIColor *weekdayColor = [UIColor colorWithHex:0x7B95AA];
        UIColor *weekendColor = [UIColor colorWithHex:0xC33D1A];
        
        self.weekdaysColors = @[weekdayColor,
                weekdayColor,
                weekdayColor,
                weekdayColor,
                weekdayColor,
                weekendColor,
                weekendColor,
        ];
        
        self.dividerColor = [UIColor colorWithHex:0x7B95AA];
        self.backgroundColor = [UIColor whiteColor];
        self.showYear = NO;
    }

    return self;
}


@end

@interface TUCalendarMonthSectionView ()

@property (strong, nonatomic) UILabel *sectionTitleLabel;
@property (strong, nonatomic) NSArray<UILabel *> *daysLabels;
@property (strong, nonatomic) UIView *divider;

@end

@implementation TUCalendarMonthSectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    UILabel *sectionTitleLabel = [UILabel new];
    sectionTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:sectionTitleLabel];
    self.sectionTitleLabel = sectionTitleLabel;

    NSMutableArray<UILabel *> *daysLabels = [NSMutableArray arrayWithCapacity:kNumberOfDaysInWeek];
    
    for (NSUInteger i = 0; i < kNumberOfDaysInWeek; i++) {
        UILabel *dayLabel = [UILabel new];
        dayLabel.alpha = 0.5f;
        dayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dayLabel];
        [daysLabels addObject:dayLabel];
    }
    
    self.daysLabels = [daysLabels copy];
    
    UIView *divider = [UIView new];
    divider.alpha = 0.25;
    [self addSubview:divider];
    self.divider = divider;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.sectionTitleLabel.frame = CGRectMake(0.f, kMonthLabelTopToSuperviewSpace, width, kMonthLabelHeight);
    
    CGFloat dividerHeight = 0.5f;
    self.divider.frame = CGRectMake(0.f, height - dividerHeight, width, dividerHeight);
    
    CGFloat daysY = CGRectGetMaxY(self.sectionTitleLabel.frame) + kDaysToMonthVerticalSpace;
    CGFloat dayViewWidth = (width - 2 * kDaysLabelsLeftRightInset) / kNumberOfDaysInWeek;
    [self.daysLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull dayLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        dayLabel.frame = CGRectMake(kDaysLabelsLeftRightInset + dayViewWidth * idx, daysY, dayViewWidth, kDayLabelHeight);
    }];
}

- (void)setDateWithMonthIndex:(NSUInteger)monthIndex andYear:(NSUInteger)year; {
    NSString *monthName = self.calendar.standaloneMonthSymbols[monthIndex];

    NSString *sectionTitle = monthName;

    if (_monthSectionAppearance.showYear) {
        [sectionTitle stringByAppendingString:[NSString stringWithFormat:@" %lu", (unsigned long)year]];
    }

    self.sectionTitleLabel.text = [sectionTitle capitalizedString];
}

- (void)setMonthSectionAppearance:(TUCalendarMonthSectionViewAppearance *)monthSectionAppearance {
    _monthSectionAppearance = monthSectionAppearance;

    self.sectionTitleLabel.font = self.monthSectionAppearance.titleFont;
    self.sectionTitleLabel.textColor = self.monthSectionAppearance.titleColor;

    for (NSUInteger i = 0; i < kNumberOfDaysInWeek; ++i) {
        UILabel *dayLabel = self.daysLabels[i];

        dayLabel.font = self.monthSectionAppearance.dayFont;
        dayLabel.text = self.monthSectionAppearance.weekdaysNames[i];
        dayLabel.textColor = self.monthSectionAppearance.weekdaysColors[i];
    }

    self.divider.backgroundColor = self.monthSectionAppearance.dividerColor;

    self.backgroundColor = self.monthSectionAppearance.backgroundColor;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if (!self.monthSectionAppearance) {
        self.monthSectionAppearance = [TUCalendarMonthSectionViewAppearance new];
    }

    if (!self.monthSectionAppearance.weekdaysNames) {
        NSMutableArray<NSString *> *weekdays = [NSMutableArray arrayWithCapacity:kNumberOfDaysInWeek];

        for (NSUInteger i = 0; i < kNumberOfDaysInWeek; ++i) {
            weekdays[i] = [[TUDateFormatter veryShortWeekdaySymbolForDayOfWeek:i inCalendar:self.calendar] uppercaseString];
        }

        self.monthSectionAppearance.weekdaysNames = [weekdays copy];
    }
}

@end
