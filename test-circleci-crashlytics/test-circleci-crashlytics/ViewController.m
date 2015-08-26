//
//  ViewController.m
//  test-circleci-crashlytics
//
//  Created by Nik Osipov on 26/8/15.
//  Copyright (c) 2015 SafeChats Pte. Ltd. All rights reserved.
//

#import "ViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateImageView];

    [super viewDidAppear:animated];
}

- (IBAction)refreshButton:(id)sender {
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearMemory];

    [self.imageView setImage:nil];
    
    [self updateImageView];
}

- (void)updateImageView {
    int randomNumber = arc4random() % 100 + 1;
    
    NSURL *imageURL = [[NSURL alloc]
                       initWithString:[NSString stringWithFormat:@"http://loremflickr.com/320/568/landscape?%02d", randomNumber]];
    
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = self.imageView;
    
    [self.imageView sd_setImageWithURL:imageURL
                      placeholderImage:nil
                               options:SDWebImageProgressiveDownload
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  if (!activityIndicator) {
                                      [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                      activityIndicator.center = weakImageView.center;
                                      [activityIndicator startAnimating];
                                  }
                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [activityIndicator removeFromSuperview];
                                 activityIndicator = nil;
                             }];
}

@end
