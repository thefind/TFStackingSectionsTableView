//
//  TFStackingSectionsTableView.m
//
//  Created by Tony Mann on 6/1/14.
//

/*
 The MIT License (MIT)
 
 Copyright (c) 2014 TheFind. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "TFStackingSectionsTableView.h"

@interface TFStackingSectionsTableView ()
@property (nonatomic) NSMutableArray *sectionHeaders;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation TFStackingSectionsTableView

#pragma Initializers

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    _stackingHeaders = YES;
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    self.tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Table View Methods

- (void)reloadData
{
    [super reloadData];
    
    if (self.isStackingHeaders) {
        [self removeSectionHeaders];
        [self addSectionHeaders];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isStackingHeaders) {
        [self layoutSectionHeaders];
    }
}

#pragma mark - Tap Gesture Handlers

- (void)viewWasTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if (!self.isStackingHeaders)
        return;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint pt = [gestureRecognizer locationInView:self.superview];
        UIView *sectionHeader = [self sectionHeaderAtPoint:pt];
        
        if (sectionHeader) {
            NSUInteger section = sectionHeader.tag;
            CGRect headerRect = [self rectForHeaderInSection:section];
            CGFloat offset = headerRect.origin.y - (headerRect.size.height * section) - self.contentInset.top;
            CGFloat maxOffset = self.contentSize.height - self.frame.size.height;
            
            if (offset > maxOffset)
                offset = maxOffset;
            
            [self setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.tapGestureRecognizer) {
        CGPoint pt = [touch locationInView:self.superview];
        return [self sectionHeaderAtPoint:pt] != nil;
    }
    
    return YES;
}

#pragma mark - Private

- (void)addSectionHeaders
{
    self.sectionHeaders = [NSMutableArray array];
    
    for (NSInteger section = 0; section < self.numberOfSections; ++section) {
        UIView *sectionHeader = nil;
        
        if ([self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
            sectionHeader = [self.delegate tableView:self viewForHeaderInSection:section];
        
        if (!sectionHeader) {
            if ([self.delegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
                UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:nil];
                headerView.textLabel.text = [self.dataSource tableView:self titleForHeaderInSection:section];
                sectionHeader = headerView;
            }
        }
        
        sectionHeader.userInteractionEnabled = NO;
        [self.superview addSubview:sectionHeader];
        [self.sectionHeaders addObject:sectionHeader];
        sectionHeader.tag = section;
    }
}

- (void)removeSectionHeaders
{
    for (UIView *sectionHeader in self.sectionHeaders) {
        [sectionHeader removeFromSuperview];
    }
    
    self.sectionHeaders = nil;
}

- (void)layoutSectionHeaders
{
    static const CGFloat topMargin = 0.0f;
    static UITableViewHeaderFooterView *templateHeaderView;
    
    if (!templateHeaderView)
        templateHeaderView = [self headerViewForSection:0];
    
    CGFloat contentTop      = self.frame.origin.y + self.contentInset.top + topMargin;
    CGFloat contentBottom   = self.frame.size.height - self.contentInset.bottom;
    
    int sectionCount = self.sectionHeaders.count;
    
    for (int section = 0; section < sectionCount; ++section) {
        UIView *sectionHeader = self.sectionHeaders[section];
        
        UIView *defaultHeaderView = [self headerViewForSection:section];
        defaultHeaderView.hidden = YES;
        
        CGRect headerRect = [self rectForHeaderInSection:section];
        headerRect = [self.superview convertRect:headerRect fromView:self];
        
        CGFloat headerHeight = headerRect.size.height;
        CGFloat minY = contentTop + headerHeight * section;
        CGFloat maxY = contentBottom - (headerHeight * (sectionCount - section));
        
        if (headerRect.origin.y < minY) {
            headerRect.origin.y = minY;
        } else if (headerRect.origin.y > maxY) {
            headerRect.origin.y = maxY;
        }
        
        sectionHeader.frame = headerRect;
        
        if ([sectionHeader isMemberOfClass:[UITableViewHeaderFooterView class]]) {
            UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sectionHeader;
            
            if ([self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
                [self.delegate tableView:self willDisplayHeaderView:sectionHeader forSection:section];
            }
            
            if (headerView.textLabel.font.pointSize == 0) {
                headerView.textLabel.font = templateHeaderView.textLabel.font;
                [headerView.textLabel sizeToFit];
            }
            
            if (headerView.backgroundView) {
                if (!headerView.backgroundView.backgroundColor) {
                    headerView.backgroundView.backgroundColor = templateHeaderView.backgroundView.backgroundColor;
                }
            } else if (!headerView.contentView.backgroundColor) {
                headerView.contentView.backgroundColor = templateHeaderView.backgroundView.backgroundColor;
            }
            
            CGRect textLabelFrame = headerView.textLabel.frame;
            
            if (textLabelFrame.origin.y <= 0) {
                textLabelFrame.origin.y = (headerView.frame.size.height - textLabelFrame.size.height) / 2;
                headerView.textLabel.frame = textLabelFrame;
            }
        }
    }
}

- (UIView *)sectionHeaderAtPoint:(CGPoint)pt
{
    for (UIView *sectionHeader in self.sectionHeaders) {
        if (CGRectContainsPoint(sectionHeader.frame, pt)) {
            return sectionHeader;
        }
    }
    
    return nil;
}

@end
