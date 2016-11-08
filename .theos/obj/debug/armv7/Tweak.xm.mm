#line 1 "Tweak.xm"
#import "Interfaces.h"

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

@class SBUIController; @class FBProcessManager; @class SBAppSwitcherModel; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBUIController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBUIController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$FBProcessManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("FBProcessManager"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBAppSwitcherModel(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBAppSwitcherModel"); } return _klass; }
#line 6 "Tweak.xm"
@implementation Splyce

+ (void)load{
	@autoreleasepool{
		if (LASharedActivator.runningInsideSpringBoard) {
			Splyce *listener = [[self alloc] init];
			[LASharedActivator registerListener:listener forName:@"com.shade.splyce"];
		}
		Boolean exists = false;
		CFPreferencesGetAppBooleanValue(CFSTR("SCAppEnabled-com.apple.mobilemail"), CFSTR("com.shade.splyce"), &exists);
		if (!exists) {
			CFPreferencesSetAppValue(CFSTR("SCAppEnabled-com.apple.mobilemail"), kCFBooleanTrue, CFSTR("com.shade.splyce"));
			CFPreferencesAppSynchronize(CFSTR("com.shade.splyce"));
		}
	}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{
	event.handled = YES;
	dispatch_async(dispatch_get_main_queue(), ^{
		CFPreferencesAppSynchronize(CFSTR("com.shade.splyce"));
		SBAppSwitcherModel *model = (SBAppSwitcherModel *)[_logos_static_class_lookup$SBAppSwitcherModel() sharedInstance];
		NSArray *identifiers = [model respondsToSelector:@selector(identifiers)] ? model.identifiers : model.snapshot;
		if ([identifiers count]) {
			Boolean exists = false;
			Boolean clearSwitcher = CFPreferencesGetAppBooleanValue(CFSTR("SCClearSwitcher"), CFSTR("com.shade.splyce"), &exists);
			if (!exists || clearSwitcher) {
				if ([model respondsToSelector:@selector(appsRemoved:added:)]) {
					[model appsRemoved:[NSArray arrayWithArray:identifiers] added:nil];
				} else {
					for (NSString *displayIdentifier in identifiers) {
						[model remove:displayIdentifier];
					}
				}
			}
		}
		SBUIController *uic = (SBUIController *)[_logos_static_class_lookup$SBUIController() sharedInstance];
		[uic dismissSwitcherAnimated:YES];
		FBApplicationProcess *currentProcess = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		for (FBApplicationProcess *process in [(FBProcessManager *)[_logos_static_class_lookup$FBProcessManager() sharedInstance] allApplicationProcesses]) {
			if (!process.nowPlayingWithAudio && !process.recordingAudio && (process != currentProcess)) {
				BKSProcess *bkProcess = MSHookIvar<BKSProcess*>(process, "_bksProcess");
				if (bkProcess) {
					[process processWillExpire:bkProcess];
				}
			}
		}
	});
}

@end
#line 57 "Tweak.xm"
