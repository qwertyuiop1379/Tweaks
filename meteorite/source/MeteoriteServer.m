#import <MRYIPCCenter.h>
#import "Tweak.h"

@implementation MeteoriteServer
{
	MRYIPCCenter* _center;
	NSDictionary *_data;
}

+(void)load
{
	[self sharedInstance];
}

+(instancetype)sharedInstance
{
	static dispatch_once_t onceToken = 0;
	__strong static MeteoriteServer *sharedInstance = nil;

	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});

	return sharedInstance;
}

-(instancetype)init
{
	if ((self = [super init]))
	{
		_center = [MRYIPCCenter centerNamed:@"com.qiop1379.meteorite"];
		[_center addTarget:self action:@selector(getWeatherData)];
		[_center addTarget:self action:@selector(updateWeatherData:)];
	}
	return self;
}

-(NSDictionary *)getWeatherData
{
	return _data;
}

-(void)updateWeatherData:(NSDictionary *)data
{
	_data = data;
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.qiop1379.meteorite/set"), NULL, NULL, YES);
}
@end