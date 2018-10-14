//
//  EventDetailViewController.m
//  TigerEvent
//
//  Created by Siyang Liu on 2018/10/13.
//  Copyright © 2018 SiyangLiu. All rights reserved.
//

#import "EventDetailViewController.h"
#import <objc/message.h>
#import "NSDate+GetDescription.h"
#import "ImageCell.h"
#import <TigerEvent-Swift.h>

@interface WGProperty : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *desc;

- (instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)desc;
+ (instancetype)propertyWithTitle:(NSString *)title andDescription:(NSString *)desc;

@end

@implementation WGProperty

- (instancetype)initWithTitle:(NSString *)title andDescription:(NSString *)desc {
    if (self = [super init]) {
        self.title = title;
        self.desc = desc;
    }
    return self;
}

+ (instancetype)propertyWithTitle:(NSString *)title andDescription:(NSString *)desc {
    return [[self alloc] initWithTitle:title andDescription:desc];
}


@end


@interface EventDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WGProperty *> *properties;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (NSMutableArray<WGProperty *> *)properties {
    if (_properties == nil) {
        /*
         var eventId: String!
         var title: String!
         var desc: String!
         var department: NSNumber!
         var eventTime: Date!
         var imageUrl: String!
         var submitTime: Date!
         var location: String!
         */
        
        NSDictionary *mapping = @{ @"title": @"Title",
                                   @"desc": @"Description",
                                   @"department": @"Department",
                                   @"eventTime": @"Event Time",
                                   @"submitTime": @"Submit Time",
                                   @"location": @"Location"
                                  };
        
        _properties = [NSMutableArray array];
        Class clz = [Event class];
        unsigned int count;
        Ivar *ivars = class_copyIvarList(clz, &count);
        for (int i = 0; i < count; i++) {
            NSString *ivarStr = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
            if ([ivarStr isEqualToString:@"eventId"] || [ivarStr isEqualToString:@"imageUrl"]) {
                continue;
            }
            id value = [self.event valueForKey:ivarStr];
            if (value == nil) {
                continue;
            }
//            if ([ivarStr isEqualToString:@"department"]) {
//                NSInteger departNo = [value integerValue];
//                value = [NSString stringWithFormat:@"%ld", departNo];
//            } else
                if ([ivarStr isEqualToString:@"eventTime"] || [ivarStr isEqualToString:@"submitTime"]) {
                value = [value getDescription];
            }
            WGProperty *property = [[WGProperty alloc] initWithTitle:mapping[ivarStr] ?: ivarStr andDescription:value];
            [_properties addObject:property];
            
        }
    }
    return _properties;
}

- (void)setupUI {
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableView Delegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 200;
//}


#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.properties.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId1 = @"ContentCell";
    static NSString *cellId2 = @"ImageCell";
//    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1 forIndexPath:indexPath];
        WGProperty *property = self.properties[indexPath.row];
        cell.textLabel.text = property.title;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];;
        cell.detailTextLabel.text = property.desc;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        
        return cell;
//    } else {
//        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2 forIndexPath:indexPath];
//        __weak typeof(self) weakSeaf = self;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSURL *url = [NSURL URLWithString:weakSeaf.event.imageUrl];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            UIImage *image = [UIImage imageWithData:data];
//            // 做保护处理
//            BOOL isSuccess = YES;
//            if (image == nil) {
//                weakSeaf.event.imageUrl = nil;
//                isSuccess = NO;
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (isSuccess) {
//                    cell.imageView.image = image;
//                } else {
//                    [weakSeaf.tableView reloadData];
//                }
//            });
//        });
//        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.event.imageUrl == nil ? 0 : 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.event.imageUrl == nil) {
        return nil;
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    __weak typeof(self) weakSeaf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:weakSeaf.event.imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        // 做保护处理
        BOOL isSuccess = YES;
        if (image == nil) {
            weakSeaf.event.imageUrl = nil;
            isSuccess = NO;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                imageView.image = image;
            } else {
                [weakSeaf.tableView reloadData];
            }
        });
    });
    return imageView;
}

- (IBAction)addToCalendarButtonClick:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"AddToCalendar" bundle:nil];
    AddCalendarViewController *vc = [storyboard instantiateInitialViewController];
    vc.event = self.event;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
