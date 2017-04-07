//
//  FlickerFetcherViewController.m
//  Shutterbug
//
//  Created by 刘江 on 2017/4/5.
//  Copyright © 2017年 Flicker. All rights reserved.
//

#import "FlickerFetcherViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface FlickerFetcherViewController ()
@property (nonatomic,strong) NSArray *photos;
@end

@implementation FlickerFetcherViewController

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - Lifecycle Event

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchPhotos];
}

#pragma mark - Fetch photos from Flickr

- (IBAction)fetchPhotos{
    
    [self.refreshControl beginRefreshing];
    
    NSURL *query = [FlickrFetcher URLForRecentGeoreferencedPhotos];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:query];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_PHOTO_PATH];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = photos;
        });
        
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"Flickr Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Display Photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    ImageViewController *ivc = segue.destinationViewController;
                    NSDictionary *photo = self.photos[indexPath.row];
                    ivc.title = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
                    ivc.imageURL = [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
                }
            }
        }
    }
}



@end
