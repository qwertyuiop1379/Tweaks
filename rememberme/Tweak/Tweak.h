@interface UIAlertAction (properties)
@property (nonatomic, retain) UIAlertController *_alertController;
@property (nonatomic, copy) void (^oldHandler)();
@property (nonatomic, copy) void (^handler)();
@end

@interface UIAlertController (properties)
-(BOOL)performThingWithThing:(NSDictionary * __strong *)alertDict;
@end

@interface _UIAlertControllerActionView : UIView
@property (nonatomic,copy) UIAlertAction *action;
-(void)handleHold;
@end