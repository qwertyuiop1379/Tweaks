#include <SparkAppList/SparkAppList.h>

NSString *bundleIdentifier;

%hook SFDialogContentView
-(void)layoutSubviews
{
	%orig;

	bundleIdentifier = @"com.apple.mobilesafari";
	if ([SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier])
	{
		NSArray *_actionButtons = MSHookIvar<NSArray *>(self, "_actionButtons");
		for (UIButton *button in _actionButtons)
		{
			if ([button.titleLabel.text isEqual:@"Open"])
			{
				[button removeFromSuperview];
			}
		}
	}
}
%end

%hook UIApplicationDelegate
-(BOOL)application:(id)arg1 handleOpenURL:(id)arg2
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	return [SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier] ? NO : %orig;
}

-(BOOL)application:(id)arg1 openURL:(id)arg2 sourceApplication:(id)arg3 annotation:(id)arg4
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	return [SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier] ? NO : %orig;
}

-(BOOL)application:(id)arg1 openURL:(id)arg2 options:(id)arg3
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	return [SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier] ? NO : %orig;
}
%end

%hook UIApplication
-(BOOL)openURL:(id)arg1
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	return [SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier] ? NO : %orig;
}

-(BOOL)_openURL:(id)arg1
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	return [SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier] ? NO : %orig;
}

-(void)applicationOpenURL:(id)arg1
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier])
	{
		%orig;
	}
}

-(void)openURL:(id)arg1 options:(id)arg2 completionHandler:(id)arg3
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier])
	{
		%orig;
	}
}

-(void)openURL:(id)arg1 withCompletionHandler:(id)arg2
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier])
	{
		%orig;
	}
}

-(void)_applicationOpenURL:(id)arg1 payload:(id)arg2
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier])
	{
		%orig;
	}
}

-(void)_openURL:(id)arg1 originatingView:(id)arg2 completionHandler:(id)arg3
{
	bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![SparkAppList doesIdentifier:@"com.qiop1379.openblockerprefs" andKey:@"blocksOpenAttempts" containBundleIdentifier:bundleIdentifier])
	{
		%orig;
	}
}
%end