

#import "MenuControl.h"

@interface MenuControl (Private)
- (void)scaleImage:(GLfloat)delta;
@end


@implementation MenuControl

#define MAX_SCALE 3.0f
#define SCALE_DELTA 1.0f
#define ALPHA_DELTA 1.0f

- (id)initWithImageNamed:(NSString*)theImageName location:(Vector2f)theLocation centerOfImage:(BOOL)theCenter type:(uint)theType {
	self = [super init];
	if (self != nil) {
		sharedDirector = [Director sharedDirector];
		image = [(Image*)[Image alloc] initWithImageNamed:theImageName filter:GL_LINEAR];
		location = theLocation;
		centered = theCenter;
		type = theType;
		state = kControlState_Idle;
		scale = 1.0f;
		alpha = 1.0f;
	}
	return self;
}

- (void)updateWithLocation:(NSString*)theTouchLocation 
{

	CGRect controlBounds = CGRectMake(location.x - (([image imageWidth]*[image scale])/2), location.y - (([image imageHeight]*[image scale])/2), [image imageWidth]*[image scale], [image imageHeight]*[image scale]);
	
	CGPoint touchPoint = CGPointFromString((NSString*)theTouchLocation);
	
	if(CGRectContainsPoint(controlBounds, touchPoint) && state != kControlState_Scaling) {
		state = kControlState_Scaling;
	}
}

- (void)updateWithDelta:(NSNumber*)theDelta {

	// Get the delta value which has been passed in
	GLfloat delta = [theDelta floatValue];

	if(state == kControlState_Scaling) {		
		[self scaleImage:delta];
	}
	if(state == kControlState_Idle) {
		scale = 1.0f;
		alpha = 1.0f;
	}
}


- (void)scaleImage:(GLfloat)delta {
	scale += SCALE_DELTA * delta;
	alpha -= ALPHA_DELTA * delta;
	if(scale > MAX_SCALE) {
		scale = MAX_SCALE;
		state = kControlState_Selected;
	}
}


- (void)render {
	[image setAlpha:alpha];
	[image setScale:scale];
	[image renderAtPoint:CGPointMake(location.x, location.y) centerOfImage:centered];	
}

@end
