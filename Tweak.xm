#import "Interfaces.h"

@interface Splyce : NSObject <LAListener>
@end

@implementation Splyce

+ (void)load{
	@autoreleasepool {
		if (LASharedActivator.runningInsideSpringBoard) {
			Splyce *listener = [[self alloc] init];
			[LASharedActivator registerListener:listener forName:@"com.shade.splyce"];
		}
	}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event{
	event.handled = YES;
	dispatch_async(dispatch_get_main_queue(), ^{
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
