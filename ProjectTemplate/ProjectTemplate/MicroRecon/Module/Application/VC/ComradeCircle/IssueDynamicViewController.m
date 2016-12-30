//
//  IssueDynamicViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "IssueDynamicViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "HttpsManager.h"
#import "UploadModel.h"
#import "HZIndicatorView.h"
#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoItemModel.h"
#import "XMLocationController.h"
#import "TZImagePickerController.h"
#import "UIView+TZLayout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"

#define LeftMargin 12
#define imageWidth (screenWidth()-LeftMargin*5)/4

@interface IssueDynamicViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,UITextViewDelegate,XMLocationControllerDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    CLLocationManager *_locationManager;
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    NSMutableArray *_finishPhotos;
    
    CGFloat _itemWH;
    CGFloat _margin;
}

@property(nonatomic,strong)UITextView * contentTextView;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic,strong)UIView * imageBgView;

@property(nonatomic,strong)UIImageView * positionImage;
@property(nonatomic,strong)UILabel * positionLabel;
@property(nonatomic,strong)UIButton * isPositionBtn;
@property(nonatomic,strong)UILabel * lineLabel;

@property(nonatomic,strong)UIImageView * privaceImage;
@property(nonatomic,strong)UILabel * privaceLabel;
@property(nonatomic,strong)UIButton * isprivacyBtn;

@property(nonatomic,strong)UITableView * bgTableView;
@property(nonatomic,strong)UISwitch *positionSwitchButton;
@property(nonatomic,strong)UISwitch *PrSwitchButton;

@property(nonatomic,strong)NSString *addressStr;
@property(nonatomic,strong)NSString *privaceStr;

@property(nonatomic,strong)NSMutableArray *allImageArray;

@property(nonatomic,strong)NSString *postImageUrl;
@property(nonatomic,strong)NSString *tempImageUrl;
@property(nonatomic,strong)NSString *tempStr;

@property (strong, nonatomic, readonly) UIViewController *rootViewController;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *rightButton;

@end

static BOOL _isShow;

@implementation IssueDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.title = @"新动态";
    
    [self intall];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ImageCancel) name:ImageCancelNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressChange:) name:AddressChangeNotification object:nil];
}

- (void)addressChange:(NSNotification *)text
{
    _addressStr = text.userInfo[@"address"];
    self.positionImage.image = [UIImage imageNamed:@"criclePositionp"];
    [_positionSwitchButton setOn:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[LZXHelper isNullToString:_addressStr]isEqualToString:@""]) {
         [self initLocationManager];
    }
    else
    {
       self.positionLabel.text  =_addressStr;
    }
  //  _privaceStr = @"1";
}

-(void)intall
{
    
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _allImageArray = [NSMutableArray array];
    _finishPhotos  = [NSMutableArray array];
    
    [self createRightIssueBtn];
    [self.view addSubview:self.bgTableView];
}

//右上发布按钮/左边取消按钮
-(void)createRightIssueBtn
{
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 30, 35);
    [_rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [_rightButton setTitleColor:CHCHexColor(@"ffffff") forState:UIControlStateNormal];
    _rightButton.titleLabel.font = ZEBFont(14);
    [_rightButton addTarget:self action:@selector(rightBtnIssue) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 30, 35);
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:CHCHexColor(@"ffffff") forState:UIControlStateNormal];
    leftButton.titleLabel.font = ZEBFont(14);
    [leftButton addTarget:self action:@selector(leftButtonCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = [self.navigationItem leftItemsWithBarButtonItem:leftbutton WithSpace:5];
}

#pragma mark  ------- 所有控件
-(UITableView*)bgTableView
{
    if (!_bgTableView) {
        _bgTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()) style:UITableViewStylePlain];
        _bgTableView.delegate = self;
        _bgTableView.dataSource = self;
        _bgTableView.separatorColor = zClearColor;
        _bgTableView.showsVerticalScrollIndicator = NO;
        _bgTableView.showsHorizontalScrollIndicator = NO;
        _bgTableView.tableFooterView = [[UIView alloc]init];
        _bgTableView.backgroundColor = CHCHexColor(@"F5F5F5");
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_bgTableView addGestureRecognizer:tableViewGesture];
    }
    return _bgTableView;
}

-(UITextView*)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(LeftMargin, 10, screenWidth()-LeftMargin*2, 100)];
        _contentTextView.font = [UIFont systemFontOfSize:14.0];
        _contentTextView.backgroundColor = zClearColor;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}

-(UILabel*)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftMargin+5, 18, screenWidth()/3, 20)];
        _contentLabel.text = @"分享新鲜事......";
        _contentLabel.textColor = CHCHexColor(@"12b7f5");
        _contentLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _contentLabel;
}

-(UILabel*)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 0.5)];
        _lineLabel.backgroundColor = LineColor;
    }
    return _lineLabel;
}

-(UIImageView*)positionImage
{
    if (!_positionImage) {
        _positionImage = [[UIImageView alloc]initWithFrame:CGRectMake(LeftMargin, 25/2, 20, 20)];
        _positionImage.image = [UIImage imageNamed:@"criclePosition"];
    }
    return _positionImage;
}

-(UILabel*)positionLabel
{
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+LeftMargin*2, 15, screenWidth()-70-LeftMargin*4, 15)];
        _positionLabel.textColor = CHCHexColor(@"333333");
        _positionLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _positionLabel;
}

-(UIImageView*)privaceImage
{
    if (!_privaceImage) {
        _privaceImage = [[UIImageView alloc]initWithFrame:CGRectMake(LeftMargin, 25/2, 20, 20)];
        _privaceImage.image = [UIImage imageNamed:@"cricleprivacy"];
    }
    return _privaceImage;
}

-(UILabel*)privaceLabel
{
    if (!_privaceLabel) {
        _privaceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+LeftMargin*2, 15, screenWidth()-70-LeftMargin*4, 15)];
        _privaceLabel.text = @"机密信息，隐私内容只有本单位可见";
        _privaceLabel.textColor = CHCHexColor(@"cbcbcb");
        _privaceLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _privaceLabel;
}
-(UISwitch*)positionSwitchButton
{
    if (!_positionSwitchButton) {
        _positionSwitchButton = [[UISwitch alloc]initWithFrame:CGRectMake(screenWidth()-LeftMargin*2-40, 8, 40, 25)];
        [_positionSwitchButton setOn:YES];
        _positionSwitchButton.onTintColor = zBlueColor;
        [_positionSwitchButton addTarget:self action:@selector(positinonSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _positionSwitchButton;
}

-(UISwitch*)PrSwitchButton
{
    if (!_PrSwitchButton) {
        _PrSwitchButton = [[UISwitch alloc]initWithFrame:CGRectMake(screenWidth()-LeftMargin*2-40, 8, 40, 25)];
        [_PrSwitchButton setOn:NO];
        _PrSwitchButton.onTintColor = zBlueColor;
        [_PrSwitchButton addTarget:self action:@selector(PrSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _PrSwitchButton;
}

- (UIView*)imageBgView
{
    if (!_imageBgView) {
        _imageBgView = [[UIView alloc]init];
        _imageBgView.backgroundColor = CHCHexColor(@"ffffff");
    }
    return _imageBgView;
}

- (UIViewController *)rootViewController{
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

- (void)cancelLocation{
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------ issue
//点击发布
-(void)rightBtnIssue
{
    [self showloadingName:@"正在发布"];
    _rightButton.enabled = NO;
    
    if (_selectedPhotos.count >0) {
         [self imageProcessing];
    }
    else
    {
        [self sureCanIssue];
    }
}

- (void)sureCanIssue
{
    [self commentTableViewTouchInSide];
    
    if ([[LZXHelper isNullToString:_privaceStr] isEqualToString:@""]) {
        _privaceStr = @"1";
    }
    
    if (![[LZXHelper isNullToString:self.contentTextView.text] isEqualToString:@""]||_selectedPhotos.count >0)
    {
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        paramDict[@"action"] = @"publishpost";
        paramDict[@"alarm"] = alarm;
        paramDict[@"token"] = token;
        paramDict[@"picture"] = self.postImageUrl;
        paramDict[@"mode"] = @"1";
        paramDict[@"position"] = self.positionLabel.text;
        paramDict[@"posttype"] = _privaceStr ;
        paramDict[@"text"] = self.contentTextView.text;
        
        [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
         {
             [self showHint:@"发布成功"];
             
             if ([_privaceStr isEqualToString:@"0"])
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NewPrivacyPostNotification object:nil];
             }
             else
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:AllPostNewNotification object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NewFollowPostNotification object:nil];
             }
             _rightButton.enabled = YES;
             [self hideHud];
             
             [self.navigationController popViewControllerAnimated:YES];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             _rightButton.enabled = YES;
             [self hideHud];
         }];
    }
    else
    {
        [self showHint:@"请输入内容或选取图片"];
        _rightButton.enabled = YES;
        [self hideHud];
    }
}

#pragma mark ------ cancel
//取消按钮
-(void)leftButtonCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -------- tableviewDELEGATE

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [cell.contentView addSubview:self.contentTextView];
            [cell.contentView addSubview:self.contentLabel];
        }
        else if (indexPath.row == 1)
        {
            
            [cell.contentView addSubview:self.collectionView];
            if (_selectedPhotos.count>3)
            {
                self.collectionView.frame = CGRectMake(LeftMargin, 0, self.view.tz_width-LeftMargin*2, imageWidth*2+LeftMargin*2);
            }
            else
            {
                self.collectionView.frame = CGRectMake(LeftMargin, 0, self.view.tz_width-LeftMargin*2, imageWidth+LeftMargin);
            }
        }
        else if (indexPath.row == 2)
        {
            [cell.contentView addSubview:self.lineLabel];
            [cell.contentView addSubview:self.positionImage];
            [cell.contentView addSubview:self.positionLabel];
            [cell.contentView addSubview:self.positionSwitchButton];
            self.positionLabel.text = @"暂无位置信息";
        }
        else{
        }
    }
    else{
        [cell.contentView addSubview:self.privaceImage];
        [cell.contentView addSubview:self.privaceLabel];
        [cell.contentView addSubview:self.PrSwitchButton];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 110;
        }
        else if (indexPath.row == 1)
        {
            if (_selectedPhotos.count>3)
            {
                return imageWidth*2+LeftMargin*3;
            }
            else
            {
                return imageWidth+LeftMargin*2;
            }
        }
        else
        {
            return 45;
        }
    }
    else
    {
        return 45;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            
            XMLocationController *locationC = [[XMLocationController alloc] init];
            locationC.delegate = self;
            locationC.locationStr = @"circle";
            UINavigationController *locationNav = [[UINavigationController alloc] initWithRootViewController:locationC];
            [self.rootViewController presentViewController:locationNav animated:YES completion:nil];
        }
    }
}

#pragma mark  ----- switch方法实现
//位置开关
-(void)positinonSwitchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        if (_addressStr.length >0)
        {
            self.positionLabel.text  =_addressStr;
        }
        else
        {
            [self initLocationManager];
        }
        self.positionImage.image = [UIImage imageNamed:@"criclePositionp"];
    }else
    {
        self.positionLabel.text = @"暂无位置信息";
        _addressStr = @"";
        self.positionImage.image = [UIImage imageNamed:@"criclePosition"];
    }
}

-(void)PrSwitchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn)
    {
        _privaceStr = @"0";
    }else
    {
        _privaceStr = @"1";
    }
}

#pragma mark ------ 获取位置信息
//初始化定位 获取经纬度并转为地址
-(void)initLocationManager
{
    if([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 100.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

    __weak IssueDynamicViewController *weakself = self;
    
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            
            NSString * state = [test objectForKey:@"State"];
            NSString * city = [test objectForKey:@"City"];
            NSString * subLocality = [test objectForKey:@"SubLocality"];
            NSString * street = [test objectForKey:@"Street"];
            
            if ([[LZXHelper isNullToString:state] isEqualToString:@""])
            {
                state = @"";
            }
            if ([[LZXHelper isNullToString:city] isEqualToString:@""])
            {
                city = @"";
            }
            if ([[LZXHelper isNullToString:subLocality] isEqualToString:@""])
            {
                subLocality = @"";
            }
            if ([[LZXHelper isNullToString:street] isEqualToString:@""])
            {
                street = @"";
            }
            
            _addressStr = [NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            weakself.positionLabel.text = _addressStr;
            weakself.positionImage.image = [UIImage imageNamed:@"criclePositionp"];
        }
    }];
    
}

#pragma mark ----- 输入框编辑状态监听、键盘取消第一响应
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        _contentLabel.hidden = YES;
    }
    else
    {
        _contentLabel.hidden = NO;
    }
}

-(void)commentTableViewTouchInSide
{
    [_contentTextView resignFirstResponder];
}


- (void)tableviewReload
{
    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:0];
    [self.bgTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark ----  所有图片相关方法
//添加图片

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = zNavColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
#pragma clang diagnostic pop
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _margin = 12;
        _itemWH = (self.view.tz_width - 5 * _margin ) / 4 ;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = 6;
        layout.minimumLineSpacing = 6;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(LeftMargin, LeftMargin, self.view.tz_width-LeftMargin*2, imageWidth+LeftMargin) collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor =CHCHexColor(@"ffffff");
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        UILongPressGestureRecognizer * longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        longPressGestureRecognizer.cancelsTouchesInView = NO;
        longPressGestureRecognizer.minimumPressDuration = 1;
        longPressGestureRecognizer.delegate = self;
        [_collectionView addGestureRecognizer:longPressGestureRecognizer];
        
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    }
    return _collectionView;
}

- (void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)longPress
{
    _isShow = YES;
    [_collectionView reloadData];
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"cricleAddImage"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = _selectedPhotos[indexPath.row];
        cell.asset = _selectedAssets[indexPath.row];
        if (_isShow) {
            cell.deleteBtn.hidden = NO;
        }
        else
        {
            cell.deleteBtn.hidden = YES;
        }
    }
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count) {
        _isShow = NO;
        [_collectionView reloadData];
        
        BOOL showSheet = YES;
        if (showSheet) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
#pragma clang diagnostic pop
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
    } else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
        }
        if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = 6;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
                _isSelectOriginalPhoto = isSelectOriginalPhoto;
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 1) / 4 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    }
}

#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _selectedPhotos[sourceIndexPath.item];
    [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    id asset = _selectedAssets[sourceIndexPath.item];
    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:6 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
   imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
#define push @#clang diagnostic pop
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([[TZImageManager manager] authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [_selectedAssets addObject:assetModel.asset];
                        [_selectedPhotos addObject:image];
                        [self tableviewReload];
                        [_collectionView reloadData];
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 0) { // take photo / 去拍照
        if (_selectedPhotos.count>5) {
            [self showHint:@"最多6张图片"];
        }
        else
        {
            [self takePhoto];
        }
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
#pragma clang diagnostic pop
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    [self tableviewReload];
    
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
    
    // 1.打印图片名字
   // [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    
    [_collectionView reloadData];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - Click Event

- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    
    IssueDynamicViewController  __weak * weakSelf = self;
    
    [_allImageArray removeAllObjects];
    _tempImageUrl = @"";
    _postImageUrl = @"";
    
    for (UIImage * image in _selectedPhotos)
    {
        [[HttpsManager sharedManager] upload:image progress:^(NSProgress * _Nonnull progress) {
            // progressBlock(progress.fractionCompleted*0.3);
        } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response)
         {
             NSString * imageUrl = [UploadModel uploadWithData:response].url;
             
             [_allImageArray addObject:imageUrl];
             
             if (_selectedPhotos.count ==1)
             {
                 weakSelf.postImageUrl = imageUrl;
             }
             else
             {
                 if (weakSelf.tempImageUrl.length>0)
                 {
                     weakSelf.postImageUrl = [NSString stringWithFormat:@"%@,%@",weakSelf.tempImageUrl,imageUrl];
                 }
                 else
                 {
                     weakSelf.postImageUrl = [NSString stringWithFormat:@"%@",imageUrl];
                 }
             }
             weakSelf.tempImageUrl = weakSelf.postImageUrl;
             
             [self tableviewReload];
             
         }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
    }
    
    [self tableviewReload];
    
}

- (void)imageProcessing
{
    
    if (!_isSelectOriginalPhoto)
    {
        [_finishPhotos removeAllObjects];
        
        for (UIImage * photo in _selectedPhotos) {
            if (photo) {
                NSData *imageData = UIImageJPEGRepresentation(photo,0.5);
                UIImage *temImage = [UIImage imageWithData:imageData];
                
                if (temImage.size.width > 3000)
                {
                    [_finishPhotos addObject:[self imageWithImageSimple:temImage scaledToSize:CGSizeMake(temImage.size.width/3, temImage.size.height/3)]];
                }
                else if (temImage.size.width>2000)
                {
                    [_finishPhotos addObject:[self imageWithImageSimple:temImage scaledToSize:CGSizeMake(temImage.size.width/2, temImage.size.height/2)]];
                }
                else
                {
                    [_finishPhotos addObject:[self imageWithImageSimple:temImage scaledToSize:CGSizeMake(temImage.size.width, temImage.size.height)]];
                }
            }
        }
    }
    
    IssueDynamicViewController  __weak * weakSelf = self;
    
    [_allImageArray removeAllObjects];
    _tempImageUrl = @"";
    _postImageUrl = @"";
    
    if (_finishPhotos.count>0) {
        for (UIImage * image in _finishPhotos)
        {
            [[HttpsManager sharedManager] upload:image progress:^(NSProgress * _Nonnull progress) {
                // progressBlock(progress.fractionCompleted*0.3);
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response)
             {
                 NSString * imageUrl = [UploadModel uploadWithData:response].url;
                 
                 [_allImageArray addObject:imageUrl];
                 
                 if (_selectedPhotos.count ==1)
                 {
                     weakSelf.postImageUrl = imageUrl;
                 }
                 else
                 {
                     if (weakSelf.tempImageUrl.length>0)
                     {
                         weakSelf.postImageUrl = [NSString stringWithFormat:@"%@,%@",weakSelf.tempImageUrl,imageUrl];
                     }
                     else
                     {
                         weakSelf.postImageUrl = [NSString stringWithFormat:@"%@",imageUrl];
                     }
                 }
                 weakSelf.tempImageUrl = weakSelf.postImageUrl;
                 
                 if (_allImageArray.count == _selectedPhotos.count)
                 {
                     //掉接口
                     [weakSelf sureCanIssue];
                 }
                 
                 [self tableviewReload];
                 
             }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 
             }];
        }
    }
    
}
//修改图片大小
- (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  newImage;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
