@interface PHHandsetDialerNumberPadButton : UIView
@end
@interface SBPasscodeNumberPadButton : UIView
@end

UIView *phoneView;
UIView *passcodeView;
NSMutableDictionary *prefs;

%hook PHHandsetDialerNumberPadButton
-(UIView *)circleView
{
    phoneView = %orig;
    return phoneView;
}
+(id)imageForCharacter:(unsigned)arg1
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.romankeypadprefs.plist"];
    switch ([[prefs objectForKey:@"phoneStyle"] intValue])
    {
        case 0:
            return %orig;
        case 1:
            return %orig(-1);
    }
    UILabel *roman = [[UILabel alloc] initWithFrame:phoneView.frame];
    switch (arg1)
    {
        case 0:
            roman.text = @"I";
            break;
        case 1:
            roman.text = @"II";
            break;
        case 2:
            roman.text = @"III";
            break;
        case 3:
            roman.text = @"IV";
            break;
        case 4:
            roman.text = @"V";
            break;
        case 5:
            roman.text = @"VI";
            break;
        case 6:
            roman.text = @"VII";
            break;
        case 7:
            roman.text = @"VIII";
            break;
        case 8:
            roman.text = @"IX";
            break;
        case 9:
            roman.text = @"*";
            break;
        case 10:
            roman.text = [[prefs objectForKey:@"dash"] boolValue] == YES ? @"-" : @"0";
            break;
        case 11:
            roman.text = @"#";
            break;
        default:
            return %orig;
            break;
    }
    roman.font = [UIFont systemFontOfSize:phoneView.frame.size.width / 3];
    roman.textAlignment = NSTextAlignmentCenter;
    [phoneView.superview addSubview:roman];
    return %orig(-1);
}
%end
%hook SBPasscodeNumberPadButton
-(UIView *)circleView
{
    passcodeView = %orig;
    return passcodeView;
}
+(id)imageForCharacter:(unsigned)arg1
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.romankeypadprefs.plist"];
   
    switch ([[prefs objectForKey:@"passcodeStyle"] intValue])
    {
        case 0:
            return %orig;
        case 1:
            return %orig(-1);
    }
    UILabel *roman = [[UILabel alloc] initWithFrame:passcodeView.frame];
    switch (arg1)
    {
        case 0:
            roman.text = @"I";
            break;
        case 1:
            roman.text = @"II";
            break;
        case 2:
            roman.text = @"III";
            break;
        case 3:
            roman.text = @"IV";
            break;
        case 4:
            roman.text = @"V";
            break;
        case 5:
            roman.text = @"VI";
            break;
        case 6:
            roman.text = @"VII";
            break;
        case 7:
            roman.text = @"VIII";
            break;
        case 8:
            roman.text = @"IX";
            break;
        case 10:
            roman.text = [[prefs objectForKey:@"dash"] boolValue] == YES ? @"-" : @"0";
            break;
        default:
            return %orig;
            break;
    }
    roman.font = [UIFont systemFontOfSize:passcodeView.frame.size.width / 3];
    roman.textColor = [UIColor whiteColor];
    roman.textAlignment = NSTextAlignmentCenter;
    [passcodeView.superview addSubview:roman];
    return %orig(-1);
}
%end