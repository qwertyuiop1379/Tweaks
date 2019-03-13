#import <UIKit/UIKit.h>
#import "Tweak.h"

UIButton *doneButton;
UITextView *textView;
UIVisualEffectView *blurView;

%hook UILabel
-(void)layoutSubviews
{
    %orig;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTap:)];
    tap.numberOfTapsRequired = 3;
    self.userInteractionEnabled = YES;
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
}

%new
-(void)tripleTap:(UITapGestureRecognizer *)sender
{
    NSString *contents = ((UILabel *)sender.view).text;
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *sharedApplication = [UIApplication sharedApplication];

    NSString *bundle = [[[%c(NSWorkspace) sharedWorkspace] frontmostApplication] bundleIdentifier];

    [[[UIAlertView alloc] initWithTitle:@"ok" message:bundle delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];

    if ([bundle isEqual:@"com.youtube.ios.youtube"])
    {
        YTFormattedString *string = [(YTFormattedStringLabel *)self safeValueForKey:@"_formattedString"];
        contents = string.accessibilityLabel;
    }

    blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blurView.frame = [UIScreen mainScreen].bounds;
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    doneButton.frame = CGRectMake(20, 30, size.width - 40, 40);
    doneButton.layer.borderColor = [UIColor cyanColor].CGColor;
    doneButton.layer.borderWidth = 0.5f;
    doneButton.layer.cornerRadius = 5;

	textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, size.width - 40, size.height - 100)];
	textView.text = contents;
	textView.backgroundColor = [UIColor whiteColor];
	textView.layer.borderColor = [UIColor blackColor].CGColor;
	textView.layer.borderWidth = 0.5f;
    textView.layer.cornerRadius = 5;
	textView.textColor = [UIColor blackColor];
	textView.font = [UIFont systemFontOfSize:15];
    textView.editable = NO;

    blurView.alpha = 0;
    doneButton.alpha = 0;
    textView.alpha = 0;

    [sharedApplication.keyWindow addSubview:blurView];
    [sharedApplication.keyWindow addSubview:doneButton];
    [sharedApplication.keyWindow addSubview:textView];

    [UIView animateWithDuration:0.5f animations:^
    {
        blurView.alpha = 1;
        doneButton.alpha = 1;
        textView.alpha = 1;
    }
    completion:nil];
}

%new
-(void)closeView
{
    [UIView animateWithDuration:0.5f animations:^
    {
        blurView.alpha = 0;
        doneButton.alpha = 0;
        textView.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [blurView removeFromSuperview];
        [doneButton removeFromSuperview];
        [textView removeFromSuperview];
    }];
}
%end