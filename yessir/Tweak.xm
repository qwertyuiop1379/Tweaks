@interface _UIAlertControllerTextField : UITextField
@end

@interface _UIAlertControllerTextFieldView : UIView
@end

@interface _UIAlertControllerActionView : UIView
@end

@interface _UIInterfaceActionItemSeparatorView_iOS : UIView
@end

@interface _UIAlertControlleriOSActionSheetCancelBackgroundView : UIView
@end

@interface _UIAlertControllerInterfaceActionGroupView : UIView
@end

NSDictionary *preferences;

static BOOL BoolForKey(NSString *key, BOOL fallback)
{
	if (!preferences)
		return fallback;

	id object = preferences[key];
	return object ? [object boolValue] : fallback;
}

%hook UIAlertController
-(void)viewWillAppear:(BOOL)arg1
{
	%orig;

	MSHookIvar<UILabel *>(self.view, "_titleLabel").textColor = UIColor.whiteColor;
	MSHookIvar<UILabel *>(self.view, "_messageLabel").textColor = UIColor.whiteColor;
	[[MSHookIvar<id>(self.view, "_mainInterfaceActionsGroupView") backgroundView] removeFromSuperview];

	UIBlurEffectStyle effect = BoolForKey(@"dark", 1) ? UIBlurEffectStyleDark : UIBlurEffectStyleLight;

	UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
    blur.frame = self.view.superview.bounds;
    blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view.superview insertSubview:blur atIndex:0];

	self.view.superview.alpha = 0;

    [UIView animateWithDuration:0.5f animations:^
    {
    	self.view.superview.alpha = 1;
	}];
}

-(void)viewWillDisappear:(BOOL)arg1
{
	%orig;

	[UIView animateWithDuration:0.5f animations:^
    {
    	self.view.superview.alpha = 0;
	}];
}
%end

%hook _UIInterfaceActionItemSeparatorView_iOS
-(id)init
{
	if ((self = %orig))
	{
		self.alpha = 69;
	}

	return self;
}

-(void)setAlpha:(CGFloat)arg1
{
	%orig(0);
}
%end

%hook _UIAlertControlleriOSActionSheetCancelBackgroundView
-(void)didMoveToSuperview
{
	%orig;
	
	MSHookIvar<UIView *>(self, "backgroundView").backgroundColor = UIColor.clearColor;
}
%end

%hook _UIAlertControllerActionView
-(void)didMoveToSuperview
{
	%orig;

	self.superview.layer.cornerRadius = 15;
	self.superview.layer.masksToBounds = YES;
}
%end

%hook _UIAlertControllerTextFieldView
// text fields are not really working right now..
/*-(id)initWithFrame:(CGRect)arg1
{
	if ((self = %orig))
	{
		self.layer.borderColor = UIColor.grayColor.CGColor;
		self.layer.borderWidth = 0.5f;
		self.layer.cornerRadius = 5;
	}

	return self;
}*/

-(void)setContainerView:(UIView *)arg1
{
	arg1.subviews[1].backgroundColor = UIColor.clearColor;
	%orig;
}
%end

%hook _UIAlertControllerTextField
-(void)didMoveToSuperview
{
	MSHookIvar<UILabel *>(self, "_placeholderLabel").textColor = UIColor.grayColor;
	self.borderStyle = UITextBorderStyleNone;
}

-(void)setTextColor:(UIColor *)arg1
{
	%orig(UIColor.whiteColor);
}
%end

%hook _UIAlertControllerInterfaceActionGroupView
-(void)didMoveToSuperview
{
	for (UIView *view in self.subviews)
	{
		if ([view isKindOfClass:%c(_UIDimmingKnockoutBackdropView)])
		{
			view.hidden = 1;
		}
	}
}
%end

static void buttfuckmyass()
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.yessir"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        preferences = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.yessir"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!preferences) preferences = [NSDictionary new];
        CFRelease(keyList);
    }

    if (!preferences)
		preferences = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.yessir.plist"];
}

%ctor
{
    buttfuckmyass();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)buttfuckmyass, CFSTR("com.qiop1379.yessir"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}