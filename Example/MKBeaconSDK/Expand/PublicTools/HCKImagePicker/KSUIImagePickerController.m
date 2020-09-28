//
//  KSUIImagePickerController.m
//  CaptureVideo
//
//  Created by bufb on 2017/5/22.
//  Copyright © 2017年 kris. All rights reserved.
//

#import "KSUIImagePickerController.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface KSUIImagePickerController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic ,strong)UIImagePickerController *imgMoviePick;
@property (nonatomic ,strong)UIImagePickerController *imgCameraPick;
@property (nonatomic ,strong)UIImagePickerController *imgPhotoLibraryPick;
@end

@implementation KSUIImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (picker == self.imgMoviePick) {
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *strUrl=[url path];
        //保存视频到相簿
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(strUrl)) {
            UISaveVideoAtPathToSavedPhotosAlbum(strUrl, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    } else if (picker == self.imgCameraPick) {
        UIImage *image;
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
        //保存图片到相簿
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else if (picker == self.imgPhotoLibraryPick) {
        UIImage *image;
        image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        NSLog(@"image == %@",image);
        [picker dismissViewControllerAnimated:YES completion:^{}];
    }
}

//取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        NSLog(@"视频保存成功");
        [self.imgMoviePick dismissViewControllerAnimated:YES completion:^{}];
    } else {
        NSLog(@"error == %@",error);
    }
}

//照片保存成功回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error) {
        NSLog(@"照片保存成功");
        [self.imgCameraPick dismissViewControllerAnimated:YES completion:^{}];
    } else {
        NSLog(@"error == %@",error);
    }
}

#pragma mark - handler clicked method
- (void)btnRecordClicked:(UIButton *)btn
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:self.imgMoviePick animated:YES completion:^{}];
    } else {
        NSLog(@"系统不能打开摄像机");
    }
}

- (void)btnCameraClicked:(UIButton *)btn
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:self.imgCameraPick animated:YES completion:^{}];
    } else {
        NSLog(@"系统不能打开相机");
    }
}

- (void)btnPhotoLibraryClicked:(UIButton *)btn
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self presentViewController:self.imgPhotoLibraryPick animated:YES completion:^{}];
    } else {
        NSLog(@"系统不能打开相册");
    }
}

#pragma mark - get & set 
- (UIImagePickerController *)imgMoviePick
{
    if (!_imgMoviePick) {
        _imgMoviePick = [[UIImagePickerController alloc]init];
        _imgMoviePick.delegate = self;
        //是否允许编辑
        _imgMoviePick.allowsEditing = YES;
        //数据源（摄像头、相册）
        _imgMoviePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        //摄像头（前置、后置）
        _imgMoviePick.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //媒体类型
        _imgMoviePick.mediaTypes = @[(NSString *)kUTTypeMovie];
        //视频模式
        _imgMoviePick.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    }
    return _imgMoviePick;
}

- (UIImagePickerController *)imgCameraPick
{
    if (!_imgCameraPick) {
        _imgCameraPick = [[UIImagePickerController alloc]init];
        _imgCameraPick.delegate = self;
        //是否允许编辑
        _imgCameraPick.allowsEditing = YES;
        //数据源（摄像头、相册）
        _imgCameraPick.sourceType = UIImagePickerControllerSourceTypeCamera;
        //摄像头（前置、后置）
        _imgCameraPick.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        //媒体类型
        _imgCameraPick.mediaTypes = @[(NSString *)kUTTypeImage];
        //视频模式
        _imgCameraPick.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    }
    return _imgCameraPick;
}

- (UIImagePickerController *)imgPhotoLibraryPick
{
    if (!_imgPhotoLibraryPick) {
        _imgPhotoLibraryPick = [[UIImagePickerController alloc]init];
        _imgPhotoLibraryPick.delegate = self;
        //是否允许编辑
        _imgPhotoLibraryPick.allowsEditing = YES;
        //数据源（摄像头、相册）
        _imgPhotoLibraryPick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    return _imgPhotoLibraryPick;
}

@end
