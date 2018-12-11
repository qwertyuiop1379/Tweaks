#import "DXIRootViewController.h"
#import <Foundation/NSTask.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSPipe.h>

@implementation Project
@end

@implementation UIImage (scale)
-(UIImage *)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end

@implementation DXIRootViewController
{
	NSMutableArray *_objects, *_themeObjects;
	UIView *iconView, *themeView, *bundleEditView;
	NSIndexPath *openedProjectIndex, *openedBundleIndex;
	UIImageView *iconPreview, *themePreview;
	NSFileManager *manager;
	UITableView *themeTableView;
	UIActivityIndicatorView *spinner;
	CGRect frame;
}

-(void)loadView
{
	[super loadView];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	manager = [NSFileManager defaultManager];
	[self loadObjects];
	frame = [UIScreen mainScreen].bounds;
	self.title = @"DesignerXI";
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
	[manager removeItemAtPath:@"/User/Documents/DesignerXI/tmp" error:nil];
	[manager removeItemAtPath:@"/User/Documents/DesignerXI/package.deb" error:nil];
}

-(void)loadObjects
{
	_objects = [[NSMutableArray alloc] init];
	for (NSString *line in [manager contentsOfDirectoryAtPath:@"/User/Documents/DesignerXI" error:nil])
	{
		if ([[line substringToIndex:1] isEqual:@"0"] || [[line substringToIndex:1] isEqual:@"1"])
		{
			Project *newProject = [Project alloc];
			newProject.type = [[line substringToIndex:1] intValue];
			newProject.name = [line substringFromIndex:1];
			[_objects insertObject:newProject atIndex:0];
			[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	[self.tableView reloadData];
}

-(void)loadThemeObjects
{
	_themeObjects = [[NSMutableArray alloc] init];
	for (NSString *line in [manager contentsOfDirectoryAtPath:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/Bundles"] error:nil])
	{
		[_themeObjects insertObject:[line substringToIndex:[line length] - 7] atIndex:0];
		[themeTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	[themeTableView reloadData];
}

-(void)createProject:(int)type
{
	UIAlertController *nameAlert = [UIAlertController alertControllerWithTitle:@"DesignerXI" message:@"Name your package:" preferredStyle:UIAlertControllerStyleAlert];
	[nameAlert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Name";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.backgroundColor = [UIColor clearColor];
        textField.borderStyle = UITextBorderStyleNone;
    }];
	[nameAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}]];
	[nameAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		NSString *name = [nameAlert.textFields[0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSString *projectDir = [NSString stringWithFormat:@"/User/Documents/DesignerXI/%d%@", type, name];
		if (![name isEqual:@""] && ![manager fileExistsAtPath:projectDir])
		{
			[manager createDirectoryAtPath:[projectDir stringByAppendingString:(type == 1 ? @"/Bundles":@"")] withIntermediateDirectories:YES attributes:nil error:nil];
			NSString *controlFile = [NSString stringWithFormat:@"Package: com.yourcompany.%@\nName: %@\nVersion: 1.0.0\nArchitecture: iphoneos-arm\nDescription: Description\nMaintainer: You\nAuthor: You\nSection: Themes\n", [[name stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString], name];
			[controlFile writeToFile:[NSString stringWithFormat:@"%@/control", projectDir] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
			Project *newProject = [Project alloc];
			newProject.name = name;
			newProject.type = type;
			[_objects insertObject:newProject atIndex:0];
			[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			[self.tableView reloadData];
		}
	}]];
	[self presentViewController:nameAlert animated:YES completion:nil];
}

-(void)addButtonTapped
{
	UIAlertController *choiceAlert = [UIAlertController alertControllerWithTitle:@"DesignerXI" message:@"Choose project type:" preferredStyle:UIAlertControllerStyleAlert];
    [choiceAlert addAction:[UIAlertAction actionWithTitle:@"Zeppelin Icon" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		[self createProject:0];
	}]];
    [choiceAlert addAction:[UIAlertAction actionWithTitle:@"Theme" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		[self createProject:1];
	}]];
	[choiceAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:choiceAlert animated:YES completion:nil];
}

#pragma mark - Table View Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.tableView)
	{
		return _objects.count;
	}
	else
	{
		return _themeObjects.count;
	}
	return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	if (tableView == self.tableView)
	{
		Project *project = _objects[indexPath.row];
		cell.textLabel.text = [NSString stringWithFormat:@"%@%@", project.name, project.type == 0 ? @" (Icon)":@" (Theme)"];
	}
	else
	{
		cell.textLabel.text = (NSString *)_themeObjects[indexPath.row];
	}
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.highlightedTextColor = [UIColor blackColor];
	cell.backgroundColor = [UIColor blackColor];
	return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.tableView)
	{
		[self deleteProject:indexPath];
	}
	else
	{
		[self removeThemeIcon:indexPath];
	}
}

#pragma mark - Table View Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (tableView == self.tableView)
	{
		openedProjectIndex = indexPath;
		UIButton *optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		optionsButton.layer.borderColor = [UIColor whiteColor].CGColor;
		optionsButton.layer.borderWidth = 1;
		optionsButton.layer.cornerRadius = 10;
		optionsButton.layer.masksToBounds = YES;
		[optionsButton addTarget:self action:@selector(optionsPressed) forControlEvents:UIControlEventTouchUpInside];
		[optionsButton setTitle:@"Options" forState:UIControlStateNormal];
		optionsButton.frame = CGRectMake(10, 20, frame.size.width - 20, 40);
		if ([self getCurrentProject].type == 0)
		{
			[self.tableView setScrollEnabled:NO];
			self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToHome)];
			self.navigationItem.rightBarButtonItem = nil;
			self.title = [NSString stringWithFormat:@"%@ (Icon)", [self getCurrentProject].name];
			iconView = [[UIView alloc] initWithFrame:frame];
			iconView.backgroundColor = [UIColor blackColor];
			[iconView addSubview:optionsButton];
			iconPreview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 70, frame.size.width - 20, frame.size.width - 20)];
			iconPreview.layer.borderColor = [UIColor whiteColor].CGColor;
			iconPreview.layer.borderWidth = 1;
			iconPreview.layer.cornerRadius = 10;
			iconPreview.layer.masksToBounds = YES;
			if ([manager fileExistsAtPath:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/icon.png"]])
			{
				iconPreview.image = [UIImage imageWithContentsOfFile:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/icon.png"]];
			}
			else
			{
				UILabel *noImage = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, frame.size.width - 20, frame.size.width - 20)];
				noImage.backgroundColor = [UIColor clearColor];
				noImage.textColor = [UIColor whiteColor];
				noImage.textAlignment = NSTextAlignmentCenter;
				noImage.text = @"No image selected.";
				[iconView addSubview:noImage];
			}
			[iconView addSubview:iconPreview];
			UIButton *changeImage = [UIButton buttonWithType:UIButtonTypeCustom];
			changeImage.layer.borderColor = [UIColor whiteColor].CGColor;
			changeImage.layer.borderWidth = 1;
			changeImage.layer.cornerRadius = 10;
			changeImage.layer.masksToBounds = YES;
			[changeImage addTarget:self action:@selector(changeImagePressed) forControlEvents:UIControlEventTouchUpInside];
			[changeImage setTitle:@"Choose Image" forState:UIControlStateNormal];
			changeImage.frame = CGRectMake(10, frame.size.width + 60, frame.size.width - 20, 40);
			[iconView addSubview:changeImage];
			[self.view addSubview:iconView];
			[iconView setAlpha:0.0f];
			[UIView animateWithDuration:0.3f animations:^{[iconView setAlpha:1.0f];} completion:nil];

		}
		else
		{
			[self.tableView setScrollEnabled:NO];
			self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToHome)];
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addThemeBundle)];
			self.title = [NSString stringWithFormat:@"%@ (Theme)", [self getCurrentProject].name];
			themeView = [[UIView alloc] initWithFrame:frame];
			themeView.backgroundColor = [UIColor blackColor];
			[themeView addSubview:optionsButton];
			themeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, frame.size.width, 2000) style:UITableViewStylePlain];
			themeTableView.dataSource = self;
			themeTableView.delegate = self;
			themeTableView.backgroundColor = [UIColor blackColor];
			themeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
			[self loadThemeObjects];
			[themeView addSubview:themeTableView];
			[themeView addSubview:optionsButton];
			[self.view addSubview:themeView];
			[themeView setAlpha:0.0f];
			[UIView animateWithDuration:0.3f animations:^{[themeView setAlpha:1.0f];} completion:nil];
		}
	}
	else
	{
		openedBundleIndex = indexPath;
		[themeTableView setScrollEnabled:NO];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToThemeEditView)];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonREEE)];
		self.title = _themeObjects[indexPath.row];
		bundleEditView = [[UIView alloc] initWithFrame:frame];
		bundleEditView.backgroundColor = [UIColor blackColor];
		iconPreview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.width - 20)];
		iconPreview.layer.borderColor = [UIColor whiteColor].CGColor;
		iconPreview.layer.borderWidth = 1;
		iconPreview.layer.cornerRadius = 10;
		iconPreview.layer.masksToBounds = YES;
		if ([manager fileExistsAtPath:[NSString stringWithFormat:@"%@/Bundles/%@@3x.png", [self getCurrentProjectDirectory:YES], _themeObjects[indexPath.row]]])
		{
			iconPreview.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Bundles/%@@3x.png", [self getCurrentProjectDirectory:YES], _themeObjects[indexPath.row]]];
		}
		else
		{
			UILabel *noImage = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.width - 20)];
			noImage.backgroundColor = [UIColor clearColor];
			noImage.textColor = [UIColor whiteColor];
			noImage.textAlignment = NSTextAlignmentCenter;
			noImage.text = @"No image selected.";
			[bundleEditView addSubview:noImage];
		}
		[bundleEditView addSubview:iconPreview];
		UIButton *changeImage = [UIButton buttonWithType:UIButtonTypeCustom];
		changeImage.layer.borderColor = [UIColor whiteColor].CGColor;
		changeImage.layer.borderWidth = 1;
		changeImage.layer.cornerRadius = 10;
		changeImage.layer.masksToBounds = YES;
		[changeImage addTarget:self action:@selector(changeImagePressed) forControlEvents:UIControlEventTouchUpInside];
		[changeImage setTitle:@"Choose Image (square images work best)" forState:UIControlStateNormal];
		changeImage.frame = CGRectMake(10, frame.size.width, frame.size.width - 20, 40);
		[bundleEditView addSubview:changeImage];
		[self.view addSubview:bundleEditView];
		[bundleEditView setAlpha:0.0f];
		[UIView animateWithDuration:0.3f animations:^{[bundleEditView setAlpha:1.0f];} completion:nil];
	}
}

-(void)trashButtonREEE
{
	[self removeThemeIcon:openedBundleIndex];
}

-(void)backToThemeEditView
{
	[themeTableView setScrollEnabled:YES];
	self.title = _themeObjects[openedBundleIndex.row];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToHome)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addThemeBundle)];
	[UIView animateWithDuration:0.3f animations:^{[bundleEditView setAlpha:0.0f];} completion:^(BOOL finished){[bundleEditView removeFromSuperview];}];
	openedBundleIndex = nil;
}

-(void)addThemeBundle
{
	UIAlertController *nameAlert = [UIAlertController alertControllerWithTitle:@"DesignerXI" message:@"Enter the bundle ID of app:" preferredStyle:UIAlertControllerStyleAlert];
	[nameAlert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"com.apple.AppStore";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.backgroundColor = [UIColor clearColor];
		textField.borderStyle = UITextBorderStyleNone;
    }];
	[nameAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
	[nameAlert addAction:[UIAlertAction actionWithTitle:@"Add all installed apps" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
	{
		[self startAnimating];
		[self performSelectorInBackground:@selector(loadTheAppsDotExe) withObject:nil];
	}]];
	[nameAlert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
	{
		NSString *name = nameAlert.textFields[0].text;
		if (![name isEqual:@""] && ![_themeObjects containsObject:name])
		{
			[_themeObjects insertObject:name atIndex:0];
			[themeTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			[themeTableView reloadData];
		}
	}]];
	[self presentViewController:nameAlert animated:YES completion:nil];
}

-(void)loadTheAppsDotExe
{
	NSArray *apps = [[%c(LSApplicationWorkspace) defaultWorkspace] allInstalledApplications];
	for (LSBundleProxy *app in apps)
	{
		if (![_themeObjects containsObject:app.bundleIdentifier])
		{
			[_themeObjects insertObject:app.bundleIdentifier atIndex:0];
			[themeTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}
	[themeTableView reloadData];
	[themeTableView setContentInset:UIEdgeInsetsMake(0, 0, [_themeObjects count] * 15, 0)];
	[spinner stopAnimating];
}

-(void)startAnimating
{
	spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
	[[UIApplication sharedApplication].keyWindow addSubview:spinner];
    [spinner startAnimating];
}

-(void)removeThemeIcon:(NSIndexPath *)indexPath
{
	UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"DesignerXI" message:@"Are you sure you want to delete this icon?" preferredStyle:UIAlertControllerStyleAlert];
	[confirm addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
	{
		NSString *path = [NSString stringWithFormat:@"%@/Bundles/%@@3x.png", [self getCurrentProjectDirectory:YES], _themeObjects[indexPath.row]];
		if ([manager fileExistsAtPath:path])
		{
			[manager removeItemAtPath:path error:nil];
		}
		[_themeObjects removeObjectAtIndex:indexPath.row];
		[themeTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		[themeTableView reloadData];
		[self backToThemeEditView];
	}]];
    [self presentViewController:confirm animated:YES completion:nil];
}

-(void)changeImagePressed
{
	UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image)
    {
        [self error:@"Error selecting image" message:@"An error occurred. Please try again or choose a different image."];
        return;
    }
	if ([self getCurrentProject].type == 0)
	{
		image = [image scaleToSize:CGSizeMake(image.size.width / (image.size.height / 40), image.size.height / (image.size.height / 40))];
		[UIImagePNGRepresentation(image) writeToFile:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/icon.png"] atomically:YES];
	}
	else
	{
		image = [image scaleToSize:CGSizeMake(180, 180)];
		[UIImagePNGRepresentation(image) writeToFile:[NSString stringWithFormat:@"%@/Bundles/%@@3x.png", [self getCurrentProjectDirectory:YES], _themeObjects[openedBundleIndex.row]] atomically:YES];
	}
	iconPreview.image = [image scaleToSize:CGSizeMake(frame.size.width - 20, image.size.height / (image.size.height / (frame.size.width - 20)))];
	[iconPreview setNeedsDisplay];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)deleteProject:(NSIndexPath *)index
{
	UIAlertController *confirm = [UIAlertController alertControllerWithTitle:@"DesignerXI" message:@"Are you sure you want to delete this project?" preferredStyle:UIAlertControllerStyleAlert];
	[confirm addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil]];
    [confirm addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
	{
		NSString *projectDir = [self getCurrentProjectDirectory:YES];
		if ([manager fileExistsAtPath:projectDir])
		{
			if ([manager removeItemAtPath:projectDir error:nil])
			{
				[_objects removeObjectAtIndex:index.row];
				[self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
				[self.tableView reloadData];
				[self backToHome];
			}
			else
			{
				[self error:@"Delete failed" message:@"An error occurred deleting the project."];
			}
		}
	}]];
    [self presentViewController:confirm animated:YES completion:nil];
}

-(void)backToHome
{
	[self.tableView reloadData];
	[self.tableView setScrollEnabled:YES];
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
	self.title = @"DesignerXI";
	openedProjectIndex = nil;
	[UIView animateWithDuration:0.3f animations:^{[iconView setAlpha:0.0f];} completion:^(BOOL finished){[iconView removeFromSuperview];}];
	[UIView animateWithDuration:0.3f animations:^{[themeView setAlpha:0.0f];} completion:^(BOOL finished){[themeView removeFromSuperview];}];
	[UIView animateWithDuration:0.3f animations:^{[themeView setAlpha:0.0f];} completion:^(BOOL finished){[bundleEditView removeFromSuperview];}];
}

-(NSString *)getCurrentProjectDirectory:(BOOL)full
{
	return [NSString stringWithFormat:@"%@%d%@", full ? @"/User/Documents/DesignerXI/":@"", [self getCurrentProject].type, [self getCurrentProject].name];
}

-(Project *)getCurrentProject
{
	return (Project *)_objects[openedProjectIndex.row];
}

-(void)optionsPressed
{
	UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"DesignerXI" message:@"Choose an option:" preferredStyle:UIAlertControllerStyleActionSheet];
	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Build Project" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self buildCurrentProject:NO];}]];
	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Install Project" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self buildCurrentProject:YES];}]];
	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete Project" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){[self deleteProject:openedProjectIndex];}]];
	[actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)buildCurrentProject:(BOOL)install
{
	[manager removeItemAtPath:@"/User/Documents/DesignerXI/tmp" error:nil];
	[manager removeItemAtPath:@"/User/Documents/DesignerXI/package.deb" error:nil];
	if ([manager fileExistsAtPath:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/control"]])
	{
		[manager createDirectoryAtPath:@"/User/Documents/DesignerXI/tmp/DEBIAN" withIntermediateDirectories:YES attributes:nil error:nil];
		[manager copyItemAtPath:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/control"] toPath:@"/User/Documents/DesignerXI/tmp/DEBIAN/control" error:nil];
		if ([self getCurrentProject].type == 0)
		{
			if ([manager fileExistsAtPath:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/icon.png"]])
			{
				NSString *path = [@"/User/Documents/DesignerXI/tmp/Library/Zeppelin/" stringByAppendingString:((Project *)_objects[openedProjectIndex.row]).name];
				[manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
				UIImage *icon = [UIImage imageWithContentsOfFile:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/icon.png"]];
				icon = [icon scaleToSize:CGSizeMake(icon.size.width / (icon.size.height/40), icon.size.height / (icon.size.height / 40))];
				[UIImagePNGRepresentation(icon) writeToFile:[path stringByAppendingString:@"/black@2x.png"] atomically:YES];
				[UIImagePNGRepresentation(icon) writeToFile:[path stringByAppendingString:@"/etched@2x.png"] atomically:YES];
				[UIImagePNGRepresentation(icon) writeToFile:[path stringByAppendingString:@"/silver@2x.png"] atomically:YES];
			}
			else
			{
				[manager removeItemAtPath:@"/User/Documents/DesignerXI/tmp" error:nil];
				[self error:@"Build failed" message:@"Project missing icon file."];
				return;
			}
		}
		else
		{
			[manager createDirectoryAtPath:[NSString stringWithFormat:@"/User/Documents/DesignerXI/tmp/Library/Themes/%@.theme/IconBundles", [self getCurrentProject].name] withIntermediateDirectories:YES attributes:nil error:nil];
			NSArray *items = [manager contentsOfDirectoryAtPath:[[self getCurrentProjectDirectory:YES] stringByAppendingString:@"/Bundles"] error:nil];
			if ([items isEqual:@[]])
			{
				[self error:@"Error building project" message:@"There are no icons currently added to the theme."];
				return;
			}
			for (NSString *line in items)
			{
				NSString *toSave = [NSString stringWithFormat:@"/User/Documents/DesignerXI/tmp/Library/Themes/%@.theme/IconBundles/%@", [self getCurrentProject].name, line];
				[manager copyItemAtPath:[NSString stringWithFormat:@"%@/Bundles/%@", [self getCurrentProjectDirectory:YES], line] toPath:toSave error:nil];
			}
			NSString *infoPlist = @"<plist version=\"1.0\">\n<dict>\n<key>IB-MaskIcons</key>\n<true/>\n</dict>\n</plist>";
			[infoPlist writeToFile:[NSString stringWithFormat:@"/User/Documents/DesignerXI/tmp/Library/Themes/%@.theme/Info.plist", [self getCurrentProject].name] atomically:YES encoding:NSStringEncodingConversionAllowLossy error:nil];
		}
		system("dpkg-deb -Zlzma -b /User/Documents/DesignerXI/tmp /User/Documents/DesignerXI/package.deb");
		if (install)
		{
			NSTask *task = [NSTask new];
			[task setLaunchPath:@"/usr/bin/qdexec"];
			NSPipe *pipe = [NSPipe pipe];
			[task setStandardError:pipe];
			[task launch];
			[task waitUntilExit];
			NSData *retData = [pipe.fileHandleForReading availableData];
			NSString *retStr = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
			if ([retStr containsString:@"requested operation requires superuser privilege"])
			{
				system("chmod 6755 /usr/bin/qdexec");
				[self error:@"An error occurred" message:@"A fix for the issue has been attempted. If it continues to fail, enter 'chmod 6755 /usr/bin/qdexec' into a terminal."];
				return;
			}
			else if (![retStr isEqual:@""] && ![retStr containsString:@"anemone"])
			{
				[self error:@"Error" message:retStr];
				return;
			}
		}
		[self error:@"Success" message:(install ? @"Project successfully installed.":@"Project successfully built at /var/mobile/Documents/DesignerXI/package.deb.")];
		return;
	}
	else
	{
		[manager removeItemAtPath:@"/User/Documents/DesignerXI/tmp" error:nil];
		[self error:@"Build failed" message:@"Project missing control file."];
		return;
	}
	return;
}

-(void)error:(NSString *)title message:(NSString *)message
{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:nil]];
	[self presentViewController:alert animated:YES completion:nil];
}
@end
