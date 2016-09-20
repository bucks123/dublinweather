//
//  LESWeatherViewController.m
//  DublinWeatherApp
//
//  Created by Kieran Buckley on 19/09/2016.
//  Copyright © 2016 LesApps. All rights reserved.
//

#import "LESWeatherViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "LESWeatherAPI.h"
#import "LESWeatherCondition.h"
#import "LESWeatherHTTPClient.h"
//#import "LESWeatherHeaderView.m"

@interface LESWeatherViewController ()

@property (nonatomic,strong)UIImageView *backgoundImageView;
@property (nonatomic,strong)UIImageView *blurredImageView;
@property (nonatomic,assign)CGFloat screenHeight;
@property (nonatomic,strong)LESWeatherCondition *currentCondition;

//UI properties to be updated
@property (nonatomic,weak) IBOutlet UILabel *conditionsLabel;
@property (nonatomic,weak) IBOutlet UILabel *temperatureLabel;
@property (nonatomic,weak) IBOutlet UILabel *cityLabel;
@property (nonatomic,weak) IBOutlet UILabel *hiloLabel;
@property (nonatomic,weak) IBOutlet UIImageView *iconView;
@property (nonatomic,weak) IBOutlet UIView *headerView;

@end

static NSDateFormatter *sHourlyDateFormatter = nil;
static NSDateFormatter *sDailyDateFormatter = nil;

@implementation LESWeatherViewController

-(id)init{
    
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    self.tableView.tableHeaderView = self.headerView;
    
    UIImage *background = [UIImage imageNamed:[NSString stringWithFormat:@"londonbridge"]];
    self.backgoundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgoundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView.tableHeaderView sendSubviewToBack:self.backgoundImageView];
    
    //set blurred background image
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.tableView setBackgroundView:self.blurredImageView];
    
    [LESWeatherAPI sharedInstance]; //findCurrentLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentChangedNotification:) name:kWeatherAPIContentUpdateNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIView *headerView = self.tableView.tableHeaderView;
    
    if (headerView) {
        CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height);
        
        // Only adjust frame if needed to avoid infinite loop
        if (!CGRectEqualToRect(self.tableView.tableHeaderView.frame, rect)) {
            headerView.frame = rect;
            
            // This will apply the new header size and trigger another
            // call of layoutSubviews
            self.tableView.tableHeaderView = headerView;
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateUIForNewWeatherData{
    
    self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",self.currentCondition.temperature.floatValue];
    self.conditionsLabel.text = [self.currentCondition.condition capitalizedString];
    self.cityLabel.text = [ self.currentCondition.locationName capitalizedString];
    self.iconView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.currentCondition imageName]]];
    self.hiloLabel.text = [NSString stringWithFormat:@"Hi %.0f° / Lo %.0f°", self.currentCondition.tempHigh.floatValue, self.currentCondition.tempLow.floatValue];
}

-(void)contentChangedNotification:(NSNotification*)notification{
    self.currentCondition = [[LESWeatherAPI sharedInstance] currentCondition];
    [self updateUIForNewWeatherData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return MIN([[LESWeatherAPI sharedInstance].hourlyForecast count],6) + 1;
    }
    return MIN([[LESWeatherAPI sharedInstance].dailyForecast count], 6) + 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        }else{
            LESWeatherCondition *weather = [LESWeatherAPI sharedInstance].hourlyForecast[indexPath.row -1];
            [self configureHourlyCell:cell weather:weather];
        }
    }else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        }else{
            LESWeatherCondition *weather = [LESWeatherAPI sharedInstance].dailyForecast[indexPath.row -1];
            [self configureDailyCell:cell weather:weather];
        }
    }
    
    return cell;
}

-(void)configureHeaderCell:(UITableViewCell*)cell title:(NSString*)title{
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

-(void)configureHourlyCell:(UITableViewCell*)cell weather:(LESWeatherCondition*)weather{
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    if (sHourlyDateFormatter == nil) {
        sHourlyDateFormatter = [[NSDateFormatter alloc]init];
        sHourlyDateFormatter.dateFormat = @"h a";
    }
    
    cell.textLabel.text = [sHourlyDateFormatter stringFromDate:weather.date];;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°", weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)configureDailyCell:(UITableViewCell*)cell weather:(LESWeatherCondition*)weather{
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    
    if (sDailyDateFormatter == nil) {
        sDailyDateFormatter = [[NSDateFormatter alloc]init];
        sDailyDateFormatter.dateFormat = @"EEEE";
    }
    
    cell.textLabel.text = [sDailyDateFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°", weather.tempHigh.floatValue, weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;

}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    
    self.blurredImageView.alpha = percent;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
