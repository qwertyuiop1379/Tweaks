@interface CKMessageEntryRichTextView : UITextView
@end

@interface CKMessageEntryContentView : UIView
-(CKMessageEntryRichTextView *)textView;
@end

@interface CKMessageEntryView : UIView
-(CKMessageEntryContentView *)contentView;
@end

NSDictionary *preferences;

%hook CKMessageEntryView
-(void)touchUpInsideSendButton:(id)arg1
{
	id object = preferences[@"enable"];

	if (!object || [object boolValue])
		self.contentView.textView.text = [self.contentView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	%orig;
}
%end

static void LoadPreferences()
{
	CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.cut"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

	if (keyList)
	{
		preferences = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.cut"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		
		if (!preferences)
			preferences = [NSDictionary new];

		CFRelease(keyList);
	}

	if (!preferences)
		preferences = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.cut.plist"];
}

%ctor
{
	LoadPreferences();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LoadPreferences, CFSTR("com.qiop1379.cut"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}