//
//  ViewController.h
//  CutomRefreshController
//
//  Created by Gurinder Batth on 16/10/16.
//  Copyright © 2016 Gurinder Batth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) IBOutlet UITableView * tableView;

@property(nonatomic, strong) NSMutableArray * arrayData;

@property(nonatomic, strong) UIRefreshControl * refreshControl;

@property(nonatomic, strong) UIView * customView;

@property(nonatomic, strong) NSMutableArray<__kindof UILabel *> * arrayLabel;

@property BOOL isAnimating;

@property(nonatomic) int currentColorIndex;
@property(nonatomic) int currentLabelIndex;

@property(nonatomic, strong) NSTimer * timer;

@end

