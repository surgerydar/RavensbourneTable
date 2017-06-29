
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

UIViewController* rootViewController = nil;


@interface PickerDelegate : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end


@implementation PickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"image picked: %@",[info valueForKey:UIImagePickerControllerOriginalImage]);
    UIImage* image = ( UIImage* ) [info valueForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"image picked: %@",image);

    NSData* data = UIImageJPEGRepresentation(image,1.);
    if ( data ) {
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"image picker cancelled");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

void showImagePicker() {
    rootViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.delegate = [[PickerDelegate alloc] init];
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;


    [rootViewController presentViewController:picker animated:YES completion:NULL];
}

