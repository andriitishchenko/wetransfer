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
//#import "GVRWidgetView.h"

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
    AVPlayer* _player;
    
    NSMutableArray*_vr;
}

-(NSURL*)getURLForIndex:(NSInteger)index{
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:_videoSource[index] ofType:@"mp4" ];
    return [NSURL fileURLWithPath:moviePath];
}


-(void)playNext{
//     [self.video stop];
//    [self.video removeFromSuperview];
    GVRVideoView* vr = _vr[_playIndex];
    
    
    [vr setHidesTransitionView:YES];
    [vr setDisplayMode:kGVRWidgetDisplayModeFullscreenVR];
    vr.enableInfoButton = NO;
    vr.enableFullscreenButton = NO;
    vr.enableCardboardButton = YES;
    vr.enableTouchTracking = NO;
    [vr setHidden:NO];
    [self.view bringSubviewToFront:vr];
    [vr play];
    
    
    SEL selector = NSSelectorFromString(@"fullscreenController");
    if ([self.video respondsToSelector:selector]) {
        @try {
            UIViewController*ovr =  [vr performSelector:selector];
            id v = [ovr performSelector:NSSelectorFromString(@"overlayView")];
            UIButton*b = [v performSelector: NSSelectorFromString(@"backButton")];
            [b setHidden:YES];
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }

    
    
    
    
//    _playIndex++;
    if (_playIndex > 2) {
        _playIndex = 0;
    }
//    NSURL *url = [self getURLForIndex:_playIndex];
//    [self play3d:url];
//    if (_playIndex == 1) {
//        [self play3d:url];
//    }
//    else
//    {
//        [self play2d:url];
//    }
}

//-(void)play2d:(NSURL*)url
//{
//    // First create an AVPlayerItem
//    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithURL:url];
//    
//    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
//    if (!_player) {
//    _player = [[AVPlayer alloc] initWithPlayerItem:playerItem] ;
//        AVPlayerLayer *layer = [AVPlayerLayer layer];
//        [layer setPlayer:_player];
//        [layer setFrame:self.view.bounds];
//        [layer setBackgroundColor:[UIColor clearColor].CGColor];
//        [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//        [self.view.layer addSublayer:layer];
//    }
//    else{
//        [_player replaceCurrentItemWithPlayerItem:playerItem];
//    }
//    [_player play];
//}

-(void)play3d:(NSURL*)url {
    [_video loadFromUrl:url
//                      ofType:kGVRVideoTypeMono];
//                 ofType:kGVRVideoTypeSphericalV2];
    ofType:kGVRVideoTypeStereoOverUnder];
    
    [_video setHidden:NO];
    _video.delegate = self;
    [_video setHidesTransitionView:YES];
    
    [_video setDisplayMode:kGVRWidgetDisplayModeFullscreenVR];
    _video.enableInfoButton = NO;
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
//    _videoSource  = @[@"Part_1",@"Part_2_360",@"Part_3"];
//    _videoSource  = @[@"PM_VR_SBORKA_170426_1"];
    
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Part_1" ofType:@"mp4" ];
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    [self play3d:url];
    
    
    
//    _vr = [NSMutableArray new];
//    for(NSInteger i = 0; i<3; i++){
//        
//        GVRVideoView* vr = [[GVRVideoView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:vr];
//        [vr setHidden:YES];
//        
//        vr.tag = 10+i;
//        NSURL *url = [self getURLForIndex:i];
//        if (i==1) {
//            [vr loadFromUrl:url
//                     ofType:kGVRVideoTypeMono];
////                             ofType:kGVRVideoTypeSphericalV2];
//            //    ofType:kGVRVideoTypeStereoOverUnder];
//        }
//        else{
//            [vr loadFromUrl:url
//                     ofType:kGVRVideoTypeMono];
//        }
//        
//        
////        [vr setHidden:NO];
//        vr.delegate = self;
////        [vr setHidesTransitionView:YES];        
////        [vr setDisplayMode:kGVRWidgetDisplayModeFullscreenVR];
////        vr.enableInfoButton = NO;
////        vr.enableFullscreenButton = NO;
////        vr.enableCardboardButton = YES;
////        vr.enableTouchTracking = NO;
////        
////        SEL selector = NSSelectorFromString(@"fullscreenController");
////        if ([vr respondsToSelector:selector]) {
////            @try {
////                UIViewController*ovr =  [vr performSelector:selector];
////                id v = [ovr performSelector:NSSelectorFromString(@"overlayView")];
////                UIButton*b = [v performSelector: NSSelectorFromString(@"backButton")];
////                [b setHidden:YES];
////                
////            } @catch (NSException *exception) {
////                
////            } @finally {
////                
////            }
////        }
//        [_vr addObject:vr];
//    }
    
    
    _playIndex = 0;
//    [_video setHidden:YES];
//    [self playNext];
    
}

//-(void)itemDidFinishPlaying:(NSNotification *) notification {
//    // Will be called when AVPlayer finishes playing playerItem
//    [self playNext];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GVRVideoViewDelegate

- (void)widgetViewDidTap:(GVRWidgetView *)widgetView {
//    if (_isPaused) {
//        [_video play];
//    } else {
//        [_video pause];
//    }
//    _isPaused = !_isPaused;
}

- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
    NSLog(@"Finished loading video");
//    if(widgetView.tag-10 == _playIndex){
//        if (_isPaused == YES) {
//            [self playNext];
//            _isPaused = NO;
//        }
//        
//    }
//    [_video setHidden:NO];
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
    // Loop the video when it reaches the end.
    
    NSLog(@"%f, %f",position, videoView.duration);
    if (position == videoView.duration) {
        [_video seekTo:0];
        [_video play];
//        [_video stop];
        
        
//            SEL selector = NSSelectorFromString(@"fullscreenController");
//            if ([_video respondsToSelector:selector]) {
//                @try {
//                    UIViewController*ovr =  [_video performSelector:selector];
//                    id v = [ovr performSelector:NSSelectorFromString(@"overlayView")];
//                    UIButton*b = [v performSelector: NSSelectorFromString(@"backButton")];
////                    [b setHidden:YES];
//
//                    [b sendActionsForControlEvents:UIControlEventTouchUpInside];
//                    
//                } @catch (NSException *exception) {
//        
//                } @finally {
//                    
//                }
//            }
        
        
        
        
//        [_video setDisplayMode:kGVRWidgetDisplayModeEmbedded];
//        [_video setHidden:YES];
        
//        [_video seekTo:0];
//        [_video play];
    }
    else{
      //r  _isPaused == NO;
    }
}
@end
