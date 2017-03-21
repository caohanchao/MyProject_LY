//
//  WorkListsViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkListsViewController.h"
#import "WorkListsCollectionViewCell.h"
#import "ZEBSearchBar.h"
#import "SuspectlistBaseModel.h"
#import "WorkDesViewController.h"


static CGFloat viewOffset = 64;

#define SEARCHH 43

@interface WorkListsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate> {

    CGFloat contentOffsetY;
    
    CGFloat oldContentOffsetY;
    
    CGFloat newContentOffsetY;
}

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) ZEBSearchBar *searchBar;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *resultsArray;

// 用来存放Cell的唯一标示符
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation WorkListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"任务列表";
    [self initall];
    
}
- (void)initall {
    [self initCollectView];
    [self getDataSource];
    [self setupSearchBar];
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)searchArray {
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}
- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (NSMutableArray *)resultsArray {
    if (!_resultsArray) {
        _resultsArray = [NSMutableArray array];
    }
    return _resultsArray;
}
- (NSMutableDictionary *)cellDic {
    if (!_cellDic) {
        _cellDic = [NSMutableArray array];
    }
    return _cellDic;
}

- (void)getDataSource {
    
    if ([[LZXHelper isNullToString:self.gid] isEqualToString:@""]) {
        [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] suspectAlllistSQ] selectAllSuspects]];
    }else{
        [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] suspectAlllistSQ]  selectSuspectlistByGid:self.gid]];
    }
    
    
    if (self.dataArray.count == 0) {
        [self httpGetSuspectlist];
    }else {
        
    [self.searchArray addObjectsFromArray:self.dataArray];
    [self.collectView reloadData];
    
    for (SuspectlistModel *model in self.searchArray) {
        [self.nameArray addObject:model.suspectname];
    }
        
    }
}
//获取任务列表
- (void)httpGetSuspectlist {
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:GetSuspectlistUrl,alarm,token];
    
    ZEBLog(@"%@",urlString);
    [self showloadingName:@"正在加载..."];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        SuspectlistBaseModel *baseModel = [SuspectlistBaseModel getInfoWithData:response];
        
        [[[DBManager sharedManager] suspectAlllistSQ] transactionInsertSuspectAlllist:baseModel.results];
        
        if ([[LZXHelper isNullToString:self.gid] isEqualToString:@""]) {
            [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] suspectAlllistSQ] selectAllSuspects]];
        }else{
            [self.dataArray addObjectsFromArray:[[[DBManager sharedManager] suspectAlllistSQ]  selectSuspectlistByGid:self.gid]];
        }
        
        [self.searchArray addObjectsFromArray:self.dataArray];
        [self.collectView reloadData];
        
        for (SuspectlistModel *model in self.searchArray) {
            [self.nameArray addObject:model.suspectname];
        }
        [self hideHud];
    } fail:^(NSError *error) {
        
    }];
}
- (void)initCollectView {

    CGFloat leftMargin = 12;
    CGFloat centerMargin = 15;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
   // layout.itemSize = CGSizeMake((kScreenWidth-leftMargin*2-centerMargin)/2, 165);
    layout.itemSize = CGSizeMake((kScreenWidth-leftMargin*2), 147);
    layout.minimumLineSpacing = 12; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 12, 0.f, 12);
    
    
    _collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SEARCHH, kScreenWidth, kScreenHeight-SEARCHH) collectionViewLayout:layout];
    _collectView.backgroundColor = [UIColor clearColor];
    _collectView.dataSource = self;
    _collectView.delegate = self;
    _collectView.alwaysBounceVertical = YES;
    
    
    [self.view addSubview:_collectView];
}
- (void)setupSearchBar{
    
    UIImage *bgImage = [LZXHelper buttonImageFromColor:[UIColor groupTableViewBackgroundColor]];
    self.searchBar = [[ZEBSearchBar alloc]init];
    self.searchBar.frame = CGRectMake(0, viewOffset, SCREEN_WIDTH, SEARCHH);
    
    [self.searchBar setBackgroundImage:bgImage];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [self.view addSubview:self.searchBar];
    
    _resultLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(15) textColor:zGrayColor text:@"没有更多的搜索结果"];
    _resultLabel.frame = CGRectMake(0, 0, 200, 30);
    _resultLabel.center = CGPointMake(kScreen_Width/2, 79);
    _resultLabel.hidden = YES;
    [self.effectView addSubview:_resultLabel];
    
}
#pragma mark -UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.isSearch = YES;
    [self searchClickEvent];
}
- (void)searchClickEvent {
    
    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.effectView];
    _resultLabel.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        //1.
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -viewOffset);
        
        self.searchBar.transform = CGAffineTransformMakeTranslation(0, -NavigationBarHeight);
        
        //2.
        self.searchBar.showsCancelButton = YES;
        [self setupCancelButton];
        [self showThePopView];
        
    }];

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar endEditing:YES];
    [self textFileGRSearch:searchBar.text];
}
#pragma mark -
#pragma mark 组队搜索
- (void)textFileGRSearch:(NSString *)TextField {
    if (TextField == nil || [TextField isEqualToString:@""]) {
        
        
        [_collectView reloadData];
        
    }
    [self.dataArray removeAllObjects];
    //    // 完成具体的搜索功能
    //    // 1.清空搜索结果数组
    [self.resultsArray removeAllObjects];
    
    int k = 0;
    
    //2。通过循环数据，找出与搜索关键字匹配的内容，把匹配的内容添加到数组中
    
    for (NSString *str in self.nameArray) {
        
        NSString *ste = [NSString stringWithFormat:@"%@",str];
        
        NSRange range = [ste rangeOfString:TextField];
        
        
        if (range.length) {
            
            [self.resultsArray addObject:self.searchArray[k]];
            
        }
        
        k++;
        
    }
    [self.dataArray addObjectsFromArray:self.resultsArray];
    if (self.resultsArray.count == 0) {
        _resultLabel.hidden = NO;
        return;
    }else {
        [self.effectView removeFromSuperview];
    }
    [_collectView reloadData];
    
}

- (void)setupCancelButton{
    
    UIButton *cancelButton = [self.searchBar valueForKey:@"_cancelButton"];
    cancelButton.titleLabel.font = ZEBFont(16);
    [cancelButton setTitleColor:zGrayColor];
   // [cancelButton addTarget:self action:@selector(cancelButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelButtonClickEvent];
}
- (void)cancelButtonClickEvent{
    
    self.isSearch = NO;
    _resultLabel.hidden = YES;
    [self.effectView removeFromSuperview];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.searchArray];
    [_collectView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //1.
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        self.searchBar.transform = CGAffineTransformIdentity;
        //2.
        self.searchBar.showsCancelButton = NO;
        [self.searchBar endEditing:YES];
        //3.
        [self dismissThePopView];
    } completion:^(BOOL finished) {
        [self.topBgView removeFromSuperview];
    }];
    
    self.searchBar.text = @"";
    self.searchBar.placeholder = @"搜索";
}

#pragma mark -
#pragma mark UICollectionViewDlegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"WorkListsCollectionViewCell", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [self.collectView registerClass:[WorkListsCollectionViewCell class]  forCellWithReuseIdentifier:identifier];
    }
    WorkListsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SuspectlistModel * model = self.dataArray[indexPath.item];
    CGFloat height = [LZXHelper textHeightFromTextString:model.suspectdec width:screenWidth()-12*4 fontSize:13];
    return CGSizeMake((kScreenWidth-12*2), 97+height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isSearch) {
        [self cancelButtonClickEvent];
        self.isSearch = YES;
    }
    if (self.type == 0){
        SuspectlistModel *model = self.dataArray[indexPath.item];
        [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://workDesViewController?workId=%@",model.suspectid] animated:YES replace:NO];
    }
    else if (self.type == 1) {
        SuspectlistModel *model = self.dataArray[indexPath.item];
        NSMutableDictionary *dict =[NSMutableDictionary new];
        dict[@"taskName"] = model.suspectname;
        dict[@"taskId"] =model.suspectid;
        self.taskBlock(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.type == 2) {
        SuspectlistModel *model = self.dataArray[indexPath.item];
        NSMutableDictionary *dict =[NSMutableDictionary new];
        dict[@"taskName"] = model.suspectname;
        dict[@"taskId"] =model.suspectid;
        self.taskBlock(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.type == 3) {
        SuspectlistModel *model = self.dataArray[indexPath.item];
        NSMutableDictionary *dict =[NSMutableDictionary new];
        dict[@"gid"] = model.gid;
        dict[@"gname"] =model.gname;
        [self.navigationController popViewControllerAnimated:NO];
        self.taskBlock(dict);
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)showThePopView{
    //1.执行动画
    
    [UIView animateWithDuration:0.2 animations:^{
        self.collectView.transform = CGAffineTransformMakeTranslation(0, -NavigationBarHeight);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissThePopView{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.collectView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark -
#pragma mark scrollViewDidScroll
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    NSInteger currentPostion = scrollView.mj_offsetY;
//    
//    if (currentPostion > 0) {
//        
//        [self hideSearchBar];
//    }
//    
//    if (currentPostion < 0) {
//        
//        [self showSeaechBar];
//    }
//    
//}
- (void)showSeaechBar {
    [UIView animateWithDuration:0.2 animations:^{
       self.searchBar.transform = CGAffineTransformIdentity;
    }];
    
}
- (void)hideSearchBar {
    [UIView animateWithDuration:0.2 animations:^{
        self.searchBar.transform = CGAffineTransformMakeTranslation(0, -SEARCHH);
    }];
    
}
- (UIView *)topBgView {

    if (_topBgView == nil) {
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64-SEARCHH)];
        _topBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _topBgView;
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        /**  毛玻璃特效类型
         *   UIBlurEffectStyleExtraLight,
         *   UIBlurEffectStyleLight,
         *   UIBlurEffectStyleDark
         */
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //开启事件响应
        _effectView.userInteractionEnabled = YES;
        //添加到要有毛玻璃特效的控件中
        _effectView.frame = CGRectMake(0, TopBarHeight-5, kScreenWidth, kScreenHeight-TopBarHeight+5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClickEvent)];
        [_effectView addGestureRecognizer:tap];
        
    }
    return _effectView;
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
