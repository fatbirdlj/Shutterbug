//
//  ImageViewController.m
//  Shutterbug
//
//  Created by 刘江 on 2017/4/5.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation ImageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
}

#pragma mark - Properties

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (void)setImageURL:(NSURL *)imageURL{
    _imageURL = imageURL;
    [self downloadPhoto];
}

- (void)setImage:(UIImage *)image{
    self.imageView.image = image;
    //[self.imageView sizeToFit];
    
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.scrollView.contentSize = image ? image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (UIImage *)image{
    return  self.imageView.image;
}

- (void)setScrollView:(UIScrollView *)scrollView{
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2;
    _scrollView.delegate = self;
    
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

#pragma mark - DownloadPhoto

- (void)downloadPhoto{
    self.image = nil;
    [self.spinner startAnimating];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if ([request.URL isEqual:self.imageURL]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }
        }
    }];
    [task resume];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


@end
