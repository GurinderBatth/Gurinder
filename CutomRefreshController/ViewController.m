//
//  ViewController.m
//  CutomRefreshController
//
//  Created by Gurinder Batth on 16/10/16.
//  Copyright © 2016 Gurinder Batth. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.arrayLabel = [NSMutableArray new];
    self.currentColorIndex = 0;
    self.currentLabelIndex = 0;
    self.isAnimating = NO;
    
    self.arrayData = [NSMutableArray arrayWithObjects:@"One",@"Two",@"Three",@"Four",@"Five", nil];
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor clearColor];
    [self.tableView addSubview:self.refreshControl];
    [self loadCustomFunction];
    
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.arrayData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"Cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.arrayData objectAtIndex:indexPath.row];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)loadCustomFunction
{
    NSArray<__kindof UIView *> * refreshContents = [[NSBundle mainBundle]loadNibNamed:@"RefreshContents" owner:self options:nil];
    
    
    NSLog(@"Cutsom View SubViews %@",refreshContents);

    
    self.customView = refreshContents[0];
    self.customView.frame = self.refreshControl.bounds;
    
    NSLog(@"Cutsom View SubViews %lu",(unsigned long)self.customView.subviews.count);
    
    for (int i = 0; i < self.customView.subviews.count; ++i) {
        [self.arrayLabel  addObject:[self.customView viewWithTag:(i + 1)]];
    }
    
    [self.refreshControl addSubview:self.customView];
    
}


-(void)animateRefreshingStep1
{
    self.isAnimating = YES;
    
    NSLog(@"Array Label %@",self.arrayLabel);

    
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        
        NSLog(@"Array Label %@",self.arrayLabel);

        self.arrayLabel[self.currentLabelIndex].transform = CGAffineTransformMakeRotation(M_PI_4);
        self.arrayLabel[self.currentLabelIndex].textColor = self.getNextColor;
        
        NSLog(@"Array %@",self.arrayLabel);
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            
            self.arrayLabel[self.currentLabelIndex].transform = CGAffineTransformIdentity;
            [self.arrayLabel[self.currentLabelIndex] setTextColor:[UIColor blackColor]];
            
        } completion:^(BOOL finished) {
            ++self.currentLabelIndex;
            
            if (self.currentLabelIndex < self.arrayLabel.count) {
                [self animateRefreshingStep1];
            }
            else{
                [self animateRefreshStep2];
            }
            
        }];
        
    }];
}

-(void)animateRefreshStep2
{
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.arrayLabel[0].transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.arrayLabel[1].transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.arrayLabel[2].transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.arrayLabel[3].transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.arrayLabel[4].transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.arrayLabel[5].transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.arrayLabel[6].transform = CGAffineTransformMakeScale(1.5, 1.5);
       // self.arrayLabel[7].transform = CGAffineTransformMakeScale(1.5, 1.5);

        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.arrayLabel[0].transform = CGAffineTransformIdentity;
            self.arrayLabel[1].transform = CGAffineTransformIdentity;
            self.arrayLabel[2].transform = CGAffineTransformIdentity;
            self.arrayLabel[3].transform = CGAffineTransformIdentity;
            self.arrayLabel[4].transform = CGAffineTransformIdentity;
            self.arrayLabel[5].transform = CGAffineTransformIdentity;
            self.arrayLabel[6].transform = CGAffineTransformIdentity;
           // self.arrayLabel[7].transform = CGAffineTransformIdentity;

            
        } completion:^(BOOL finished) {
            
            if (self.refreshControl.refreshing) {
                self.currentLabelIndex = 0;
                [self animateRefreshingStep1];
            }
            else{
                self.isAnimating = NO;
                self.currentLabelIndex= 0;
                
                for (int i = 0;  i < self.arrayLabel.count; i++) {
                    self.arrayLabel[i].textColor = [UIColor blackColor];
                    self.arrayLabel[i].transform = CGAffineTransformIdentity;
                }
            }
            
        }];
        
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.refreshControl isRefreshing]) {
        if (!self.isAnimating) {
            [self doSomething];
            [self animateRefreshingStep1];
        }
    }
}

-(UIColor *)getNextColor
{
    NSArray * colorArray = [NSArray arrayWithObjects:[UIColor magentaColor],[UIColor brownColor],[UIColor yellowColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor orangeColor], nil];
    
    if (self.currentColorIndex == colorArray.count) {
        self.currentColorIndex = 0;
    }
    UIColor * returnColor = colorArray[self.currentColorIndex];
    ++self.currentColorIndex;
    
    return returnColor;
}


-(void)doSomething
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(endOfWork) userInfo:nil repeats:YES];
}

-(void)endOfWork{
    [self.refreshControl endRefreshing];
    [self.timer invalidate];
    self.timer = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
