@interface SFMutableResultSection : NSObject
-(NSString *)bundleIdentifier;
-(NSDictionary *)dictionaryRepresentation;
@end

@interface SPUIResultsViewController : NSObject
-(NSArray *)resultSections;
@end

@interface SPUISearchViewController : NSObject
-(SPUIResultsViewController *)searchResultViewController;
@end

@interface SPUISearchHeader : NSObject
-(SPUISearchViewController *)delegate;
@end

@interface UIApplication (private)
-(void)launchApplicationWithIdentifier:(NSString *)arg1 suspended:(BOOL)arg2;
@end

%hook SPUISearchHeader
-(BOOL)textFieldShouldReturn
{
	NSArray *items = self.delegate.searchResultViewController.resultSections;

	for (SFMutableResultSection *section in items)
	{
		if ([section.bundleIdentifier isEqual:@"com.apple.application"])
		{
			NSDictionary *data = section.dictionaryRepresentation;
			NSDictionary *results = [data[@"results"] firstObject];
			NSString *bundleIdentifier = results[@"applicationBundleIdentifier"];

			[[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIdentifier suspended:NO];
			break;
		}
	}

	return %orig;
}
%end