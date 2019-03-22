@interface NSObject (internal)
-(id)safeValueForKey:(id)arg1;
@end

@interface SBUILegibilityLabel : UIView
@property (nonatomic, retain) UIFont *font;
@property (assign, nonatomic) long long textAlignment;
@end

@interface WALegibilityLabel : SBUILegibilityLabel
@end

@interface SBFLockScreenDateView : UIView
-(SBUILegibilityLabel *)_timeLabel;
@end

@interface SBFLockScreenDateSubtitleView : UIView
@end

@interface WATodayPadView : UIView
@property (nonatomic, retain) WALegibilityLabel *temperatureLabel;
@end

@interface NSDictionary (tweak)
-(int)intForKey:(NSString *)key;
@end