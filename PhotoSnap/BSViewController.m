//
//  BSViewController.m
//  PhotoSnap
//
//  Created by Steve Baker on 7/29/13.
//  Copyright (c) 2013 Beepscore LLC. All rights reserved.
//

#import "BSViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface BSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation BSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)presentCamera:(id)sender
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

// Reference Apple Documentation / Camera Programming Topics for iOS / Taking Pictures and Movies
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
    {
        return NO;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // YES Shows controls for moving & scaling pictures or for trimming movies.
    // NO Hides the controls.
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI
                             animated:YES
                           completion:nil];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate Methods

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage)
        {
            imageToSave = editedImage;
        } else
        {
            imageToSave = originalImage;
        }
        self.imageView.image = imageToSave;
    }
   
    // in iOS >= 5, use presentingViewController not parentViewController
    // alternatively, if you call message on presented view controller it will be forwarded to presentingViewController.
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
