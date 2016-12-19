#line 1 "Tweak.xm"
#import "Interfaces.h"
#import <notify.h>

@interface Splyce : NSObject <LAListener>
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class FBProcessManager; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$FBProcessManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("FBProcessManager"); } return _klass; }
#line 7 "Tweak.xm"
@implementation Splyce

+ (void)load{
	@autoreleasepool {
		if (LASharedActivator.runningInsideSpringBoard) {
			Splyce *listener = [[self alloc] init];
			[LASharedActivator registerListener:listener forName:@"com.shade.splyce"];
		}
		Boolean exists = false;
		CFPreferencesGetAppBooleanValue(CFSTR("SLAppEnabled-com.apple.mobilemail"), CFSTR("com.shade.splyce"), &exists);
		if (!exists) {
			CFPreferencesSetAppValue(CFSTR("SLAppEnabled-com.apple.mobilemail"), kCFBooleanTrue, CFSTR("com.shade.splyce"));
			CFPreferencesAppSynchronize(CFSTR("com.shade.splyce"));
		}
	}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{
	event.handled = YES;
	dispatch_async(dispatch_get_main_queue(), ^{
		CFPreferencesAppSynchronize(CFSTR("com.shade.splyce"));
		for (FBApplicationProcess *process in [(FBProcessManager *)[_logos_static_class_lookup$FBProcessManager() sharedInstance] allApplicationProcesses]) {
			if (!process.nowPlayingWithAudio && !process.recordingAudio) {
				BKSProcess *bkProcess = MSHookIvar<BKSProcess*>(process, "_bksProcess");
				if (bkProcess) {
					HBLogDebug(@"%@", bkProcess.terminationReason);
					[process processWillExpire:bkProcess];
				}
			}
		}
	});
}

@end
#line 41 "Tweak.xm"
