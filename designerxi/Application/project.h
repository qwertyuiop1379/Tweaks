@interface Project : NSObject
@property (retain) NSString *name;
@property (assign) int type;
-(instancetype)initWithName:(NSString *)name type:(int)type;
@end