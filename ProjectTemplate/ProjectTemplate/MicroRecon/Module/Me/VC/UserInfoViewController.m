//
//  UserInfoViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoBaseModel.h"
#import "UserInfoModel.h"
#import "UserInfoImageCell.h"
#import "UserInfoTextViewCell.h"
#import "ZLPhotoActionSheet.h"
#import "CollectCopyView.h"
#import "ChangeUserInfoPhoneController.h"
#import "UploadModel.h"
#import "QRViewController.h"
#import "ZLDefine.h"


@interface UserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, CollectCopyDelegate, ChangeUserInfoPhoneControllerDelegate, UserInfoImageCellDelegate> {

    UITableView *_tableView;
    ZLPhotoActionSheet *_actionSheet;
    UserInfoModel *_model;
}

@property (nonatomic, strong) NSArray *titleDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *headpic;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个人信息";
    [self initall];
}
- (void)initall {
    

    [self createTableView];
    [self getUserDestailFromDB];
    
}
- (NSArray *)titleDataArray {

    if (_titleDataArray == nil) {
        _titleDataArray = @[@[@"头像",@"姓名",@"性别",@"手机号",@"我的二维码"],@[@"职务",@"所属单位",@"警号",@"身份证号"]];
    }
    return _titleDataArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark -
#pragma mark 请求个人信息
- (void)getUserDestailFromDB {
    
    
    _model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
    if (_model.headpic && _model.name && _model.sex && _model.phonenum && _model.post && _model.department && _model.identitycard) {
        [self.dataArray removeAllObjects];
        NSArray *tempArray = @[@[_model.headpic,_model.name,_model.sex,_model.phonenum,@""],@[_model.post,_model.department,[[NSUserDefaults standardUserDefaults] objectForKey:UIUseralarm],_model.identitycard]];
        [self.dataArray addObjectsFromArray:tempArray];
        [_tableView reloadData];
    }
}
#pragma mark -
#pragma mark 修改个人详情
- (void)httpChangeUserInfo {
    
  
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"changeinfo";
    params[@"alarm"] = alarm;
    params[@"token"] = token;
    params[@"key"] = self.key;
    params[@"value"] = self.value;
    
    [self showloadingName:@"正在提交..."];
    [HYBNetworking postWithUrl:ChangeUserInfoUrl refreshCache:YES params:params success:^(id response) {
        
        ZEBLog(@"--------%@",response);
        if ([response[@"resultmessage"] isEqualToString:@"成功"]) {
            
            if ([self.key isEqualToString:@"sex"]) {
                
                if ([self.sex isEqualToString:@"0"]) {
                    
                    [[[DBManager sharedManager] userDetailSQ] updateUserDetailSex:@"女"];
                    
                }else if ([self.sex isEqualToString:@"1"]) {
                    
                    [[[DBManager sharedManager] userDetailSQ] updateUserDetailSex:@"男"];
                
                }
                
                
            }else if ([self.key isEqualToString:@"phone"]) {
                
                [[[DBManager sharedManager] userDetailSQ] updateUserDetailPhone:self.phoneNum];
            
            }else if ([self.key isEqualToString:@"headpic"]) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *alarm = [user objectForKey:@"alarm"];
                [[[DBManager sharedManager] userDetailSQ] updateUserDetailHeadpic:self.headpic];
                //更新本地头像缓存
                [ZEBCache imageCacheUrlString:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headpic]]] alarm:alarm];
                
            }
           
            [self getUserDestailFromDB];
            [self hideHud];
            [self showHint:@"修改成功"];
            [[[DBManager sharedManager] personnelInformationSQ] updateNewPersonnelInformationOfUserInfoModel:_model];
            [[NSNotificationCenter defaultCenter] postNotificationName:ChatControllerRefreshUINotification object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyDataNotification" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadNextDataNotification" object:nil];
        }
        
    } fail:^(NSError *error) {
        
        [self showHint:@"修改失败"];
        
    }];
}

#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    _tableView.separatorColor = LineColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}



#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.titleDataArray.count;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)self.titleDataArray[section] count];
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier1 = @"identifier1";
    static NSString *identifier2 = @"identifier2";
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 4) {
           
            UserInfoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell == nil) {
                cell = [[UserInfoImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier1];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (self.dataArray.count != 0) {
              cell.imageStr = self.dataArray[indexPath.section][indexPath.row];
            }
            cell.delegate = self;
            cell.titleStr = self.titleDataArray[indexPath.section][indexPath.row];  
            return cell;
        }
    }
    UserInfoTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (cell == nil) {
        cell = [[UserInfoTextViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
        
    }
    if (self.dataArray.count != 0) {
        if (indexPath.section == 0) {
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.section = indexPath.section;
        cell.infoStr = self.dataArray[indexPath.section][indexPath.row];
    }
    
    cell.titleStr = self.titleDataArray[indexPath.section][indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }
    }
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 16;
    }
    return 0.1;
//    return 16;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//头像
            self.key = @"headpic";
            [self changeTUXiang];
        }else if (indexPath.row == 1) {//姓名
            [self showHint:@"姓名不可修改！"];
        }else if (indexPath.row == 2) {//性别
        self.key = @"sex";
            [self changeSex];
        }else if (indexPath.row == 3) {//手机号
            self.key = @"phone";
            [self changePhoneNum];
        }else if (indexPath.row == 4) {//我的二维码
            [self goToMyQRView];
        }
    }
}
/**
 *  我的二维码
 */
- (void)goToMyQRView {
    QRViewController *qr = [[QRViewController alloc] init];
    qr.title = @"我的二维码";
    qr.nameStr = self.dataArray[0][1];
    qr.iconStr = self.dataArray[0][0];
    qr.ugType = USER;
    [self.navigationController pushViewController:qr animated:YES];
}
//改图像
- (void)changeTUXiang {

    if (_actionSheet == nil) {
      _actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        _actionSheet.maxSelectCount = 1;
        //设置照片最大预览数
        _actionSheet.maxPreviewCount = 200;
    }
    weakify(self);
    [_actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        strongify(weakSelf);
        UIImage *image = selectPhotos[0];
        //图片不压缩，服务器对图片大小不做限制
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.99);
//        if (image.size.width > 720.0f && [imageData length] > 10 * 1024) {
//            //image = [image scaleImage:720.0f/image.size.width];
//            image =[image imageByScalingAndCroppingForSize:CGSizeMake(150, 150)];
//            imageData = UIImageJPEGRepresentation(image, 0.99);
//        }
//        if ([imageData length] > 10 * 1024) {
//            imageData = UIImageJPEGRepresentation(image, 10 * 1024 / [imageData length]);
//        }
       // [strongSelf httpUploadImages:[UIImage imageWithData:imageData]];
        [strongSelf httpUploadImages:image];
    }];

}



- (void)httpUploadImages:(UIImage *)image {

    
    __weak typeof(self) weakSelf = self;
    
    [self showloadingName:@"正在上传图片..."];
    [[HttpsManager sharedManager] upload:image progress:^(NSProgress * _Nonnull progress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        [self hideHud];
        UploadModel *model = [UploadModel uploadWithData:reponse];
        self.headpic = model.url;
        self.value = model.url;
        [weakSelf httpChangeUserInfo];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
//改性别
- (void)changeSex {

    CollectCopyView *sexView = [[CollectCopyView alloc] initWidthName:@[@"男",@"女"]];
    sexView.delegate = self;
    [sexView show];
}
//改手机号
- (void)changePhoneNum {

    ChangeUserInfoPhoneController *con = [[ChangeUserInfoPhoneController alloc] init];
    con.phoneNum = self.dataArray[0][3];
    con.delegate = self;
    [self.navigationController pushViewController:con animated:YES];
}
- (void)showMyCode {

}

- (void)collectCopy:(CollectCopyView *)view index:(NSInteger)index title:(NSString *)title {

    if (![title isEqualToString:@"取消"]) {
        if (index == 0) {
            self.sex = @"1";
        }else if (index == 1) {
            self.sex = @"0";
        }
        self.value = self.sex;
        [self httpChangeUserInfo];
    }
}
- (void)changeUserInfoPhoneController:(ChangeUserInfoPhoneController *)con phoneNum:(NSString *)pho {

    self.phoneNum = pho;
    self.value = self.phoneNum;
    [self httpChangeUserInfo];
    
}
#pragma mark -
#pragma mark 点击图片
- (void)userInfoImageCell:(UserInfoImageCell *)cell imageView:(UIImageView *)view {
    [self showImage:view];
}
//展示图片
static CGRect oldframe;

-(void)showImage:(UIImageView *)avatarImageView
{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1000;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1000];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
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
