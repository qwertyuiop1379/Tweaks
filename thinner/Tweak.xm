#include "Tweak.h"

NSDictionary *preferences;

CGFloat weightForInt(int i)
{
	// i seriously could not find a better way to do this ...
	switch (i)
	{
		case 0:
			return UIFontWeightUltraLight;
		case 1:
			return UIFontWeightThin;
		case 2:
			return UIFontWeightLight;
		case 3:
			return UIFontWeightRegular;
		case 4:
			return UIFontWeightMedium;
		case 5:
			return UIFontWeightSemibold;
		case 6:
			return UIFontWeightBold;
		case 7:
			return UIFontWeightHeavy;
		case 8:
			return UIFontWeightBlack;
		default:
			return UIFontWeightUltraLight;
	}
}

@implementation NSDictionary (tweak)
-(int)intForKey:(NSString *)key
{
	return [[self objectForKey:key] intValue];
}
@end

%hook SBFLockScreenDateView
-(void)layoutSubviews
{
	%orig;

	SBUILegibilityLabel *timeLabel = [self _timeLabel];
	if (timeLabel)
	{
		timeLabel.font = [UIFont systemFontOfSize:timeLabel.font.pointSize weight:weightForInt([preferences intForKey:@"timeWeight"])];
		timeLabel.frame = CGRectMake(0, 0, self.frame.size.width, timeLabel.frame.size.height);
		timeLabel.textAlignment = [preferences intForKey:@"timeAlignment"];
	}
}
%end

%hook SBFLockScreenDateSubtitleView
-(void)layoutSubviews
{
	%orig;

	SBUILegibilityLabel *dateLabel = [self safeValueForKey:@"_label"];
	if (dateLabel)
	{
		dateLabel.font = [UIFont systemFontOfSize:dateLabel.font.pointSize weight:weightForInt([preferences intForKey:@"dateWeight"])];
		self.frame = CGRectMake(0, self.frame.origin.y, self.superview.frame.size.width, self.frame.size.height);
		dateLabel.frame = self.bounds;
		dateLabel.textAlignment = [preferences intForKey:@"dateAlignment"];
	}
}
%end

%hook WATodayPadView
-(void)layoutSubviews
{
	%orig;

	if ([NSStringFromClass(self.superview.class) isEqual:@"SBFLockScreenDateView"])
	{
		// just using the same settings as time font
		UILabel *lookasideLabel = [self.temperatureLabel safeValueForKey:@"_lookasideLabel"];
		lookasideLabel.font = [UIFont systemFontOfSize:lookasideLabel.font.pointSize weight:weightForInt([preferences intForKey:@"timeWeight"])];
	}
}
%end

static void reloadPreferences()
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.thinnerprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        preferences = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.thinnerprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!preferences) preferences = [NSDictionary new];
        CFRelease(keyList);
    }
    if (!preferences) preferences = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.thinnerprefs.plist"];
}

%ctor
{
    reloadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, CFSTR("com.qiop1379.thinnerprefs/preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}