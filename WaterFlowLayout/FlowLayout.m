//
//  AppDelegate.m
//  WaterFlowLayout
//
//  Created by warron on 2017/12/22.
//  Copyright © 2017年 warron. All rights reserved.

#import "FlowLayout.h"

#define Inset 5
@interface FlowLayout(){
	CGFloat totalHeight;
}
@property (nonatomic, strong) NSMutableDictionary *colunMaxYDic;
@end

@implementation FlowLayout
- (instancetype)init{
	if (self=[super init]) {
		_columnSpacing = Inset;//默认值
		_rowSpacing = Inset;//默认值
		self.sectionInset = UIEdgeInsetsMake(Inset, Inset, Inset, Inset);
		_colCount = 3;
		_colunMaxYDic = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)prepareLayout{
	[super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
	return YES;
}

- (CGSize)collectionViewContentSize{
	
	__block NSString * maxCol = @"0";
	//遍历找出最高的列
	[_colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
		if ([maxY floatValue] > [_colunMaxYDic[maxCol] floatValue]) {
			maxCol = column;
		}
	}];
	if (_layoutHeight) {
		_layoutHeight([_colunMaxYDic[maxCol] floatValue]);
	}
	return CGSizeMake(0, [_colunMaxYDic[maxCol] floatValue]);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
	__block NSString * minCol = @"0";
	//遍历找出最短的列
	[_colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
		if ([maxY floatValue] < [_colunMaxYDic[minCol] floatValue]) {
			minCol = column;
		}
	}];
	
	//宽度
	CGFloat width = (self.collectionView.frame.size.width
					 - self.sectionInset.left
					 - self.sectionInset.right
					 - (_colCount-1)
					 * _columnSpacing)/_colCount;
	//高度
	CGFloat height = 0;
	if (_heightByRatioWidth) {
		height = _heightByRatioWidth(self.collectionView,self,width,indexPath);
	}
	
	CGFloat x = self.sectionInset.left + (width + _columnSpacing) * [minCol intValue];
	
	CGFloat space = _rowSpacing;
	if (indexPath.item < _colCount) {
		space = 0.0;
	}
	CGFloat y =[_colunMaxYDic[minCol] floatValue] + space;
	
	//更新新对应列的高度
	_colunMaxYDic[minCol] = @(y + height);
	
	//    计算位置
	UICollectionViewLayoutAttributes * attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
	attri.frame = CGRectMake(x, y, width, height);
	return attri;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
	
	__block NSString * maxCol = @"0";
	//遍历找出最高的列
	[_colunMaxYDic enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL *stop) {
		if ([maxY floatValue] > [_colunMaxYDic[maxCol] floatValue]) {
			maxCol = column;
		}
	}];
	
	//header
	if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
		UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
		//size
		CGSize size = CGSizeZero;
		if (_headerSizeInSection) {
			size = _headerSizeInSection(self.collectionView,self,indexPath.section);
		}
		CGFloat x = self.sectionInset.left;
		CGFloat y = [[_colunMaxYDic objectForKey:maxCol] floatValue] + self.sectionInset.top;
		
		//更新新所有对应列的高度
		for(NSString *key in _colunMaxYDic.allKeys){
			_colunMaxYDic[key] = @(y + size.height + self.sectionInset.top );
		}
		
		attri.frame = CGRectMake(x , y, size.width, size.height);
		return attri;
	}
	
	//footer
	else{
		UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
		//size
		CGSize size = CGSizeZero;
		if (_footerSizeInSection) {
			size = _footerSizeInSection(self.collectionView,self,indexPath.section);
		 }
		CGFloat x = self.sectionInset.left;
		CGFloat y = [[_colunMaxYDic objectForKey:maxCol] floatValue];
		
		//更新新所有对应列的高度
		for(NSString *key in _colunMaxYDic.allKeys){
			_colunMaxYDic[key] = @(y + size.height + self.sectionInset.bottom + self.sectionInset.bottom);
		}
		attri.frame = CGRectMake(x , y, size.width, size.height);
		return attri;
	}
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
	for(NSInteger i = 0;i < _colCount; i++){
		NSString * col = [NSString stringWithFormat:@"%ld",(long)i];
		_colunMaxYDic[col] = @0;
	}
	
	NSMutableArray * attrsArray = [NSMutableArray array];
	
	NSInteger section = [self.collectionView numberOfSections];
	for (NSInteger i = 0 ; i < section; i++) {
		
		//获取header的UICollectionViewLayoutAttributes
		UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
		[attrsArray addObject:headerAttrs];
		
		//获取item的UICollectionViewLayoutAttributes
		NSInteger count = [self.collectionView numberOfItemsInSection:i];
		for (NSInteger j = 0; j < count; j++) {
			UICollectionViewLayoutAttributes * attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
			[attrsArray addObject:attrs];
		}
		
		//获取footer的UICollectionViewLayoutAttributes
		UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
		[attrsArray addObject:footerAttrs];
	}
	return  attrsArray;
}
@end

