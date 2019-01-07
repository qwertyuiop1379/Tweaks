#import "project.h"

@implementation Project
-(instancetype)initWithName:(NSString *)name type:(int)type
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.type = type;
    }
    return self;
}
@end