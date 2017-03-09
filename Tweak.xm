#import "Interfaces.h"

@interface Splyce : NSObject <LAListener>
@end

@implementation Splyce

+ (void)load {
	@autoreleasepool {
		if (LASharedActivator.runningInsideSpringBoard) {
			Splyce *listener = [[self alloc] init];
			[LASharedActivator registerListener:listener forName:@"com.shade.splyce"];
		}
		Boolean exists = NO;
		CFPreferencesGetAppBooleanValue(CFSTR("SLAppEnabled-com.apple.mobilemail"), CFSTR("com.shade.splyce"), &exists);
		if (!exists) {
			CFPreferencesSetAppValue(CFSTR("SLAppEnabled-com.apple.mobilemail"), kCFBooleanTrue, CFSTR("com.shade.splyce"));
			CFPreferencesAppSynchronize(CFSTR("com.shade.splyce"));
		}
	}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	event.handled = YES;
	dispatch_async(dispatch_get_main_queue(), ^{
		CFPreferencesAppSynchronize(CFSTR("com.shade.splyce"));
		for (FBApplicationProcess *process in [(FBProcessManager *)[%c(FBProcessManager) sharedInstance] allApplicationProcesses]) {
			CFStringRef enabledKey = (__bridge CFStringRef)[NSString stringWithFormat:@"SLAppEnabled-%@", process.bundleIdentifier];
			BOOL enabled = !CFPreferencesCopyAppValue(enabledKey, CFSTR("com.shade.splyce")) ? YES : [(__bridge id)CFPreferencesCopyAppValue(enabledKey, CFSTR("com.shade.splyce")) boolValue];
			if (enabled) {
				HBLogDebug(@"%@ is enabled", process.bundleIdentifier);
				if (!process.nowPlayingWithAudio && !process.recordingAudio) {
					BKSProcess *bkProcess = MSHookIvar<BKSProcess*>(process, "_bksProcess");
					if (bkProcess) {
						[process processWillExpire:bkProcess];
					}
				}
			}
		}
	});
}

@end
