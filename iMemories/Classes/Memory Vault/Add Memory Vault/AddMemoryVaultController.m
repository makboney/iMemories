    //
//  AddMemoryVaultController.m
//  iMemories
//
//  Created by Lion Boney on 2/15/13.
//  Copyright (c) 2013 surroundapps. All rights reserved.
//

#import "AddMemoryVaultController.h"
#import "EGOPhotoGlobal.h"
#import "MyPhotoSource.h"
#import "MyPhoto.h"

@interface AddMemoryVaultController ()

@end

@implementation AddMemoryVaultController
@synthesize tlable;
@synthesize selectedTemplate = _selectedTemplate;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize selectedFieldValue = _selectedFieldValue;
@synthesize photoManager = _photoManager;
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
    NSLog(@"%@",_selectedTemplate.name);
    _totalDisplacement = 0.0f;
    UIBarButtonItem *saveButton;
    NSLog(@"_selectedFieldValue %@",_selectedFieldValue);
    if (_selectedFieldValue == NULL) {
        saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addItems:)];
        
    }else{
        
        saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItems:)];
        [self.view setUserInteractionEnabled:NO];
        
    }
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"order"
                                                  ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *controls = [[_selectedTemplate.field allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        _textFields = [[NSMutableArray alloc] initWithCapacity:controls.count];
    int y = 75;
    int x = 20;
    int count = 0;
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:_selectedFieldValue.value];
    if ([_selectedTemplate.name isEqualToString:@"com.surroundapps.album"]) {
        [_scrollview removeFromSuperview];
        _images = [[NSMutableArray alloc] init];
        
        MAKControlView *containerView = [[MAKControlView alloc] initWithFrame:CGRectMake(-10, 5 , 340, 60)];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 35, 35)];
        [iconView setImage:[UIImage imageWithData:_selectedTemplate.templateType.icon]];
        [iconView setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:iconView];
        [iconView release];
        
        _albmTitleTxtField = [[MAKTextField alloc] initWithFrame:CGRectMake(75,  20, 200, 30)];
        [_albmTitleTxtField setDelegate:self];
        [_albmTitleTxtField setReturnKeyType:UIReturnKeyNext];
        [_albmTitleTxtField setPlaceholder:[_selectedTemplate.templateType.name lowercaseString]] ;
        _albmTitleTxtField.tag = count++;
        [_textFields addObject:_albmTitleTxtField];
        [_albmTitleTxtField setName:@"Name"];
        [_albmTitleTxtField setText:[dic valueForKey:@"Name"]];
        [_albmTitleTxtField setBackgroundColor:[UIColor clearColor]];
        [containerView addSubview:_albmTitleTxtField];
        [_albmTitleTxtField release];
        
        
        UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addbutton setFrame:CGRectMake(290, 17, 34, 34)];
        [addbutton addTarget:self action:@selector(addImageBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:addbutton];
        
        [self.view addSubview:containerView];
        [containerView release];
        
        
        _imageShowCase = [[NLImageShowCase alloc] initWithFrame:CGRectMake(0, y +10 , 310, self.view.bounds.size.height - y)];
        _imageViewer = [[NLImageViewer alloc] initWithFrame:CGRectMake(0, y +10 , 310, self.view.bounds.size.height - y)];
        
        [_imageShowCase setBackgroundColor:[UIColor clearColor]];
        [_imageViewer setBackgroundColor:[UIColor clearColor]];
        [_imageShowCase setDataSource:self];
        
        _imagViewController = [[UIViewController alloc] init];
        [self.view addSubview:_imageViewer];
        
        [self.view addSubview:_imageShowCase];
        //NSArray *tempImages = [dic objectForKey:@"IMAGES"];
        self.photoManager = [[PhotoManager alloc] initWithAlbumName:[dic objectForKey:@"Name"] andImages:nil delegate:self];
        [self.photoManager startRetrieving];
        //NSLog(@"temp %d",[tempImages count]);
//        for (UIImage *image in tempImages) {
//            [_images addObject:image];
//            static int counter=0;
//            [_imageShowCase setDeleteMode:NO];
//            [_imageShowCase addImage:image];
//            counter = counter % 6;
//        }
        /*if ([tempImages count] > 0) {
            self.photoManager = [[PhotoManager alloc] initWithAlbumName:[dic objectForKey:@"Name"] andImages:tempImages delegate:self];
            [self.photoManager startRetrieving];
        }*/
        [_imageShowCase release];
        [_imageViewer release];
        [self.view setAutoresizesSubviews:YES];
        [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        UILabel *desctitile = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 5, 120, 30)];
        [desctitile setText:@"Note"];
        [desctitile setFont:[UIFont boldSystemFontOfSize:14]];
        [desctitile setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:desctitile];
        [desctitile release];
        
        _noteTxtView = [[MAKTextView alloc] initWithFrame:CGRectMake(10, y + 35 , 300, 55)];
        [_noteTxtView setName:@"Note"];
        [_noteTxtView setDelegate:self];
        [_noteTxtView setText:[dic objectForKey:_noteTxtView.name]];
        [_noteTxtView.layer setBorderColor:[UIColor grayColor].CGColor];
        [_noteTxtView.layer setBorderWidth:0.5f];
        [_noteTxtView.layer setCornerRadius:5.0f];
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
                if ([field.name isEqual:@"Name"]) {
                    MAKControlView *containerView = [[MAKControlView alloc] initWithFrame:CGRectMake(-10, 5 , 340, 60)];
                    [containerView setBackgroundColor:[UIColor clearColor]];
                    
                    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 35, 35)];
                    iconView.image = [UIImage imageWithData:_selectedTemplate.templateType.icon];
                    [iconView setBackgroundColor:[UIColor clearColor]];
                    [containerView addSubview:iconView];
                    [iconView release];
                    
                    MAKTextField *fieldtxt = [[MAKTextField alloc] initWithFrame:CGRectMake(75,  20, 320, 30)];
                    [fieldtxt setDelegate:self];
                    [fieldtxt setReturnKeyType:UIReturnKeyNext];
                    [fieldtxt setPlaceholder:[_selectedTemplate.templateType.name lowercaseString]];
                    [fieldtxt setName:field.name];
                    [fieldtxt setText:[dic objectForKey:field.name]];
                    [fieldtxt setBackgroundColor:[UIColor clearColor]];
                    [containerView addSubview:fieldtxt];
                    fieldtxt.tag = count++;
                    [_textFields addObject:fieldtxt];
                    [fieldtxt release];
                    
                    [_scrollview addSubview:containerView];
                    [containerView release];
                    
                }else{
                    MAKControlView *containerView = [[MAKControlView alloc] initWithFrame:CGRectMake(7, y , 320, 60)];
                    [containerView setBackgroundColor:[UIColor clearColor]];
                    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 30)];
                    [tempLabel setFont:[UIFont boldSystemFontOfSize:14]];
                    tempLabel.backgroundColor = [UIColor clearColor];
                    tempLabel.text = field.name;
                    [containerView addSubview:tempLabel];
                    [tempLabel release];
                    
                    MAKTextField *fieldtxt = [[MAKTextField alloc] initWithFrame:CGRectMake(5,  30, 320, 30)];
                    [fieldtxt setDelegate:self];
                    [fieldtxt setReturnKeyType:UIReturnKeyNext];
                    [fieldtxt setPlaceholder:@"No Information Provided"];
                    [fieldtxt setName:field.name];
                    [fieldtxt setText:[dic objectForKey:field.name]];
                    [fieldtxt setBackgroundColor:[UIColor clearColor]];
                    [containerView addSubview:fieldtxt];
                    fieldtxt.tag = count++;
                    [_textFields addObject:fieldtxt];
                    [fieldtxt release];
                    
                    y+=60;
                    
                    [_scrollview addSubview:containerView];
                    [containerView release];
                }
                
                
            }
            else if ([field.type isEqual:@"UITextView"]) {
                UILabel *desctitile = [[UILabel alloc] initWithFrame:CGRectMake(10, y + 5, 120, 30)];
                [desctitile setFont:[UIFont boldSystemFontOfSize:14]];
                [desctitile setText:@"Note"];
                [desctitile setBackgroundColor:[UIColor clearColor]];
                [_scrollview addSubview:desctitile];
                [desctitile release];
                
                MAKTextView *desctxtView = [[MAKTextView alloc] initWithFrame:CGRectMake(10, y + 35 , 300, 55)];
                [desctxtView setName:@"Note"];
                [desctxtView setDelegate:self];
                [desctxtView setText:[dic objectForKey:desctxtView.name]];
                [desctxtView.layer setBorderColor:[UIColor grayColor].CGColor];
                [desctxtView.layer setBorderWidth:0.5f];
                [desctxtView.layer setCornerRadius:5.0f];
                [desctxtView setBackgroundColor:[UIColor whiteColor]];
                [_scrollview addSubview:desctxtView];
                [desctxtView release];
                y+=90;
                
                
            }
            
        }
    }
    [_scrollview setContentSize:CGSizeMake(320, y)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_textFields release];
    _textFields = nil;
    
    [_scrollview release];
    _scrollview = nil;
    
    [_images release];
    _images = nil;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [self resignFirstResponder];
}
#pragma mark - 
#pragma mark - Button event handler
- (IBAction)addImageBtnTapped:(id)sender{
    
    _actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Gallery", nil),NSLocalizedString(@"Camera", nil), nil];
    _actionSheet.tag = 0;
    [_actionSheet dismissWithClickedButtonIndex:_actionSheet.cancelButtonIndex
                                       animated:YES];
    [_actionSheet showFromTabBar:self.tabBarController.tabBar];
    [_actionSheet release];
}
- (void)saveData{

    NSArray *controls = [_selectedTemplate.field allObjects];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:[controls count]];
    if ([_selectedTemplate.templateType.name isEqual:@"Album"]) {
        [dic setObject:_albmTitleTxtField.text forKey:_albmTitleTxtField.name];
        [dic setObject:_noteTxtView.text forKey:_noteTxtView.name];
        //[dic setObject:_images forKey:@"IMAGES"];
        self.photoManager = nil;
        self.photoManager = [[PhotoManager alloc] initWithAlbumName:_albmTitleTxtField.text andImages:_images delegate:self];
        [self.photoManager startSaving];
    }else{
        for (UIView *subView in _scrollview.subviews) {
            if ([subView isKindOfClass:[MAKControlView class]]) {
                MAKControlView *tempView = (MAKControlView *)subView;
                for (UIView *view_ in tempView.subviews) {
                    if ([view_ isKindOfClass:[MAKTextField class]]) {
                        MAKTextField *txtField = (MAKTextField *)view_;
                        if ([txtField.text length] == 0) {
                            [dic setObject:@"No Information Provided" forKey:txtField.name];
                        }else [dic setObject:txtField.text forKey:txtField.name];
                    }
                    
                }
            }
            if ([subView isKindOfClass:[MAKTextView class]]) {
                MAKTextView *txtView = (MAKTextView *)subView;
                if ([txtView.text length] == 0) {
                    [dic setObject:@"No Information Provided" forKey:txtView.name];
                }else [dic setObject:txtView.text forKey:txtView.name];
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
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)addItems:(UIBarButtonItem*)btn{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
    if ([_selectedTemplate.templateType.name isEqual:@"Album"]) {
        [HUD show:YES];
        [self saveData];
    }
    else{
    [HUD showWhileExecuting:@selector(saveData) onTarget:self withObject:nil animated:YES];
    }
    
	//
}
- (void)updateItems:(UIBarButtonItem*)btn{
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"FieldValue" inManagedObjectContext:_managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"value=%@",_selectedFieldValue.value]];
    
    //Ask for it
    NSError *error = nil;
    FieldValue *fieldvalue = [[_managedObjectContext executeFetchRequest:request error:&error] lastObject];
    [request release];
    
    if (error) {
        //Handle any errors
    }
    
    if (!fieldvalue) {
        //Nothing there to update
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if ([_selectedTemplate.templateType.name isEqual:@"Album"]) {
        [dic setObject:_albmTitleTxtField.text forKey:_albmTitleTxtField.name];
        [dic setObject:_noteTxtView.text forKey:_noteTxtView.name];
        //[dic setObject:_images forKey:@"IMAGES"];
        self.photoManager = nil;
        self.photoManager = [[PhotoManager alloc] initWithAlbumName:_albmTitleTxtField.text andImages:_images delegate:self];
        [self.photoManager startSaving];
    }else{
        for (UIView *subView in _scrollview.subviews) {
            if ([subView isKindOfClass:[MAKControlView class]]) {
                MAKControlView *tempView = (MAKControlView *)subView;
                for (UIView *view_ in tempView.subviews) {
                    
                    if ([view_ isKindOfClass:[MAKTextField class]]) {
                        MAKTextField *txtField = (MAKTextField *)view_;
                        if ([txtField.text length] == 0) {
                            [dic setObject:@"No Information Provided" forKey:txtField.name];
                        }else [dic setObject:txtField.text forKey:txtField.name];
                    }
                    
                }
            }
            if ([subView isKindOfClass:[MAKTextView class]]) {
                MAKTextView *txtView = (MAKTextView *)subView;
                if ([txtView.text length] == 0) {
                    [dic setObject:@"No Information Provided" forKey:txtView.name];
                }else [dic setObject:txtView.text forKey:txtView.name];
            }
        }
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    fieldvalue.value = data;
    if (![_managedObjectContext save:&error]) {
        //Handle Error
        NSLog(@"Handle Error");
    }else{
        
        //[self.navigationController popViewControllerAnimated:YES];
    }
    [dic release];
}
- (void)editItems:(UIBarButtonItem*)btn{
    [self.view setUserInteractionEnabled:YES];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateItems:)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
}
- (IBAction)cancelBtnTapped:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 
#pragma mark - ImagePicker delegate
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

#pragma mark -
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
    return 0.0f;//+ 44.0f;
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
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:_images.count];
    for (UIImage *img in _images) {
        MyPhoto *photo = [[MyPhoto alloc] initWithImage:img];
        [photos addObject:photo];
        [photo release];
    }
    
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photos];
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    [self.navigationController pushViewController:photoController animated:YES];
    [photoController moveToPhotoAtIndex:[imageShowCaseCell index] animated:YES];
    [photoController release];
    [photos release];
    [source release];
}
- (void)imageTouchLonger:(NLImageShowCase *)imageShowCase imageIndex:(NSInteger)index;
{
    [_imageShowCase setDeleteMode:!(_imageShowCase.deleteMode)];
    [_images removeObjectAtIndex:index];
}

#pragma mark -
#pragma mark PhotoManager Delegate
- (void)photoInfosAvailable:(NSArray *)imageInfos done:(BOOL)done{

    NSLog(done?@"YES":@"NO");
    for (UIImage *image in imageInfos) {
        [_images addObject:image];
        static int counter=0;
        [_imageShowCase setDeleteMode:NO];
        [_imageShowCase addImage:image];
        counter = counter % 6;
    }
}

- (void)photosSaved:(BOOL)done{

    NSLog(done?@"YES":@"NO");
    HUD.labelText = @"Saved";
    [HUD hide:YES];
}
#pragma mark - 
#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    MAKTextField *currentTextFld = (MAKTextField *)textField;
    if (currentTextFld.tag<[_textFields count] -1) {
        UITextField *textfieldToFocus = [_textFields objectAtIndex:currentTextFld.tag+1];
        [textfieldToFocus becomeFirstResponder];
    }
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    MAKTextField *currentTextFld = (MAKTextField *)textField;
    MAKControlView *controlView = (MAKControlView *)[currentTextFld superview];
    CGPoint point = controlView.center;
    if (point.y > self.view.center.y) {
        if (_lastPoint.y > point.y) {
            _totalDisplacement += controlView.frame.size.height;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, controlView.frame.size.height),[[self view] transform]);
            [[self view] setTransform:transform];
            [UIView commitAnimations];
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, - controlView.frame.size.height),[[self view] transform]);
            [[self view] setTransform:transform];
            [UIView commitAnimations];
            _totalDisplacement += controlView.frame.size.height;
        }       
        
        _lastPoint = point;
    }
    
}
#pragma mark-
#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    MAKTextField *currentTextView = (MAKTextField *)textView;
    
    CGPoint point = currentTextView.center;
    if (point.y > self.view.center.y) {
        if (_lastPoint.y > point.y) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, currentTextView.frame.size.height),[[self view] transform]);
            [[self view] setTransform:transform];
            [UIView commitAnimations];
            _totalDisplacement += currentTextView.frame.size.height;
        }else{
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, - currentTextView.frame.size.height),[[self view] transform]);
            [[self view] setTransform:transform];
            [UIView commitAnimations];
            _totalDisplacement += currentTextView.frame.size.height;
        }
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGAffineTransform transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, _totalDisplacement),[[self view] transform]);
        [[self view] setTransform:transform];
        [UIView commitAnimations];
        _totalDisplacement = 0;
        return NO;
    }
    
    return YES;
}
@end
