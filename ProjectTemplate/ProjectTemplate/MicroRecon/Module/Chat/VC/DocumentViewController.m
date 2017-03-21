//
//  DocumentViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/3/15.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "DocumentViewController.h"

@interface DocumentViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic,strong)UIDocumentInteractionController *dvc;

@end

@implementation DocumentViewController


//- (UIDocumentPickerViewController *)dvc{
//    if (!_dvc) {
//        _dvc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_actualmodel.filePath]];
//        _dvc.delegate = self;
//    }
//}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _dvc = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_filePath]];
    _dvc.delegate = self;
    if(![_dvc presentPreviewAnimated:NO]){
        
        [_dvc presentOpenInMenuFromRect:CGRectMake(0, self.view.height - 500, 100, 100)
                                                         inView:self.view
                                                       animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
    
}
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
    
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
