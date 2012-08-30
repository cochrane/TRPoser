//
//  TRRenderIndexUtilities.m
//  TR Poser
//
//  Created by Torsten Kammer on 31.08.12.
//  Copyright (c) 2012 Torsten Kammer. All rights reserved.
//

#include "TRRenderIndexUtilities.h"

void TRFillTriangle(uint16_t *array, unsigned long *elementsOffset, unsigned long *index, int isTwoSided)
{
	array[*elementsOffset+0] = *index + 0;
	array[*elementsOffset+1] = *index + 2;
	array[*elementsOffset+2] = *index + 1;
	*elementsOffset += 3;
	
	if (isTwoSided)
	{
		array[*elementsOffset+0] = *index + 0;
		array[*elementsOffset+1] = *index + 1;
		array[*elementsOffset+2] = *index + 2;
		*elementsOffset += 3;
	}
	*index += 3;
}

void TRFillRectangle(uint16_t *array, unsigned long *elementsOffset, unsigned long *index, int isTwoSided)
{
	array[*elementsOffset+0] = *index + 0;
	array[*elementsOffset+1] = *index + 2;
	array[*elementsOffset+2] = *index + 1;
	array[*elementsOffset+3] = *index + 3;
	array[*elementsOffset+4] = *index + 2;
	array[*elementsOffset+5] = *index + 0;
	*elementsOffset += 6;
	
	if (isTwoSided)
	{
		array[*elementsOffset+0] = *index + 0;
		array[*elementsOffset+1] = *index + 1;
		array[*elementsOffset+2] = *index + 2;
		array[*elementsOffset+3] = *index + 2;
		array[*elementsOffset+4] = *index + 3;
		array[*elementsOffset+5] = *index + 0;
		*elementsOffset += 6;
	}
	*index += 4;
}
