#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioHelper : NSObject<AVAudioPlayerDelegate>
+ (void)configureAudio;

- (id)initWithDelegate:(id)delegate;
- (void)prepareAudioFiles;
- (BOOL)isPlaying;
- (void)stopPlayingFinished;
- (void)stopPlayingPulse;
- (void)playFinished;
- (void)playPulse;
@end
