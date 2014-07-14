#import "AudioHelper.h"
#import "Constants.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioHelper()
@property (nonatomic, strong) id delegate;
@end

@implementation AudioHelper

AVAudioPlayer *audioPlayerPulse;
AVAudioPlayer *audioPlayerFinished;

- (id)initWithDelegate:(id)delegate
{
    self = [super init];

    if (self)
    {
        self.delegate = delegate;
    }

    return self;
}

- (void)prepareAudioFiles
{
    // TODO: handle error

    // Countdown up ping sounds
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: @"countdown-pulse-2" ofType: @"wav"];
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    audioPlayerPulse = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];

    // "Go" ping sound
    soundFilePath = [[NSBundle mainBundle] pathForResource: @"countdown-finished-2" ofType: @"wav"];
    fileUrl = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    audioPlayerFinished = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];

    [audioPlayerFinished setDelegate:self];
    [audioPlayerPulse setDelegate:self];

    [audioPlayerFinished prepareToPlay];
    [audioPlayerPulse prepareToPlay];
}

- (void)stopPlayingPulse
{
    [audioPlayerPulse stop];
}

- (void)stopPlayingFinished
{
    [audioPlayerFinished stop];
}

- (void)playPulse
{
    [audioPlayerPulse play];
}

- (void)playFinished
{
    [audioPlayerFinished play];
}

- (BOOL)isPlaying
{
    return ([audioPlayerPulse isPlaying] || [audioPlayerFinished isPlaying]);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%@ has error: %@", player, error);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSString *audioType = kAudioPulse;
    
    if (player == audioPlayerFinished)
        audioType = kAudioFinished;

    [self.delegate performSelector:@selector(didPlayAudioOfType:) withObject:audioType];
}

+ (void)configureAudio
{
    [self playAudioEvenWhenMuted];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    NSError *error;
    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if(!success)
    {
        NSLog(@"error doing outputaudioportoverride - %@", [error localizedDescription]);
    }
}

+ (void)playAudioEvenWhenMuted
{
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    NSError *audioPortErr  = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&audioPortErr];

    if(setCategoryErr || activationErr || audioPortErr)
    {
        NSLog(@"%@ Error: Could not activate silence mode. %@ %@ %@", self, setCategoryErr, activationErr, audioPortErr);
    }

    UInt32 doChangeDefaultRoute = 1;

    AudioSessionSetProperty (
                             kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                             sizeof (doChangeDefaultRoute),
                             &doChangeDefaultRoute
                             );

//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
}
@end
