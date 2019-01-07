@interface DXIRootViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@interface LSApplicationWorkspace : NSObject
+(id)defaultWorkspace;
-(NSArray *)allInstalledApplications;
@end

@interface LSBundleProxy : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;
@end