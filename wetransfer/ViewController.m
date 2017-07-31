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

@class GVROverlayView;
@interface ViewController ()<GVRVideoViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet GVRVideoView *video;
@end

@implementation ViewController
{
    BOOL _isPaused;
    NSArray*_videoSource;
    NSInteger _playIndex;
    NSInteger _playVideosCount;
}

-(void)play3d:(NSURL*)url {
    [_video loadFromUrl:url
                      ofType:kGVRVideoTypeMono];
    
    [_video setHidden:NO];
    _video.delegate = self;
    
    [_video setDisplayMode:kGVRWidgetDisplayModeFullscreenVR];
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
            
            [v addSubview:self.restartButton];
            
            NSLayoutConstraint *constraintVertical = [NSLayoutConstraint constraintWithItem:
                                                      self.restartButton
                  attribute:NSLayoutAttributeCenterX
                  relatedBy:NSLayoutRelationEqual
                     toItem:v
                  attribute:NSLayoutAttributeCenterX
                 multiplier:1.0f
                   constant:0.0f];
            
            NSLayoutConstraint *constraintHorizontal = [NSLayoutConstraint constraintWithItem:
                self.restartButton
                attribute:NSLayoutAttributeCenterY
                relatedBy:NSLayoutRelationEqual
                   toItem:v
                attribute:NSLayoutAttributeCenterY
               multiplier:1.0f
                 constant:0.0f];

            [v addConstraint:constraintVertical];
            [v addConstraint:constraintHorizontal];
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.restartButton removeFromSuperview];
    self.restartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.restartButton setHidden:YES];
    self.restartButton.clipsToBounds = YES;
    self.restartButton.layer.cornerRadius = CGRectGetWidth(self.restartButton.bounds)/2.0f;
    
    _isPaused = YES;
    
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"PM_VR_SBORKA_170609" ofType:@"mp4" ];
    NSURL*url = [NSURL fileURLWithPath:moviePath];
    [self play3d:url];
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
        [videoView seekTo:0];
        [self.restartButton setHidden:NO];
    }
}
- (IBAction)restartButton_Click:(id)sender {
    [_video seekTo:0];
    [_video play];
    [self.restartButton setHidden:YES];
}
@end
