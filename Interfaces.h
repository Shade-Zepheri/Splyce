#import <UIKit/UIKit.h>
#import <substrate.h>
#import <notify.h>
#import <libactivator/libactivator.h>
#import <Foundation/Foundation.h>
#import <SpringBoard/SBApplication.h>

@interface SpringBoard : UIApplication
@property (nonatomic, retain, readonly) id _accessibilityFrontMostApplication;
@end

@interface FBApplicationProcess : NSObject
@property (assign,getter=isRecordingAudio,nonatomic) BOOL recordingAudio;                                                         //@synthesize recordingAudio=_recordingAudio - In the implementation block
@property (assign,getter=isNowPlayingWithAudio,nonatomic) BOOL nowPlayingWithAudio;
- (void)launchIfNecessary;
- (BOOL)bootstrapAndExec;
- (void)killForReason:(int)arg1 andReport:(BOOL)arg2 withDescription:(id)arg3 completion:(id/*block*/)arg4;
- (void)killForReason:(int)arg1 andReport:(BOOL)arg2 withDescription:(id)arg3;
@property(readonly, copy, nonatomic) NSString *bundleIdentifier;
- (void)processWillExpire:(id)arg1;
@end

@interface SBApplication ()
-(void) clearDeactivationSettings;
-(id) mainScreenContextHostManager;
-(id) mainSceneID;
- (void)activate;
- (void)processDidLaunch:(id)arg1;
- (void)processWillLaunch:(id)arg1;
- (void)resumeForContentAvailable;
- (void)resumeToQuit;
- (void)_sendDidLaunchNotification:(_Bool)arg1;
- (void)notifyResumeActiveForReason:(long long)arg1;
@end

@interface SBAppSwitcherModel : NSObject
+ (id)sharedInstance;
- (id)snapshotOfFlattenedArrayOfAppIdentifiersWhichIsOnlyTemporary;
- (id)snapshot;
- (void)remove:(id)arg1;
- (void)removeDisplayItem:(id)arg1;
- (void)addToFront:(id)arg1;
- (void)_verifyAppList;
- (id)_recentsFromPrefs;
- (id)_recentsFromLegacyPrefs;

// iOS 9
- (id)commandTabDisplayItems;
- (id)displayItemsForAppsOfRoles:(id)arg1;
- (id)mainSwitcherDisplayItems;
//- (void)remove:(id)arg1;
- (void)addToFront:(id)arg1 role:(long long)arg2;
- (void)_warmUpIconForDisplayItem:(id)arg1;
- (void)_warmUpRecentIcons;
- (void)_pruneRoles;
- (id)_displayItemRolesFromPrefsForLoadedDisplayItems:(id)arg1;
- (void)_saveRecents;
- (void)_saveRecentsDelayed;
- (void)_invalidateSaveTimer;
- (void)_appActivationStateDidChange:(id)arg1;

@end

@interface FBProcessManager : NSObject
+ (id)sharedInstance;
- (void)_updateWorkspaceLockedState;
- (void)applicationProcessWillLaunch:(id)arg1;
- (void)noteProcess:(id)arg1 didUpdateState:(id)arg2;
- (void)noteProcessDidExit:(id)arg1;
- (id)_serviceClientAddedWithPID:(int)arg1 isUIApp:(BOOL)arg2 isExtension:(BOOL)arg3 bundleID:(id)arg4;
- (id)_serviceClientAddedWithConnection:(id)arg1;
- (id)_systemServiceClientAdded:(id)arg1;
- (BOOL)_isWorkspaceLocked;
- (id)createApplicationProcessForBundleID:(id)arg1 withExecutionContext:(id)arg2;
- (id)createApplicationProcessForBundleID:(id)arg1;
- (id)applicationProcessForPID:(int)arg1;
- (id)processForPID:(int)arg1;
- (id)applicationProcessesForBundleIdentifier:(id)arg1;
- (id)processesForBundleIdentifier:(id)arg1;
- (id)allApplicationProcesses;
- (id)allProcesses;
@end

@interface BKSProcess : NSObject { //BSBaseXPCClient  {
    int _pid;
    NSString *_bundlePath;
    NSObject<OS_dispatch_queue> *_clientQueue;
    bool _workspaceLocked;
    bool _connectedToExternalAccessories;
    bool _nowPlayingWithAudio;
    bool _recordingAudio;
    bool _supportsTaskSuspension;
    int _visibility;
    int _taskState;
    NSObject *_delegate;
    long long _terminationReason;
    long long _exitStatus;
}

@property (nonatomic, weak) NSObject * delegate;
@property int visibility;
@property long long terminationReason;
@property long long exitStatus;
@property bool workspaceLocked;
@property bool connectedToExternalAccessories;
@property bool nowPlayingWithAudio;
@property bool recordingAudio;
@property bool supportsTaskSuspension;
@property int taskState;
@property(readonly) double backgroundTimeRemaining;

+ (id)busyExtensionInstances:(id)arg1;
+ (void)setTheSystemApp:(int)arg1 identifier:(id)arg2;
+ (double)backgroundTimeRemaining;

- (void)setVisibility:(int)arg1;
- (int)visibility;
- (void)_sendMessageType:(int)arg1 withMessage:(id)arg2 withReplyHandler:(id)arg3 waitForReply:(bool)arg4;
- (long long)exitStatus;
- (id)initWithPID:(int)arg1 bundlePath:(id)arg2 visibility:(int)arg3 workspaceLocked:(bool)arg4 queue:(id)arg5;
- (bool)supportsTaskSuspension;
- (void)setTerminationReason:(long long)arg1;
- (void)setConnectedToExternalAccessories:(bool)arg1;
- (void)setNowPlayingWithAudio:(bool)arg1;
- (void)setRecordingAudio:(bool)arg1;
- (void)setWorkspaceLocked:(bool)arg1;
- (void)setTaskState:(int)arg1;
- (void)queue_connectionWasCreated;
- (void)queue_connectionWasInterrupted;
- (void)queue_handleMessage:(id)arg1;
- (bool)recordingAudio;
- (bool)nowPlayingWithAudio;
- (bool)connectedToExternalAccessories;
- (bool)workspaceLocked;
- (void)setExitStatus:(long long)arg1;
- (void)_handleDebuggingStateChanged:(id)arg1;
- (void)_handleExpirationWarning:(id)arg1;
- (void)_handleSuspendedStateChanged:(id)arg1;
- (void)_sendMessageType:(int)arg1 withMessage:(id)arg2;
- (int)taskState;
- (double)backgroundTimeRemaining;
- (void)setSupportsTaskSuspension:(bool)arg1;
- (id)delegate;
- (id)init;
- (void)setDelegate:(NSObject*)arg1;
- (void)dealloc;
- (long long)terminationReason;
@end
