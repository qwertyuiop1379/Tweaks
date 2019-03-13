#include <CSColorPicker/CSColorPicker.h>

NSDictionary *prefs;
long long style;

%hook UIStatusBarStyleRequest
-(long long)style
{
    style = %orig;
    return style;
}
-(UIColor *)foregroundColor
{
    if (style == 0)
    {
        if ([prefs objectForKey:@"darkContentColor"] != nil)
            return [UIColor colorFromHexString:[prefs objectForKey:@"darkContentColor"]];
    }
    else
    {
        if ([prefs objectForKey:@"lightContentColor"] != nil)
            return [UIColor colorFromHexString:[prefs objectForKey:@"lightContentColor"]];
    }
    return %orig;
}
%end

%hook _UIStatusBar
-(UIColor *)foregroundColor
{
    if (style == 0)
    {
        if ([prefs objectForKey:@"darkContentColor"] != nil)
            return [UIColor colorFromHexString:[prefs objectForKey:@"darkContentColor"]];
    }
    else
    {
        if ([prefs objectForKey:@"lightContentColor"] != nil)
            return [UIColor colorFromHexString:[prefs objectForKey:@"lightContentColor"]];
    }
    return %orig;
}
%end

static void loadPrefs()
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.statuscolorprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        prefs = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.statuscolorprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!prefs) prefs = [NSDictionary new];
        CFRelease(keyList);
    }
    if (!prefs) prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.statuscolorprefs.plist"];
}

%ctor
{
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.qiop1379.statuscolorprefs/prefchanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
