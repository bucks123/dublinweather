//
//  LESViewController.m
//  DublinWeatherApp
//
//  Created by kieran buckley on 16/09/2016.
//  Copyright (c) 2014 LesApps. All rights reserved.
//

#import "LESViewController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "LESWeatherAPI.h"
#import "LESWeatherCondition.h"
#import "LESUtils.h"
#import "LESWeatherHTTPClient.h"

@interface LESViewController ()

@property (nonatomic,strong)UIImageView *backgoundImageView;
@property (nonatomic,strong)UIImageView *blurredImageView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)CGFloat screenHeight;
@property (nonatomic,strong)LESWeatherCondition *currentCondition;

    //UI properties to be updated
@property (nonatomic,strong) UILabel *conditionsLabel;
@property (nonatomic,strong) UILabel *temperatureLabel;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UILabel *hiloLabel;
@property (nonatomic,strong) UIImageView *iconView;

@end

static NSDateFormatter *sHourlyDateFormatter = nil;
static NSDateFormatter *sDailyDateFormatter = nil;

@implementation LESViewController

-(id)init{
    
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
        //set normal background image - TODO use flickr to set background image based on location
    UIImage *background = [UIImage imageNamed:[NSString stringWithFormat:@"londonbridge"]];
    self.backgoundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgoundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgoundImageView];
    
        //set blurred background image
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];

        //setup table view
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height-hiloHeight, headerFrame.size.width - (2*inset), hiloHeight);
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height-(temperatureHeight+hiloHeight), headerFrame.size.width - (2*inset), temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y-iconHeight, iconHeight, iconHeight);
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2*inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
        //bottom left
    self.temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.text = @"0°";
    self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [header addSubview:self.temperatureLabel];
    
    
    self.hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    self.hiloLabel.backgroundColor = [UIColor clearColor];
    self.hiloLabel.textColor = [UIColor whiteColor];
    self.hiloLabel.text = @"0° / 0°";
    self.hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [header addSubview:self.hiloLabel];
    
        //top
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.text = @"Loading...";
    self.cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:self.cityLabel];
    
    self.conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    self.conditionsLabel.text = @"Clear...";
    [header addSubview:self.conditionsLabel];
    
    self.iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:self.iconView];
    
    [LESWeatherAPI sharedInstance]; //findCurrentLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentChangedNotification:) name:kWeatherAPIContentUpdateNotification object:nil];
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

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgoundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

    //1
#pragma mark - UITableViewDataSource

    //2
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        //TODO: Return count of forecast
    
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
    
        //TODO Determine cell height based on screen
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
        //    return 44;
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
