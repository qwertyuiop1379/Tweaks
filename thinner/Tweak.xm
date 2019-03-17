@interface SBUILegibilityLabel : UIView
@property (nonatomic, retain) UIFont *font;
@end

@interface SBFLockScreenDateView : UIView
-(SBUILegibilityLabel *)_timeLabel;
@end

%hook SBFLockScreenDateView
-(void)layoutSubviews
{
	%orig;

	SBUILegibilityLabel *timeLabel = [self _timeLabel];
	timeLabel.font = [UIFont systemFontOfSize:timeLabel.font.pointSize weight:UIFontWeightUltraLight];
}
%end

%hook SBFLockScreenDateSubtitleView
-(void)layoutSubviews
{
	%orig;

	SBUILegibilityLabel *timeLabel = MSHookIvar<SBUILegibilityLabel *>(self, "_label");
	timeLabel.font = [UIFont systemFontOfSize:timeLabel.font.pointSize weight:UIFontWeightUltraLight];
}
%end