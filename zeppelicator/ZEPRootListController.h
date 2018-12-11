#import <Preferences/PSListController.h>

@interface UIImage (scale)
-(UIImage *)scaleToSize:(CGSize)size;
@end

@interface ZEPRootListController : PSListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end