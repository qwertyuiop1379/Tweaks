#import <spawn.h>
#import <_UIActionSlider.h>
#import <_UIActionSliderDelegate.h>

@interface SBPowerDownController : UIViewController <_UIActionSliderDelegate, UIGestureRecognizerDelegate>
+(id)sharedInstance;
-(void)actionSliderDidCompleteSlide:(id)arg1;
-(void)powerDown;
@end

@interface _UIActionSliderKnob : UIView
@end

@interface FBSystemService
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)yes;
@end

@implementation UIImage (scale)
-(UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end

_UIActionSlider *powerSlider;
_UIActionSlider *respringSlider;
_UIActionSlider *rebootSlider;
_UIActionSlider *safeModeSlider;
NSMutableDictionary *prefs;
int cycle = 0;

%hook SBUIPowerDownView
-(void)layoutSubviews
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.powerdownprefs.plist"];
    %orig;
    if ([[prefs objectForKey:@"powerEnabled"] boolValue] == NO || [[prefs objectForKey:@"powerTap"] boolValue] == YES)
    {
        [MSHookIvar<_UIActionSlider *>(self, "_actionSlider") removeFromSuperview];
    }
}
%end

%hook SBPowerDownController
-(void)orderFront
{
    %orig;
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.qiop1379.powerdownprefs.plist"];
    if ([[prefs objectForKey:@"powerTap"] boolValue] == YES)
    {
        powerSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, 50, 400, 75)];
        powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleToSize:CGSizeMake(66, 66)];
        powerSlider.delegate = self;
        powerSlider.trackText = @"slide to power off";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped)];
        tap.numberOfTapsRequired = 1;
        [powerSlider addGestureRecognizer:tap];
        [self.view addSubview:powerSlider];
    }
    else
    {
        CGFloat yval = ([[prefs objectForKey:@"powerEnabled"] boolValue] == NO) ? 50 : 150;
        if ([[prefs objectForKey:@"respringEnabled"] boolValue] == YES || [prefs objectForKey:@"respringEnabled"] == nil)
        {
            respringSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, yval, 400, 75)];
            respringSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleToSize:CGSizeMake(66, 66)];
            respringSlider.delegate = self;
            respringSlider.trackText = @"slide to respring";
            [self.view addSubview:respringSlider];
            yval += 100;
        }

        if ([[prefs objectForKey:@"rebootEnabled"] boolValue] == YES || [prefs objectForKey:@"rebootEnabled"] == nil)
        {
            rebootSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, yval, 400, 75)];
            rebootSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleToSize:CGSizeMake(66, 66)];
            rebootSlider.knobView.frame = CGRectMake(rebootSlider.frame.origin.x, rebootSlider.frame.origin.y, 66, 66);
            rebootSlider.delegate = self;
            rebootSlider.trackText = @"slide to ldrestart";
            [self.view addSubview:rebootSlider];
            yval += 100;
        }

        if ([[prefs objectForKey:@"safeModeEnabled"] boolValue] == YES || [prefs objectForKey:@"safeModeEnabled"] == nil)
        {
            safeModeSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, yval, 400, 75)];
            safeModeSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleToSize:CGSizeMake(66, 66)];
            safeModeSlider.delegate = self;
            safeModeSlider.trackText = @"slide to safe mode";
            [self.view addSubview:safeModeSlider];
        }
    }
}

-(void)cancel
{
    [powerSlider removeFromSuperview];
    [respringSlider removeFromSuperview];
    [rebootSlider removeFromSuperview];
    [safeModeSlider removeFromSuperview];
    %orig;
}

%new
-(void)actionSliderDidCompleteSlide:(id)arg1
{
    _UIActionSlider *slider = (_UIActionSlider *)arg1;
    if ([slider.trackText isEqual:@"slide to power off"])
    {
        [[%c(SBPowerDownController) sharedInstance] powerDown];
    }    
    if ([slider.trackText isEqual:@"slide to respring"])
    {
        [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
    }
    if ([slider.trackText isEqual:@"slide to ldrestart"])
    {
        pid_t pid;
        int status;
        const char *args[] = {"ldRun", NULL};
        posix_spawn(&pid, "/usr/bin/ldRun", NULL, NULL, (char* const*)args, NULL);
        waitpid(pid, &status, WEXITED);
    }
    if ([slider.trackText isEqual:@"slide to safe mode"])
    {
        pid_t pid;
        int status;
        const char* args[] = {"killall", "-SEGV", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
        waitpid(pid, &status, WEXITED);
    }
}

%new
-(void)sliderTapped
{
    cycle++;
    if (cycle > 3) cycle = 0;

    switch (cycle)
    {
        case 0:
            powerSlider.trackText = @"slide to power off";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleToSize:CGSizeMake(66, 66)];
            break;
        case 1:
            powerSlider.trackText = @"slide to respring";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleToSize:CGSizeMake(66, 66)];
            break;
        case 2:
            powerSlider.trackText = @"slide to ldrestart";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleToSize:CGSizeMake(66, 66)];
            break;
        case 3:
            powerSlider.trackText = @"slide to safe mode";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleToSize:CGSizeMake(66, 66)];
            break;
    }
}
%end