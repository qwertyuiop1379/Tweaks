#include <CSColorPicker/CSColorPicker.h>

@interface SBRootFolderDockIconListView : UIView
@end

%hook SBRootFolderDockIconListView
-(void)layoutSubviews
{
    %orig;
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.dockoutlineprefs.plist"];
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 32;
    self.layer.masksToBounds = YES;
    if ([prefs objectForKey:@"outlineColor"] != nil)
    {
        self.layer.borderColor = [UIColor colorFromHexString:[prefs objectForKey:@"outlineColor"]].CGColor;
    }
}
%end
%hook SBDockView
-(void)setBackgroundAlpha:(double)arg1
{
    %orig(0.0f);
}
%end