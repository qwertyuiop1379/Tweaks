#import <spawn.h>
#import "_UIActionSlider.h"
#import "_UIActionSliderDelegate.h"

@interface SBPowerDownController : UIViewController <_UIActionSliderDelegate, UIGestureRecognizerDelegate>
+(id)sharedInstance;
-(void)actionSliderDidCompleteSlide:(id)arg1;
-(void)animateIn;
-(void)powerDown;
@end

@interface FBSystemService
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)yes;
@end

@interface _UIActionSliderKnob : UIView
@end

@implementation UIImage (scale)
-(UIImage *)scaleImage:(CGSize)size
{
UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

_UIActionSlider *powerSlider, *respringSlider, *rebootSlider, *safeModeSlider;
NSDictionary *prefs;
int sliderState;

%hook SBUIPowerDownView
-(void)layoutSubviews
{
    %orig;
    [MSHookIvar<id>(self, "_actionSlider") removeFromSuperview];
}
%end

%hook SBPowerDownController
-(void)orderFront
{
    %orig;
    if ([[prefs objectForKey:@"powerTap"] boolValue] == YES)
    {
        sliderState = 0;
        powerSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, 50, 400, 75)];
        powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleImage:CGSizeMake(66, 66)];
        powerSlider.delegate = self;
        powerSlider.trackText = @"slide to power off";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped)];
        tap.numberOfTapsRequired = 1;
        [powerSlider addGestureRecognizer:tap];
        [self.view addSubview:powerSlider];
    }
    else
    {
        CGFloat yval = 50;
        CGFloat thing = 400;
        if ([[prefs objectForKey:@"powerEnabled"] boolValue] == YES || [prefs objectForKey:@"powerEnabled"] == nil)
        {
            powerSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleImage:CGSizeMake(66, 66)];
            powerSlider.delegate = self;
            powerSlider.trackText = @"slide to power off";
            [self.view addSubview:powerSlider];
            yval += 100;
            thing *= -1;
        }

        if ([[prefs objectForKey:@"respringEnabled"] boolValue] == YES || [prefs objectForKey:@"respringEnabled"] == nil)
        {
            respringSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
            respringSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleImage:CGSizeMake(66, 66)];
            respringSlider.delegate = self;
            respringSlider.trackText = @"slide to respring";
            [self.view addSubview:respringSlider];
            yval += 100;
            thing *= -1;
        }

        if ([[prefs objectForKey:@"rebootEnabled"] boolValue] == YES || [prefs objectForKey:@"rebootEnabled"] == nil)
        {
            rebootSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
            rebootSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleImage:CGSizeMake(66, 66)];
            rebootSlider.knobView.frame = CGRectMake(rebootSlider.frame.origin.x, rebootSlider.frame.origin.y, 66, 66);
            rebootSlider.delegate = self;
            rebootSlider.trackText = @"slide to ldrestart";
            [self.view addSubview:rebootSlider];
            yval += 100;
            thing *= -1;
        }

        if ([[prefs objectForKey:@"safeModeEnabled"] boolValue] == YES || [prefs objectForKey:@"safeModeEnabled"] == nil)
        {
            safeModeSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
            safeModeSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleImage:CGSizeMake(66, 66)];
            safeModeSlider.delegate = self;
            safeModeSlider.trackText = @"slide to safe mode";
            [self.view addSubview:safeModeSlider];
        }

        [self animateIn];
    }
}

-(void)cancel
{
    // animate out
    [UIView animateWithDuration:0.5f animations:^
    {
        powerSlider.frame = CGRectMake(-400, powerSlider.frame.origin.y, 400, 75);
        respringSlider.frame = CGRectMake(self.view.frame.size.width, respringSlider.frame.origin.y, 400, 75);
        rebootSlider.frame = CGRectMake(-400, rebootSlider.frame.origin.y, 400, 75);
        safeModeSlider.frame = CGRectMake(self.view.frame.size.width, safeModeSlider.frame.origin.y, 400, 75);
    }
    completion:^(BOOL finished)
    {
        [powerSlider removeFromSuperview];
        [respringSlider removeFromSuperview];
        [rebootSlider removeFromSuperview];
        [safeModeSlider removeFromSuperview];
        %orig;
    }];
}

%new
-(void)animateIn
{
    [UIView animateWithDuration:0.5f animations:^
    {
        CGFloat location = self.view.frame.size.width/2 - 200;
        powerSlider.frame = CGRectMake(location, powerSlider.frame.origin.y, 400, 75);
        respringSlider.frame = CGRectMake(location, respringSlider.frame.origin.y, 400, 75);
        rebootSlider.frame = CGRectMake(location, rebootSlider.frame.origin.y, 400, 75);
        safeModeSlider.frame = CGRectMake(location, safeModeSlider.frame.origin.y, 400, 75);
    }
    completion:nil];
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
    if ([slider.trackText isEqual:(@"slide to ldrestart")])
    {
        pid_t pid;
        int status;
        const char* args[] = {"ldRun", NULL};
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
    sliderState = sliderState > 3 ? 0 : ++sliderState;
    switch (sliderState)
    {
        case 0:
            powerSlider.trackText = @"slide to power off";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleImage:CGSizeMake(66, 66)];
            break;
        case 1:
            powerSlider.trackText = @"slide to respring";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleImage:CGSizeMake(66, 66)];
            break;
        case 2:
            powerSlider.trackText = @"slide to ldrestart";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleImage:CGSizeMake(66, 66)];
            break;
        case 3:
            powerSlider.trackText = @"slide to safe mode";
            powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleImage:CGSizeMake(66, 66)];
            break;
    }
}
%end

static void reloadPrefs()
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.powerdownprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        prefs = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.powerdownprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!prefs) prefs = [NSDictionary new];
        CFRelease(keyList);
    }
    if (!prefs) prefs = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.powerdownprefs.plist"];
}

%ctor
{
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, CFSTR("com.qiop1379.powerdown/prefchanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
