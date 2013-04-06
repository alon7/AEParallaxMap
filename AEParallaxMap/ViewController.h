//
//  ViewController.h
//  AEParallaxMap
//
//  Created by Alon Ezer on 4/7/13.
//  Copyright (c) 2013 alon7. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate,
                                                UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) MKMapView *_mapView;
@property (nonatomic, strong) UITableView *_tableView;
@property (nonatomic, strong) UIButton *_closeButton;
@property (nonatomic, strong) UITapGestureRecognizer *_tapGesture;
@end
