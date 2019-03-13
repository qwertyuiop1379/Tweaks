@interface NSObject (internal)
-(id)safeValueForKey:(id)arg1;
@end

@interface UILabel (gesture)
-(void)tripleTap:(UITapGestureRecognizer *)sender;
-(void)closeView;
@end

@interface NSRunningApplication : NSObject
@property(readonly, copy) NSString *bundleIdentifier;
@end

@interface NSWorkspace : NSObject
@property(readonly, copy) NSArray *runningApplications;
+(id)sharedWorkspace;
@end

// youtube labels

@interface YTFormattedString : NSObject
@property (nonatomic, retain) NSString *accessibilityLabel;
@end

@interface YTFormattedStringLabel : UILabel
@end