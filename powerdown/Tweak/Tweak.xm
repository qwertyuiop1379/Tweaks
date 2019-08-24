#import <spawn.h>
#import "_UIActionSlider.h"
#import "_UIActionSliderDelegate.h"

@interface SBPowerDownController : UIViewController <_UIActionSliderDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) _UIActionSlider *powerSlider;
@property (nonatomic, retain) _UIActionSlider *respringSlider;
@property (nonatomic, retain) _UIActionSlider *ldrestartSlider;
@property (nonatomic, retain) _UIActionSlider *safeModeSlider;
@property (nonatomic, retain) UIImage *powerImage;
@property (nonatomic, retain) UIImage *respringImage;
@property (nonatomic, retain) UIImage *ldrestartImage;
@property (nonatomic, retain) UIImage *safeModeImage;
-(void)powerDown;
@end

@interface FBSystemService
+(id)sharedInstance;
-(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface UIImage (scale)
-(UIImage *)scaleImage:(CGSize)arg1;
@end

NSDictionary *preferences;
int sliderState;

%hook SBUIPowerDownView
-(void)didMoveToSuperview
{
    %orig;
    
    [MSHookIvar<id>(self, "_actionSlider") removeFromSuperview];
}
%end

%hook SBPowerDownController
%property (nonatomic, retain) _UIActionSlider *powerSlider;
%property (nonatomic, retain) _UIActionSlider *respringSlider;
%property (nonatomic, retain) _UIActionSlider *ldrestartSlider;
%property (nonatomic, retain) _UIActionSlider *safeModeSlider;
%property (nonatomic, retain) UIImage *powerImage;
%property (nonatomic, retain) UIImage *respringImage;
%property (nonatomic, retain) UIImage *ldrestartImage;
%property (nonatomic, retain) UIImage *safeModeImage;
-(void)orderFront
{
    %orig;

    if (!self.powerImage)
    {
        self.powerImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleImage:CGSizeMake(66, 66)];
        self.respringImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleImage:CGSizeMake(66, 66)];
        self.ldrestartImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleImage:CGSizeMake(66, 66)];
        self.safeModeImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleImage:CGSizeMake(66, 66)];
    }

    if ([[preferences objectForKey:@"powerTap"] boolValue] == YES)
    {
        if (!self.powerSlider)
        {
            self.powerSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 200, 50, 400, 75)];
            self.powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleImage:CGSizeMake(66, 66)];
            self.powerSlider.delegate = self;
            self.powerSlider.trackText = @"slide to power off";
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped)];
            tap.numberOfTapsRequired = 1;
            [self.powerSlider addGestureRecognizer:tap];
        }

        sliderState = 0;
        [self.view addSubview:self.powerSlider];
    }
    else
    {
        CGFloat yval = 50;
        CGFloat thing = 400;
        if ([[preferences objectForKey:@"powerEnabled"] boolValue] == YES || [preferences objectForKey:@"powerEnabled"] == nil)
        {
            if (!self.powerSlider)
            {
                self.powerSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
                self.powerSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/power.png"] scaleImage:CGSizeMake(66, 66)];
                self.powerSlider.delegate = self;
                self.powerSlider.trackText = @"slide to power off";
                [self.view addSubview:self.powerSlider];
            }
            
            yval += 100;
            thing *= -1;
        }

        if ([[preferences objectForKey:@"respringEnabled"] boolValue] == YES || [preferences objectForKey:@"respringEnabled"] == nil)
        {
            if (!self.respringSlider)
            {
                self.respringSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
                self.respringSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/respring.png"] scaleImage:CGSizeMake(66, 66)];
                self.respringSlider.delegate = self;
                self.respringSlider.trackText = @"slide to respring";
                [self.view addSubview:self.respringSlider];
            }

            yval += 100;
            thing *= -1;
        }

        if ([[preferences objectForKey:@"rebootEnabled"] boolValue] == YES || [preferences objectForKey:@"rebootEnabled"] == nil)
        {
            if (!self.ldrestartSlider)
            {
                self.ldrestartSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
                self.ldrestartSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/reboot.png"] scaleImage:CGSizeMake(66, 66)];
                self.ldrestartSlider.delegate = self;
                self.ldrestartSlider.trackText = @"slide to ldrestart";
                [self.view addSubview:self.ldrestartSlider];
            }

            yval += 100;
            thing *= -1;
        }

        if ([[preferences objectForKey:@"safeModeEnabled"] boolValue] == YES || [preferences objectForKey:@"safeModeEnabled"] == nil)
        {
            if (!self.safeModeSlider)
            {
                self.safeModeSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(thing, yval, 400, 75)];
                self.safeModeSlider.knobImage = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PowerDown.bundle/safemode.png"] scaleImage:CGSizeMake(66, 66)];
                self.safeModeSlider.delegate = self;
                self.safeModeSlider.trackText = @"slide to safe mode";
                [self.view addSubview:self.safeModeSlider];
            }
        }

        [UIView animateWithDuration:0.5f animations:^
        {
            CGFloat location = self.view.frame.size.width/2 - 200;
            self.powerSlider.frame = CGRectMake(location, self.powerSlider.frame.origin.y, 400, 75);
            self.respringSlider.frame = CGRectMake(location, self.respringSlider.frame.origin.y, 400, 75);
            self.ldrestartSlider.frame = CGRectMake(location, self.ldrestartSlider.frame.origin.y, 400, 75);
            self.safeModeSlider.frame = CGRectMake(location, self.safeModeSlider.frame.origin.y, 400, 75);
        }];
    }
}

-(void)cancel
{
    [UIView animateWithDuration:0.5f animations:^
    {
        self.powerSlider.frame = CGRectMake(-400, self.powerSlider.frame.origin.y, 400, 75);
        self.respringSlider.frame = CGRectMake(self.view.frame.size.width, self.respringSlider.frame.origin.y, 400, 75);
        self.ldrestartSlider.frame = CGRectMake(-400, self.ldrestartSlider.frame.origin.y, 400, 75);
        self.safeModeSlider.frame = CGRectMake(self.view.frame.size.width, self.safeModeSlider.frame.origin.y, 400, 75);
    }
    completion:^(BOOL finished)
    {
        [self.powerSlider removeFromSuperview];
        [self.respringSlider removeFromSuperview];
        [self.ldrestartSlider removeFromSuperview];
        [self.safeModeSlider removeFromSuperview];
        %orig;
    }];
}

%new
-(void)actionSliderDidCompleteSlide:(_UIActionSlider *)arg1
{
    if ([arg1.trackText isEqual:@"slide to power off"])
        [self powerDown];
    else if ([arg1.trackText isEqual:@"slide to respring"])
        [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
    else if ([arg1.trackText isEqual:(@"slide to ldrestart")])
    {
        pid_t pid;
        int status;
        const char *args[] = {"_ldrestart", NULL};
        posix_spawn(&pid, "/usr/bin/_ldrestart", NULL, NULL, (char * const *)args, NULL);
        waitpid(pid, &status, WEXITED);
    }
    else
    {
        pid_t pid;
        int status;
        const char *args[] = {"killall", "-SEGV", "SpringBoard", NULL};
        posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)args, NULL);
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
            self.powerSlider.trackText = @"slide to power off";
            self.powerSlider.knobImage = self.powerImage;
            break;
        case 1:
            self.powerSlider.trackText = @"slide to respring";
            self.powerSlider.knobImage = self.respringImage;
            break;
        case 2:
            self.powerSlider.trackText = @"slide to ldrestart";
            self.powerSlider.knobImage = self.ldrestartImage;
            break;
        case 3:
            self.powerSlider.trackText = @"slide to safe mode";
            self.powerSlider.knobImage = self.safeModeImage;
            break;
    }
}
%end

static void reloadPreferences()
{
    CFArrayRef keyList = CFPreferencesCopyKeyList(CFSTR("com.qiop1379.powerdownprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if(keyList)
    {
        preferences = (__bridge NSDictionary *)CFPreferencesCopyMultiple(keyList, CFSTR("com.qiop1379.powerdownprefs"), kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
        if (!preferences) preferences = [NSDictionary new];
        CFRelease(keyList);
    }
    if (!preferences) preferences = [[NSDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.qiop1379.powerdownprefs.plist"];
}

%ctor
{
    reloadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPreferences, CFSTR("com.qiop1379.powerdown/prefchanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

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