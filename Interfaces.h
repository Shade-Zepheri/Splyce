#import <UIKit/UIKit.h>
#import <substrate.h>
#import <notify.h>
#import <libactivator/libactivator.h>
#import <Foundation/Foundation.h>

@interface FBApplicationProcess : NSObject
@property (assign,getter=isRecordingAudio,nonatomic) BOOL recordingAudio;                                                         //@synthesize recordingAudio=_recordingAudio - In the implementation block
@property (assign,getter=isNowPlayingWithAudio,nonatomic) BOOL nowPlayingWithAudio;
@property (nonatomic,copy,readonly) NSString * bundleIdentifier;
- (void)processWillExpire:(id)arg1;
@end

@interface FBProcessManager : NSObject
+ (id)sharedInstance;
- (NSArray *)allApplicationProcesses;
@end

@interface BKSProcess : NSObject
@end
