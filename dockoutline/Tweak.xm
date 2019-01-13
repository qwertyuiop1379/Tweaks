#include <CSColorPicker/CSColorPicker.h>

@interface _UIBackdropView : UIView
@end

@interface SBRootFolderDockIconListView : UIView
@end

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic, retain) _UIBackdropView *backgroundView;
@end

@interface SBFloatingDockView : UIView
@end 

NSDictionary *prefs;

%hook SBRootFolderDockIconListView
-(void)layoutSubviews
{
    %orig;
    self.layer.cornerRadius = 32;
    self.layer.masksToBounds = YES;
    if ([prefs objectForKey:@"outlineWidth"])
        self.layer.borderWidth = [[prefs objectForKey:@"outlineWidth"] floatValue];
    else
        self.layer.borderWidth = 2;
    if ([prefs objectForKey:@"outlineColor"])
        self.layer.borderColor = [UIColor colorFromHexString:[prefs objectForKey:@"outlineColor"]].CGColor;
    else
        self.layer.borderColor = [UIColor whiteColor].CGColor;
}
%end

%hook SBFloatingDockPlatterView
-(void)layoutSubviews
{
    %orig;
    self.layer.cornerRadius = 32;
    self.layer.masksToBounds = YES;
    if ([prefs objectForKey:@"outlineWidth"])
        self.layer.borderWidth = [[prefs objectForKey:@"outlineWidth"] floatValue];
    else
        self.layer.borderWidth = 2;
    if ([prefs objectForKey:@"outlineColor"])
        self.layer.borderColor = [UIColor colorFromHexString:[prefs objectForKey:@"outlineColor"]].CGColor;
    else
        self.layer.borderColor = [UIColor whiteColor].CGColor;
}
%end

%hook SBDockView
-(void)setBackgroundAlpha:(double)arg1
{
    %orig(0.0f);
}
%end

%ctor
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.dockoutlineprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        prefs = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.dockoutlineprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!prefs) prefs = [NSDictionary new];
        CFRelease(keyList);
    }
    if (!prefs) prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.dockoutlineprefs.plist"];
}