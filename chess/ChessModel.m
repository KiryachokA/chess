//
//  ChessModel.m
//  iChess
//
//  Created by svetlana on 04.12.14.
//  Copyright (c) 2014 Aleksei. All rights reserved.


#import "ChessModel.h"
#import <UIKit/UIKit.h>

@implementation ChessModel

@synthesize figuresBlack;
@synthesize figuresWhite;
@synthesize selectCell = select;

-(id) init {
    self = [super init];
    if (self != nil) {
        
        collarMove = TRUE;
        select.x = -1;
        select.y = -1;
        
        figuresBlack = (NSMutableArray<IFigure>*)[NSMutableArray arrayWithCapacity: 16];
        figuresWhite = (NSMutableArray<IFigure>*)[NSMutableArray arrayWithCapacity: 16];
        
        
        [self initialize];
    }

    return self;
}


-(void) initialize {
     TypeFigure name[8] = {
         Rook,
         Horse,
         Elephant,
         Queen,      
         King,     
         Elephant,   
         Horse,
         Rook 
    };
    
    for (int i = 0; i < 8; ++i) {
        Figure *figureBlack = [[Figure alloc] initWithType:name[i] Color:Black];
        [figureBlack setPositionX:0 Y:i];
        [figuresBlack addObject:figureBlack];
        
        
        Figure *pawnBlack = [[Figure alloc] initWithType:Pawn Color:Black];
        [pawnBlack setPositionX:1 Y:i];
        [figuresBlack addObject:pawnBlack];
        
        
        Figure *figureWhite = [[Figure alloc] initWithType:name[i] Color:White];
        [figureWhite setPositionX:7 Y:i];
        [figuresWhite addObject:figureWhite];
        
        Figure *pawnWhite = [[Figure alloc] initWithType:Pawn Color:White];
        [pawnWhite setPositionX:6 Y:i];
        [figuresWhite addObject:pawnWhite];
    }
}


-(void) selectX:(int) i Y:(int) j {
    if(select.x == i && select.y == j) {
        select.x = -1;
        select.y = -1;
    }
    select.x = i;
    select.y = j;

}

-(BOOL) isSelect {
    if(select.x == -1 && select.y == -1)
        return FALSE;
    return TRUE;
}

-(void) useVk:(BOOL)vk {
    if(vk)
        useVk = TRUE;
    else
        useVk = FALSE;
}

-(Figure*) getFromX:(int) x Y:(int)y {
    for (int k = 0; k < [figuresWhite count]; ++k) {
        Figure* figure = [figuresWhite objectAtIndex:k];
        if ([figure getPosition].x == x && [figure getPosition].y == y) {
           NSLog(@"figuresBlack %d getFrom, %d, %d", k, x, y);
            return figure;
        }
    }
    for (int k = 0; k < [figuresBlack count]; ++k) {
        Figure* figure = [figuresBlack objectAtIndex:k];
        if([figure getPosition].x == x && [figure getPosition].y == y) {
            NSLog(@" figuresWhite %d getFrom, %d, %d", k, x, y);
            return figure ;
        }
    }
    return nil;
}

-(BOOL) isEmptyX:(int) i Y:(int) j {
    return ([self getFromX:i Y:j] == nil);
}


-(NSString*) moveToX:(int) i Y:(int) j {
    Figure *figure = [self getFromX: select.x Y:select.y];
    if (figure == nil) {
        return FALSE;
    }
    //tyt proverka idet na figyry i govorim mojet li ona poiti na vibranyy kletky
    NSString *fail = @"fail";
    CGPoint point = figure.getPosition;
    
    select.x = i;
    select.y = j;
    
    // pewka
    // pofiksit' hod nazad
    if (figure.type == Pawn) {
        if(figure.color == White && collarMove == TRUE) {
            if (point.x == 6 && j == point.y && (point.x - i) < 3) {
                [figure setPositionX:i Y:j];

                select.x=-1;
                select.y=-1;
                collarMove = FALSE;
                
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
                
            }
            else if(j == point.y && (point.x - i) == 1) // hod vpered
            {
                //ewe nado sbitee figuri i proverka na svobodnoe pole i za predeli polya
                // i ewe v prohod v verji
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else if((fabs(j - point.y)) && (point.x - i) == 1)
            {
                if(![self validatePawnFromX:point.x Y:point.y ToX:i Y:j]){
                    select.x=-1;
                    select.y=-1;
                    return fail;
                }
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                //ewe zvyk zapilit'
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        if(figure.color == Black && collarMove == FALSE) {
            if (point.x == 1 && j == point.y && (point.x - i) > -3) {
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else if(j == point.y && (point.x - i) == -1)
            {
                //ewe nado sbitee figuri i proverka na svobodnoe pole
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else if((fabs(j - point.y)) && (point.x - i) == -1)
            {
                if(![self validatePawnFromX:point.x Y:point.y ToX:i Y:j])
                {
                    select.x=-1;
                    select.y=-1;
                    return fail;
                }
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                //ewe zvyk zapilit'
                
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
    }
    
    // lad'ya
    if(figure.type == Rook){
        if(figure.color == White && collarMove == TRUE) {
            if(point.x == i || point.y == j) {
                if(![self validateRookFromX:point.x Y:point.y ToX:i Y:j])
                {
                    select.x=-1;
                    select.y=-1;
                    return fail;
                }
                //proverky na pole i zbitie figyri
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
    
        }
        if(figure.color == Black && collarMove == FALSE) {
            if(point.x == i || point.y == j) {
                //proverky na pole i zbitie figyri
                if(![self validateRookFromX:point.x Y:point.y ToX:i Y:j])
                {
                    select.x=-1;
                    select.y=-1;
                    return fail;
                }
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        
    }
    
    //kon'
    if(figure.type == Horse){
        if(figure.color == White && collarMove == TRUE) {
            if((fabs(point.x - i) + fabs(point.y - j) == 3) && point.x != i && point.y != j) {

                if(![self validateHouserFromX:point.x Y:point.y ToX:i Y:j])
                    return FALSE;
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
           
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
            
        }
        if(figure.color == Black && collarMove == FALSE) {
            if((fabs(point.x - i) + fabs(point.y - j) == 3) && point.x != i && point.y != j) {
                //proverky na pole i zbitie figyri
                if(![self validateHouserFromX:point.x Y:point.y ToX:i Y:j])
                    return FALSE;
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
             
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        
    }
    
    
    // slon
    if(figure.type == Elephant) {
        if(figure.color == White && collarMove == TRUE) {
            if(fabs(point.x - i) == fabs(point.y - j) && point.x != i && point.y != j) {
                //proverky na pole i zbitie figyri
                if(![self validateElephantFromX:point.x Y:point.y ToX:i Y:j])
                    return fail;

                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
               
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        if(figure.color == Black && collarMove == FALSE) {
            if(fabs(point.x - i) == fabs(point.y - j) && point.x != i && point.y != j) {
                //proverky na pole i zbitie figyri
                if(![self validateElephantFromX:point.x Y:point.y ToX:i Y:j])
                    return fail;
                

                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
              
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        
    }
    
    // ferz'
    if(figure.type == Queen){
        if(figure.color == White && collarMove == TRUE) {
            if((fabs(point.x - i) == fabs(point.y - j) && point.x != i && point.y != j)
                                || (point.x == i || point.y == j)) {
                //proverky na pole i zbitie figyri
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
              
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
            
        }
        if(figure.color == Black && collarMove == FALSE) {
            if((fabs(point.x - i) == fabs(point.y - j) && point.x != i && point.y != j)
                                    || (point.x == i || point.y == j)) {
                //proverky na pole i zbitie figyri
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
                
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        
    }
    
    // korol'
    if(figure.type == King){
        if(figure.color == White && collarMove == TRUE) {
            if(fabs(point.x - i) < 2 && fabs(point.y - j) < 2) {
                //proverky na pole i zbitie figyri i ewe rakirovky
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
               // [figuresBlack removeLastObject];
                collarMove = FALSE;
                int fromX = point.x;
                int fromY = point.y;
               
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
            
        }
        if(figure.color == Black && collarMove == FALSE) {
            if(fabs(point.x - i) < 2 && fabs(point.y - j) < 2) {
                //proverky na pole i zbitie figyri
                [figure setPositionX:i Y:j];
                select.x=-1;
                select.y=-1;
                collarMove = TRUE;
                int fromX = point.x;
                int fromY = point.y;
               
                return [NSString stringWithFormat:@"%d %d %d %d", fromX, fromY, i, j];
            }
            else {
                select.x=-1;
                select.y=-1;
                return fail;
            }
        }
        
    }


    
    //[figure setPositionX:i Y:j];
    
    select.x=-1;
    select.y=-1;
    
    return fail;
}

-(BOOL) checkForBlackToX:(int)i Y:(int)j
{
    for (int k =0; k <[figuresBlack count]; k++) {
        CGPoint point = [[figuresBlack objectAtIndex:k] getPosition];
        if( point.x == i && point.y == j)
            return TRUE;
    }
    return FALSE;
}

-(BOOL) checkForWhiteToX:(int)i Y:(int)j
{
    for (int k =0; k <[figuresWhite count]; k++) {
        CGPoint point = [[figuresWhite objectAtIndex:k] getPosition];
        if( point.x == i && point.y == j)
            return TRUE;
    }
    return FALSE;
}

-(BOOL) deleteWhiteFromX:(int)i Y:(int)j
{
    for (int k =0; k <[figuresWhite count]; k++) {
        CGPoint point = [[figuresWhite objectAtIndex:k] getPosition];
        if( point.x == i && point.y == j)
        {
            [figuresWhite removeObjectAtIndex:k];
            return TRUE;
        }
    }

    return FALSE;
}

-(BOOL) deleteBlackFromX:(int)i Y:(int)j
{
    for (int k =0; k <[figuresBlack count]; k++) {
        CGPoint point = [[figuresBlack objectAtIndex:k] getPosition];
        if( point.x == i && point.y == j)
        {
            [figuresBlack removeObjectAtIndex:k];
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL) validateHouserFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj
{
    Figure *figure = [self getFromX:i Y:j];
    if (figure == nil) {
        return FALSE;
    }

    if(figure.color == White)
    {
        if([self checkForBlackToX:ii Y:jj])
        {
            [self deleteBlackFromX:ii Y:jj];
            return TRUE;
        }
        if([self checkForWhiteToX:ii Y:jj])
        {
            return FALSE;
        }
        
    }
    if(figure.color == Black)
    {
        if([self checkForWhiteToX:ii Y:jj])
        {
            [self deleteWhiteFromX:ii Y:jj];
            return TRUE;
        }
        if([self checkForBlackToX:ii Y:jj])
        {
            return FALSE;
        }
    }
    return TRUE;
}

-(BOOL) validatePawnFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj
{
    Figure *figure = [self getFromX:i Y:j];
    if (figure == nil) {
        return FALSE;
    }
    
    if(figure.color == White)
    {
        if([self checkForBlackToX:ii Y:jj])
        {
            [self deleteBlackFromX:ii Y:jj];
            return TRUE;
        }
        if([self checkForWhiteToX:ii Y:jj])
        {
            return FALSE;
        }
        
    }
    if(figure.color == Black)
    {
        if([self checkForWhiteToX:ii Y:jj])
        {
            [self deleteWhiteFromX:ii Y:jj];
            return TRUE;
        }
        if([self checkForBlackToX:ii Y:jj])
        {
            return FALSE;
        }
    }
    return FALSE;
    
}


-(BOOL) validateRookFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj
{
    Figure *figure = [self getFromX:i Y:j];
    if (figure == nil) {
        return FALSE;
    }
    
    if(figure.color == White)
    {
        if(i > ii)
        {
            for (int k = i-1; k > ii-1; k--) {
                if(k == ii)
                    if([self checkForBlackToX:ii Y:j])
                    {
                        [self deleteBlackFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForBlackToX:k Y:j])
                    return FALSE;
                if([self checkForWhiteToX:k Y:j])
                    return FALSE;
                if([self checkForWhiteToX:ii Y:j])
                    return FALSE;
            }
        }
        
        if(i < ii)
        {
            for (int k = i+1; k < ii+1; k++) {
                if(k == ii)
                    if([self checkForBlackToX:ii Y:j])
                    {
                        [self deleteBlackFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForBlackToX:k Y:j])
                    return FALSE;
                if([self checkForWhiteToX:k Y:j])
                    return FALSE;
                if([self checkForWhiteToX:ii Y:j])
                    return FALSE;

            }
        }
        

        if(j > jj)
        {
            for (int k = j-1; k > jj-1; k--) {
                if(k == jj)
                    if([self checkForBlackToX:ii Y:jj])
                    {
                        [self deleteBlackFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForBlackToX:i Y:k])
                    return FALSE;
                if([self checkForWhiteToX:i Y:k])
                    return FALSE;
                if([self checkForWhiteToX:ii Y:jj])
                    return FALSE;

            }
        }
        
        if(j < jj)
        {
            
            for (int k = j+1; k < jj+1; k++) {
                if(k == jj)
                    if([self checkForBlackToX:ii Y:jj])
                    {
                        [self deleteBlackFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForBlackToX:i Y:k])
                    return FALSE;
                if([self checkForWhiteToX:j Y:k])
                    return FALSE;
                if([self checkForWhiteToX:ii Y:jj])
                    return FALSE;

            }
        }
    }
    
    if(figure.color == Black)
    {
        if(i > ii)
        {
            for (int k = i-1; k > ii-1; k--) {
                if(k == ii)
                    if([self checkForWhiteToX:ii Y:j])
                    {
                        [self deleteWhiteFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForWhiteToX:k Y:j])
                    return FALSE;
                if([self checkForBlackToX:k Y:j])
                    return FALSE;
                if([self checkForBlackToX:ii Y:j])
                    return FALSE;
            }
        }
        
        if(i < ii)
        {
            for (int k = i+1; k < ii+1; k++) {
                if(k == ii)
                    if([self checkForWhiteToX:ii Y:j])
                    {
                        [self deleteWhiteFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForWhiteToX:k Y:j])
                    return FALSE;
                if([self checkForBlackToX:k Y:j])
                    return FALSE;
                if([self checkForBlackToX:ii Y:j])
                    return FALSE;
                
            }
        }
        
        
        if(j > jj)
        {
            for (int k = j-1; k > jj-1; k--) {
                if(k == jj)
                    if([self checkForWhiteToX:ii Y:jj])
                    {
                        [self deleteWhiteFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForWhiteToX:i Y:k])
                    return FALSE;
                if([self checkForBlackToX:i Y:k])
                    return FALSE;
                if([self checkForBlackToX:ii Y:jj])
                    return FALSE;
                
            }
        }
        
        if(j < jj)
        {
            
            for (int k = j+1; k < jj+1; k++) {
                if(k == jj)
                    if([self checkForWhiteToX:ii Y:jj])
                    {
                        [self deleteWhiteFromX:ii Y:jj];
                        return TRUE;
                    }
                if([self checkForWhiteToX:i Y:k])
                    return FALSE;
                if([self checkForBlackToX:j Y:k])
                    return FALSE;
                if([self checkForBlackToX:ii Y:jj])
                    return FALSE;
                
            }
        }
    }
    
    return TRUE;
}



-(BOOL) validateElephantFromX:(int) i Y:(int) j ToX:(int) ii Y:(int) jj
{
    Figure *figure = [self getFromX:i Y:j];
    if (figure == nil) {
        return FALSE;
    }
    
    if(figure.color == White)
    {
        if(i > ii && j > jj)
        {
            for (int k = i-1; k > ii-1;) {
                for (int q = j-1; q > jj-1; q--)
                {
                    if(k == ii || q == jj)
                        if([self checkForBlackToX:ii Y:jj])
                        {
                            [self deleteBlackFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    k--;
                }
            }
        }
        
        if(i < ii && j < jj)
        {
            for (int k = i+1; k < ii+1;) {
                for (int q = j+1; q < jj+1; q++)
                {
                    if(k == ii || q == jj)
                        if([self checkForBlackToX:ii Y:jj])
                        {
                            [self deleteBlackFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    k++;
                }
            }

        }
        
        
        if(i < ii && j > jj)
        {
            for (int k = i+1; k < ii+1;) {
                for (int q = j-1; q > jj-1; q--)
                {
                    if(k == ii || q == jj)
                        if([self checkForBlackToX:ii Y:jj])
                        {
                            [self deleteBlackFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    k++;
                }
            }
            
        }

        if(i > ii && j < jj)
        {
            for (int k = i-1; k > ii-1;)
            {
                for (int q = j+1; q < jj+1; q++)
                {
                    if(k == ii || q == jj)
                        if([self checkForBlackToX:ii Y:jj])
                        {
                            [self deleteBlackFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    k--;
                }
            }
        }
    }
    
    if(figure.color == Black)
    {
        if(i > ii && j > jj)
        {
            for (int k = i-1; k > ii-1;) {
                for (int q = j-1; q > jj-1; q--)
                {
                    if(k == ii || q == jj)
                        if([self checkForWhiteToX:ii Y:jj])
                        {
                            [self deleteWhiteFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    k--;
                }
            }
        }
        
        if(i < ii && j < jj)
        {
            for (int k = i+1; k < ii+1;) {
                for (int q = j+1; q < jj+1; q++)
                {
                    if(k == ii || q == jj)
                        if([self checkForWhiteToX:ii Y:jj])
                        {
                            [self deleteWhiteFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    k++;
                }
            }
            
        }
        
        
        if(i < ii && j > jj)
        {
            for (int k = i+1; k < ii+1;) {
                for (int q = j-1; q > jj-1; q--)
                {
                    if(k == ii || q == jj)
                        if([self checkForWhiteToX:ii Y:jj])
                        {
                            [self deleteWhiteFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    k++;
                }
            }
            
        }
        
        if(i > ii && j < jj)
        {
            for (int k = i-1; k > ii-1;)
            {
                for (int q = j+1; q < jj+1; q++)
                {
                    if(k == ii || q == jj)
                        if([self checkForWhiteToX:ii Y:jj])
                        {
                            [self deleteWhiteFromX:ii Y:jj];
                            return TRUE;
                        }
                    if([self checkForWhiteToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    if([self checkForBlackToX:k Y:q])
                        return FALSE;
                    k--;
                }
            }
        }
    }
    
    return TRUE;

}

@end
