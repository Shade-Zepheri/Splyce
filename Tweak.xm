#import "Interfaces.h"

@interface Splyce : NSObject <LAListener>
@end

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
		Boolean exists = false;
		Boolean clearSwitcher = CFPreferencesGetAppBooleanValue(CFSTR("SCClearSwitcher"), CFSTR("com.shade.splyce"), &exists);
		if (!exists || clearSwitcher) {
			SBDisplayItem *item = [%c(SBDisplayItem) displayItemWithType:@"App" displayIdentifier:ident];
	    id appSwitcherModel = [%c(SBAppSwitcherModel) sharedInstance];
	        [[%c(SBAppSwitcherModel) sharedInstance] remove:item];
		}
		//SBUIController *uic = (SBUIController *)[%c(SBUIController) sharedInstance];
		//[uic dismissSwitcherAnimated:YES];
		FBApplicationProcess *currentProcess = [(SpringBoard*)[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		for (FBApplicationProcess *process in [(FBProcessManager *)[%c(FBProcessManager) sharedInstance] allApplicationProcesses]) {
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
