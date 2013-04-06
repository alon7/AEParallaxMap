//
//  ViewController.m
//  AEParallaxMap
//
//  Created by Alon Ezer on 4/7/13.
//  Copyright (c) 2013 alon7. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *items;
@end

#define kRevealOffset 100

static CGRect MapOriginalFrame;
static CGRect MapFullFrame;
static CGFloat offset = -50.0f;
BOOL isMaximizing;

@implementation ViewController
@synthesize items;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    items = [[NSArray alloc] initWithObjects:@"Item No. 1", @"Item No. 2", @"Item No. 3", @"Item No. 4", @"Item No. 5", @"Item No. 6",@"Item No. 7", @"Item No. 8", @"Item No. 9", @"Item No. 10", @"Item No. 11", @"Item No. 12", nil];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 200.0)];
    
    self._tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self._tableView.delegate = self;
    self._tableView.dataSource = self;
    [self.view addSubview:self._tableView];
    self._tableView.tableHeaderView = tableHeaderView;
    
    MapOriginalFrame = CGRectMake(0.0, offset, 320, 239);
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    MapFullFrame = CGRectMake(0, 0, size.width, size.height);
    
    isMaximizing = NO;
    
    self._mapView = [[MKMapView alloc] initWithFrame:MapOriginalFrame];
    [self.view insertSubview:self._mapView aboveSubview:self._tableView];
    
    self._tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTap:)];
    [self._tapGesture setCancelsTouchesInView:NO];
    self._tapGesture.numberOfTapsRequired =1 ;
    self._tapGesture.numberOfTouchesRequired =1;
    [self._mapView addGestureRecognizer:self._tapGesture];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) mapTap:(UITapGestureRecognizer* )recognizer
{
    if (CGRectEqualToRect(self._mapView.frame, MapFullFrame)) {
        [self minimizeMapView];
    } else {
        [self maximizeMapView];
    }
}

- (void) maximizeMapView
{
    isMaximizing = YES;
    [self._mapView removeGestureRecognizer:self._tapGesture];
    [UIView animateWithDuration:0.3 animations:^{
        self._mapView.frame = MapFullFrame;
    } completion:^(BOOL finished) {
        isMaximizing = NO;
        self._closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * closeImage = [UIImage imageNamed:@"close-button"];
        [self._closeButton setImage:closeImage forState:UIControlStateNormal];
        [self._closeButton setFrame:CGRectMake(0, 0, closeImage.size.width, closeImage.size.height)];
        [self._closeButton addTarget:self action:@selector(minimizeMapView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self._closeButton];
    }];
}

- (void) minimizeMapView
{
    isMaximizing = NO;
    [self._mapView addGestureRecognizer:self._tapGesture];
    [UIView animateWithDuration:0.3 animations:^{
        [self._closeButton removeFromSuperview];
        self._mapView.frame = MapOriginalFrame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    
    if (CGRectEqualToRect(self._mapView.frame, MapFullFrame)) {
        
    } else {
        CGRect mapFrame = self._mapView.frame;
        if (scrollOffset < 0) {
            if (!isMaximizing && scrollOffset < - 100) {
                [self maximizeMapView];
                return;
            }
            mapFrame.origin.y = offset - ((scrollOffset/2));
        } else {
            mapFrame.origin.y = offset - scrollOffset;
        }
        self._mapView.frame = mapFrame;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}

@end
