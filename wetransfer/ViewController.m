//
//  ViewController.m
//  wetransfer
//
//  Created by andrux on 4/24/17.
//  Copyright © 2017 atfop. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "GVRVideoView.h"
#import "GVRWidgetView.h"

//@class GVROverlayViewController;
@class GVROverlayView;
@interface ViewController ()<GVRVideoViewDelegate>
@property (weak, nonatomic) IBOutlet GVRVideoView *video;
@end

@implementation ViewController
{
    BOOL _isPaused;
    NSArray*_videoSource;
    NSInteger _playIndex;
    NSInteger _playVideosCount;
}

-(NSURL*)getURLForIndex:(NSInteger)index{
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:_videoSource[index] ofType:@"mp4" ];
    return [NSURL fileURLWithPath:moviePath];
}


-(void)playNext{
    _playIndex++;
    if (_playIndex >= _playVideosCount) {
        _playIndex = 0;
    }
    NSLog(@"PLAY INDEX %ld",(long)_playIndex);
    NSURL*url = [self getURLForIndex:_playIndex];
    [self play3d:url];
    
    SEL selector = NSSelectorFromString(@"fullscreenController");
    if ([self.video respondsToSelector:selector]) {
        @try {
            UIViewController*ovr =  [self.video performSelector:selector];
            id v = [ovr performSelector:NSSelectorFromString(@"overlayView")];
            UIButton*b = [v performSelector: NSSelectorFromString(@"backButton")];
            [b setHidden:YES];
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}


-(void)play3d:(NSURL*)url {
    [_video loadFromUrl:url
                      ofType:kGVRVideoTypeMono];
//                 ofType:kGVRVideoTypeSphericalV2];
//    ofType:kGVRVideoTypeStereoOverUnder];
    
    [_video setHidden:NO];
    _video.delegate = self;
//    [_video setHidesTransitionView:YES];
    
    [_video setDisplayMode:kGVRWidgetDisplayModeFullscreenVR];
//    _video.enableInfoButton = NO;
    _video.enableFullscreenButton = NO;
    _video.enableCardboardButton = YES;
    _video.enableTouchTracking = NO;

    SEL selector = NSSelectorFromString(@"fullscreenController");
    if ([_video respondsToSelector:selector]) {
        @try {
            UIViewController*ovr =  [_video performSelector:selector];
            id v = [ovr performSelector:NSSelectorFromString(@"overlayView")];
            UIButton*b = [v performSelector: NSSelectorFromString(@"backButton")];
            [b setHidden:YES];
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPaused = YES;
    _videoSource  = @[@"PM_VR_SBORKA_170427_v2"];
//    _videoSource  = @[@"PM_VR_SBORKA_170426_PART_ONE_v3",@"Part_2_360",@"PM_VR_SBORKA_170426_PART_THREE_v3"];
    _playIndex = -1;
    _playVideosCount = [_videoSource count];
    [self playNext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GVRVideoViewDelegate

- (void)widgetViewDidTap:(GVRWidgetView *)widgetView {
    if (_isPaused) {
        [_video play];
    } else {
        [_video pause];
    }
    _isPaused = !_isPaused;
}

- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
    NSLog(@"Finished loading video");
    [_video play];
    _isPaused = NO;
}

- (void)widgetView:(GVRWidgetView *)widgetView
didFailToLoadContent:(id)content
  withErrorMessage:(NSString *)errorMessage {
    NSLog(@"Failed to load video: %@", errorMessage);
    _isPaused = YES;
}

- (void)videoView:(GVRVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
    if (position == videoView.duration) {
        [self playNext];
    }
}
@end
