//
//  EventsViewController.m
//  TigerEvent
//
//  Created by Siyang Liu on 2018/10/13.
//  Copyright © 2018 SiyangLiu. All rights reserved.
//

#import "EventsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "NSDate+GetDescription.h"
#import <TigerEvent-Swift.h>
#import "EventDetailViewController.h"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray <Event *> *events;

@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_background"]];
    self.tableView.backgroundView = imageView;
    self.tableView.backgroundColor = UIColor.clearColor;
    
    
    [self fetchDate];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"EventCell";
    Event *event = self.events[indexPath.row];
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EventCell alloc] init];
    }
    cell.titleTextLabel.text = event.title;
    cell.eventTimeLabel.text = [event.eventTime getDescription];
    return cell;
}

- (void)fetchDate {
    [[AFHTTPSessionManager manager] GET:NetworkUrl.GET_ALL_EVENTS parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject;
        if (dataArray == nil) {
            return;
        }
        self.events = [Event mj_objectArrayWithKeyValuesArray:dataArray];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowEventDetail"]) {
        EventDetailViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        vc.event = self.events[indexPath.row];
    }
}

@end
