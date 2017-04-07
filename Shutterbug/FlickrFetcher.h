//
//  FlickrFetcher.h
//  Shutterbug
//
//  Created by 刘江 on 2017/4/5.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKR_PHOTO_PATH @"photos.photo"
#define FLICKR_PHOTO_TITLE @"title"
#define FLICKR_PHOTO_DESCRIPTION @"description._content"

typedef NS_ENUM(NSInteger,FlickrPhotoFormat){
    FlickrPhotoFormatSquare = 1,    // thumbnail
    FlickrPhotoFormatLarge = 2,     // normal size
    FlickrPhotoFormatOriginal = 64  // high resolution
};

@interface FlickrFetcher : NSObject

+ (NSURL *)URLForRecentGeoreferencedPhotos;

+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

@end
