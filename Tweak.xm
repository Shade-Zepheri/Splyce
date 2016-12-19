#import "Interfaces.h"
#import <notify.h>

@interface Splyce : NSObject <LAListener>
@end

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
		for (FBApplicationProcess *process in [(FBProcessManager *)[%c(FBProcessManager) sharedInstance] allApplicationProcesses]) {
			if (!process.nowPlayingWithAudio && !process.recordingAudio) {
				BKSProcess *bkProcess = MSHookIvar<BKSProcess*>(process, "_bksProcess");
				if (bkProcess) {
					[process processWillExpire:bkProcess];
				}
			}
		}
	});
}

@end
