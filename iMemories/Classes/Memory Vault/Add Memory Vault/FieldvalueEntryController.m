//
//  FieldvalueEntryController.m
//  iMemoriesCore Data
//
//  Created by Lion Boney on 2/21/13.
//  Copyright (c) 2013 SurroundApps Inc. All rights reserved.
//

#import "FieldvalueEntryController.h"

@interface FieldvalueEntryController ()

@end

@implementation FieldvalueEntryController
@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedTemplate = _selectedTemplate;
@synthesize scrollview = _scrollview;
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.824 green:0.812 blue:0.812 alpha:1.000];
    NSLog(@"name %@ count %d",_selectedTemplate.name,[[_selectedTemplate.field allObjects] count]);
//sortUsingDescriptors:
//    [NSArray arrayWithObjects:
//     [NSSortDescriptor sortDescriptorWithKey:@"stringProperty" ascending:YES],
//     [NSSortDescriptor sortDescriptorWithKey:@"dateProperty" ascending:YES], nil]];
    NSArray *controls = [_selectedTemplate.field allObjects];
    [controls sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    int y = 75;
    int x = 20;
    if ([_selectedTemplate.templateType.name isEqual:@"com.surroundapps.album"]) {
        [_scrollview removeFromSuperview];
        _images = [[NSMutableArray alloc] init];
        
        MAKControlView *containerView = [[MAKControlView alloc] initWithFrame:CGRectMake(-10, 5 , 340, 60)];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        _albmTitleTxtField = [[MAKTextField alloc] initWithFrame:CGRectMake(75,  20, 200, 30)];
        
        _albmTitleTxtField.placeholder = [_selectedTemplate.templateType.name lowercaseString];
        _albmTitleTxtField.name = @"TITLE";
        [_albmTitleTxtField setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:_albmTitleTxtField];
        [_albmTitleTxtField release];
        
        UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        addbutton.frame = CGRectMake(290, 17, 34, 34);
        [addbutton addTarget:self action:@selector(addImageBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:addbutton];
        
        [self.view addSubview:containerView];
        [containerView release];
        
        
        _imageShowCase = [[NLImageShowCase alloc] initWithFrame:CGRectMake(5, y +10 , 310, self.view.bounds.size.height - y)];
        _imageViewer = [[NLImageViewer alloc] initWithFrame:CGRectMake(5, y +10 , 310, self.view.bounds.size.height - y)];
        _imageShowCase.backgroundColor = [UIColor clearColor];
        _imageViewer.backgroundColor = [UIColor clearColor];
        _imageShowCase.dataSource = self;
        
        _imagViewController = [[UIViewController alloc] init];
        [self.view addSubview:_imageViewer];
        
        [self.view addSubview:_imageShowCase];
        [self.view setAutoresizesSubviews:YES];
        [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UILabel *desctitile = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 5, 120, 30)];
        desctitile.text = @"Notes";
        desctitile.backgroundColor = [UIColor clearColor];
        [self.view addSubview:desctitile];
        [desctitile release];
        
        _noteTxtView = [[MAKTextView alloc] initWithFrame:CGRectMake(10, y + 35 , 300, 55)];
        _noteTxtView.name = @"DESCRIPTION";
        _noteTxtView.layer.borderColor = [UIColor grayColor].CGColor;
        _noteTxtView.layer.borderWidth = 0.5f;
        _noteTxtView.layer.cornerRadius = 5.0f;
        [_noteTxtView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:_noteTxtView];        
        [_noteTxtView release];
    }else{
        for (Field *field in controls) {
            NSLog(@"%@",field.type);
            if ([field.type isEqual:@"UIIMAGE"]) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y , 50, 50)];
                [_scrollview addSubview:imageView];
                imageView.backgroundColor = [UIColor greenColor];
                y+=50;
            }else if ([field.type isEqual:@"UITextField"]) {
                NSLog(@"%@",field.name);
                if ([field.name isEqual:@"Title"]) {
                    MAKControlView *containerView = [[MAKControlView alloc] initWithFrame:CGRectMake(-10, 5 , 340, 60)];
                    [containerView setBackgroundColor:[UIColor clearColor]];
                    MAKTextField *fieldtxt = [[MAKTextField alloc] initWithFrame:CGRectMake(75,  20, 320, 30)];
                    fieldtxt.placeholder = [_selectedTemplate.templateType.name lowercaseString];
                    fieldtxt.name = field.name;
                    [fieldtxt setBackgroundColor:[UIColor clearColor]];
                    [containerView addSubview:fieldtxt];
                    [fieldtxt release];
                    
                    [_scrollview addSubview:containerView];
                    [containerView release];
                    
                }else{
                    MAKControlView *containerView = [[MAKControlView alloc] initWithFrame:CGRectMake(7, y , 320, 60)];
                    [containerView setBackgroundColor:[UIColor clearColor]];
                    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 30)];
                    tempLabel.backgroundColor = [UIColor clearColor];
                    tempLabel.text = field.name;
                    [containerView addSubview:tempLabel];
                    [tempLabel release];
                    
                    MAKTextField *fieldtxt = [[MAKTextField alloc] initWithFrame:CGRectMake(5,  30, 320, 30)];
                    fieldtxt.placeholder = @"No Information Provided";
                    fieldtxt.name = field.name;
                    [fieldtxt setBackgroundColor:[UIColor clearColor]];
                    [containerView addSubview:fieldtxt];
                    [fieldtxt release];
                    
                    y+=60;
                    
                    [_scrollview addSubview:containerView];
                    [containerView release];
                }
                
                
            }
            else if ([field.type isEqual:@"UITextView"]) {
                MAKTextView *fieldtxt = [[MAKTextView alloc] initWithFrame:CGRectMake(x, y , 200, 90)];
                fieldtxt.secureTextEntry = YES;
                fieldtxt.name = field.name;
                [fieldtxt setBackgroundColor:[UIColor yellowColor]];
                [_scrollview addSubview:fieldtxt];
                y+=90;
            }
            
        }
    }
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addItems:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    
    [_scrollview setContentSize:CGSizeMake(320, y)];
}
- (IBAction)addImageBtnTapped:(id)sender{
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Gallery", nil),NSLocalizedString(@"Camera", nil), nil];
    _actionSheet.tag = 0;
    [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex
                                       animated:YES];
    [_actionSheet showFromTabBar:self.tabBarController.tabBar];
    [_actionSheet release];
}
- (void)addItems:(UIBarButtonItem*)btn{
    NSArray *controls = [_selectedTemplate.field allObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:[controls count]];
     if ([_selectedTemplate.templateType.name isEqual:@"ALBUM"]) {
         [dic setObject:_albmTitleTxtField.text forKey:_albmTitleTxtField.name];
         NSLog(@"textView %@",_noteTxtView.text);
         [dic setObject:_noteTxtView.text forKey:_noteTxtView.name];
         [dic setObject:_images forKey:@"IMAGES"];
     }else{
         for (UIView *subView in _scrollview.subviews) {
             if ([subView isKindOfClass:[MAKControlView class]]) {
                 MAKControlView *tempView = (MAKControlView *)subView;
                 for (UIView *view_ in tempView.subviews) {
                     
                     if ([view_ isKindOfClass:[MAKTextField class]]) {
                         MAKTextField *txtField = (MAKTextField *)view_;
                         if ([txtField.text length] == 0) {
                             [dic setObject:@"NO Information Provided" forKey:txtField.name];
                         }else [dic setObject:txtField.text forKey:txtField.name];
                     }
                 }
             }      
             
         }
     }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];

    FieldValue *fieldValue = (FieldValue *)[NSEntityDescription insertNewObjectForEntityForName:@"FieldValue" inManagedObjectContext:_managedObjectContext];
    [fieldValue setValue:data];
    [fieldValue setCreatedBy:[@"admin" uppercaseString]];
    [fieldValue setUpdatedBy:[@"admin" uppercaseString]];
    [fieldValue setCreatedDate:[NSDate date]];
    [fieldValue setUpdatedDate:[NSDate date]];
    [fieldValue setTemplate:_selectedTemplate];
    [dic release];
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        //Handle Error
        NSLog(@"Handle Error");
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _scrollview = nil;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    static int counter=0;
    [_imageShowCase setDeleteMode:NO];
   // NSString* imageName = [NSString stringWithFormat:@"first.png"];
    [_imageShowCase addImage:originalImage];
    counter = counter % 6;
    [self dismissViewControllerAnimated:YES completion:nil];
    [_images addObject:originalImage];
}

#pragma mark - When Tap Cancel

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate   = self;
        //_camera = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }else if(buttonIndex == 1){
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
       // _camera = YES;
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate   = self;
        picker.sourceType = hasCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
    
}
#pragma mark - Image Showcase Protocol
- (CGSize)imageViewSizeInShowcase:(NLImageShowCase *) imageShowCase
{
    return CGSizeMake(120, 80);
    //    return CGSizeMake(55, 70);
}
- (CGFloat)imageLeftOffsetInShowcase:(NLImageShowCase *) imageShowCase
{
    return 25.0f;
    //    return 20.0f;
}
- (CGFloat)imageTopOffsetInShowcase:(NLImageShowCase *) imageShowCase
{
    return -50.0f;// + 44.0f;
}
- (CGFloat)rowSpacingInShowcase:(NLImageShowCase *) imageShowCase
{
    //    return 20.0f;
    return 25.0f;
    
}
- (CGFloat)columnSpacingInShowcase:(NLImageShowCase *) imageShowCase
{
    //    return 20.0f;
    return 25.0f;
}
- (void)imageClicked:(NLImageShowCase *) imageShowCase imageShowCaseCell:(NLImageShowCaseCell *)imageShowCaseCell;
{
    //[_imageViewer setImage:[imageShowCaseCell image]];
    //[self.navigationController pushViewController:_imagViewController animated:YES];
}
- (void)imageTouchLonger:(NLImageShowCase *)imageShowCase imageIndex:(NSInteger)index;
{
    [_imageShowCase setDeleteMode:!(_imageShowCase.deleteMode)];
    [_images removeObjectAtIndex:index];
}

@end
