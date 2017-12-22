//
//  ViewController.m
//  WaterFlowLayout
//
//  Created by warron on 2017/12/22.
//  Copyright © 2017年 warron. All rights reserved.

#import "ViewController.h"
#import "FlowLayout.h"
#import "HeaderView.h"
#import "FooterView.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad{
	[super viewDidLoad];
	FlowLayout *flowLayout = [[FlowLayout alloc] init];
	flowLayout.columnSpacing = 5;
	
	flowLayout.rowSpacing = 5;
	flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
	flowLayout.colCount = 4;
	flowLayout.heightByRatioWidth = ^CGFloat(UICollectionView *collectionView, FlowLayout *layout, CGFloat width, NSIndexPath *indexPath) {
		
		NSInteger integer = indexPath.row % 3;
		CGFloat height = 1.3 * width;//这个比例值是高/宽比例，并且必须在加载cell之前就算好
		if (integer == 0) {
			height = 0.6 * width;
		}
		else if (integer == 1) {
			height = 0.8 * width;
		}
		return height;
	};
	flowLayout.layoutHeight = ^(float heaght){
		
	};
	flowLayout.footerSizeInSection = ^CGSize(UICollectionView *collectionView, FlowLayout *layout, NSInteger section) {
		return CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);
	};
	flowLayout.headerSizeInSection = ^CGSize(UICollectionView *collectionView, FlowLayout *layout, NSInteger section) {
		return CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);
	};
	
	_collectionView.collectionViewLayout = flowLayout;
	_collectionView.delegate = self;
	_collectionView.dataSource = self;
	[_collectionView registerClass:[UICollectionViewCell class]
		forCellWithReuseIdentifier:@"CollectionViewCell"];
	[self.collectionView registerClass:[HeaderView class]
			forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
				   withReuseIdentifier:@"sectionHeader"];
	[self.collectionView registerClass:[FooterView class]
			forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
				   withReuseIdentifier:@"sectionFooter"];
	
	[self.collectionView reloadData];
}

#pragma mark collectionViewDatasouce
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
	return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return 80;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	UICollectionViewCell * cell = [collectionView
								   dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell"
								   forIndexPath:indexPath];
	cell.contentView.backgroundColor = [UIColor redColor];
	return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		HeaderView *headerView
		= [collectionView
		   dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
		   withReuseIdentifier:@"sectionHeader"
		   forIndexPath:indexPath];
		
		headerView.backgroundColor = [UIColor orangeColor];
		return headerView;
	}else{
		FooterView *footerView
		= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
											 withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
		footerView.backgroundColor = [UIColor blueColor];
		return footerView;
	}
}
- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
@end
