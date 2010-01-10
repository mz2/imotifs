//
//  BCDataMatrix.h
//  BioCocoa
//
//  Created by Scott Christley on 7/25/08.
//  Copyright (c) 2003-2009 The BioCocoa Project.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>

/*!
@header
@abstract Provides wrapper and utility methods for 2-dimensional data matrix. 
*/

#if 0
#pragma mark == ENCODING STRINGS ==
#endif

/*!
 @constant BCidEncode
 @abstract Encoding string for id (pointer) data type.
 */
FOUNDATION_EXPORT char * const BCidEncode;
/*!
 @constant BCintEncode
 @abstract Encoding string for integer data type.
 */
FOUNDATION_EXPORT char * const BCintEncode;
/*!
 @constant BCdoubleEncode
 @abstract Encoding string for double floating point data type.
 */
FOUNDATION_EXPORT char * const BCdoubleEncode;
/*!
 @constant BClongEncode
 @abstract Encoding string for long data type.
 */
FOUNDATION_EXPORT char * const BClongEncode;
/*!
 @constant BCboolEncode
 @abstract Encoding string for BOOL data type.
 */
FOUNDATION_EXPORT char * const BCboolEncode;

#if 0
#pragma mark == FORMAT STRINGS ==
#endif

/*!
 @constant BCParseColumnNames
 @abstract Indicator for parsing column headings.
 @discussion Key for format dictionary entry to indicate whether BCDataMatrix
 should parse column names when reading data matrix from file.  By default,
 BCDataMatrix assumes the file does not contain column names to be parsed.  Set
 the value to boolean YES or NO, as shown with the following code example:

 <pre>
 @textblock
BCDataMatrix *aDataMatrix = [BCDataMatrix dataMatrixWithContentsOfFile: aFile
	andEncode: BCdoubleEncode
	andFormat: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool: YES], BCParseColumnNames, nil]];

 @/textblock
 </pre>
 */
FOUNDATION_EXPORT NSString * const BCParseColumnNames;

/*!
 @constant BCParseRowNames
 @abstract Indicator for parsing row headings.
 @discussion Key for format dictionary entry to indicate whether BCDataMatrix
 should parse row names when reading data matrix from file.  By default,
 BCDataMatrix assumes the file does not contain row names to be parsed.  Set
 the value to boolean YES or NO, as shown with the following code example:

 <pre>
 @textblock
BCDataMatrix *aDataMatrix = [BCDataMatrix dataMatrixWithContentsOfFile: aFile
	andEncode: BCdoubleEncode
	andFormat: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool: YES], BCParseRowNames, nil]];

 @/textblock
 </pre>
 
 If parsing column names is also set, then BCDataMatrix assumes that the column
 containing the row names also has a column heading. 
 */
FOUNDATION_EXPORT NSString * const BCParseRowNames;

/*!
 @constant BCColumnNames
 @abstract Array of column headings.
 @discussion Key for format dictionary entry to provide an array of column
 names.  Useful if the data file does not provide column headings but would
 like to access columns by name instead of index.  Column names must be
 provided when parsing a data file in BCListFormat but are optional for a
 data file in BCMatrixFormat.
 */
FOUNDATION_EXPORT NSString * const BCColumnNames;

/*!
 @constant BCRowNames
 @abstract Array of row headings.
 @discussion Key for format dictionary entry to provide an array of row
 names.  Useful if the data file does not provide row headings but would
 like to access rows by name instead of index.  Row names must be
 provided when parsing a data file in BCListFormat but are optional for a
 data file in BCMatrixFormat.
 */
FOUNDATION_EXPORT NSString * const BCRowNames;

/*!
 @constant BCDataLayout
 @abstract Indicator for data layout.
 @discussion Key for format dictionary entry to indicate the layout
 of the data when reading from a file.  The value should be
 either BCMatrixFormat or BCListFormat.
 */
FOUNDATION_EXPORT NSString * const BCDataLayout;

/*!
 @constant BCMatrixFormat
 @abstract Indicate data file is in matrix format.
 @discussion Value for format dictionary entry to indicate the data
 in the file is in matrix format.  Matrix format assumes each line
 the data file corresponds to a row in the data matrix and each column
 in that row separate by BCSeparatorCharacterSet.  For example, the following data
 is in matrix form to produce a 4x3 matrix, 4 rows and 3 columns.
 <pre>
 @textblock
1	2	3
4	5	6
7	8	9
10	11	12
 @/textblock
 </pre>

 If the data layout is not specified, BCDataMatrix assumes the
 data file is in matrix format.
*/
FOUNDATION_EXPORT NSString * const BCMatrixFormat;

/*!
 @constant BCListFormat
 @abstract Indicate data file is in list format.
 @discussion Value for format dictionary entry to indicate the data
 in the file is in list format.  List format assumes each line
 the data file corresponds to a single matrix entry.  Each line in
 the data file has exactly 3 fields, separated by BCSeparatorCharacterSet, with
 the first field being the row name, second field being the column
 name, and the third field being the value for the matrix entry.
 For example, the following data is in list format to produce
 a 4x3 matrix, 4 rows and 3 columns.
 <pre>
 @textblock
r1	c1	1
r1	c2	2
r1	c3	3
r2	c2	5
r3	c1	7
r4	c3	12
 @/textblock
 </pre>

 BCRowNames and BCColumnNames must be provided to BCDataMatrix
 for reading data in list format.  The entries can be specified
 in any order, if a matrix entry appears more than once then the
 last value in the file is used.  Not all entries need to be
 provided, unspecified matrix entries will be left the default
 empty value.
*/
FOUNDATION_EXPORT NSString * const BCListFormat;

/*!
 @constant BCSeparatorCharacterSet
 @abstract Character set for separating entries.
 @discussion Key for format dictionary entry to specify the
 NSCharacterSet to be used for splitting matrix entries.  If
 no value is provided then [NSCharacterSet whitespaceCharacterSet]
 is used as the default character set.
*/
FOUNDATION_EXPORT NSString * const BCSeparatorCharacterSet;

/*!
    @class      BCDataMatrix
    @abstract   Wrapper class for 2-dimensional data matrix.
    @discussion This class provide a wrapper and convenience utility methods for
	managing a 2-dimensional data matrix.  The data matrix can be any standard C data type
	as well custom data types, and it is efficiently stored in memory.  Convenience methods
	include reading/writing the data from/to files, converting between row major and column
	major storage (for C or Fortran use) and obtaining submatrices.
*/

@interface BCDataMatrix : NSObject {
	unsigned int numOfRows;
	NSArray *rowNames;
	unsigned int numOfCols;
	NSArray *colNames;
	char *encode;
	void *dataMatrix;
	BOOL isColumnMajor;  // C is row major, Fortran is column major
}

#if 0
#pragma mark == ALLOCATION METHODS ==
#endif

/*!
	@method     emptyDataMatrixWithRows:andColumns:andEncode:
	@abstract   Create an empty data matrix.
	@discussion This method creates an empty BCDataMatrix with the specfied number
	of rows and column, using the specified encoding.
 */
+ (BCDataMatrix *)emptyDataMatrixWithRows: (unsigned int)rows andColumns: (unsigned int)cols andEncode: (char *)anEncode;

/*!
	@method     dataMatrixWithContentsOfFile:andEncode:
	@abstract   Create data matrix from contents of file.
	@discussion This method creates a BCDataMatrix with the data in the specified file.
	The data is assumed to be in the default layout which is BCMatrixFormat without
	row or column names.
 */
+ (BCDataMatrix *)dataMatrixWithContentsOfFile: (NSString *)aFile andEncode: (char *)anEncode;

/*!
	@method     dataMatrixWithContentsOfFile:andEncode:andFormat:
	@abstract   Create data matrix from contents of file.
	@discussion This method creates a BCDataMatrix with the data in the specified file.
	The layout of the data is specified with the format dictionary.  If the format
	dictionary parameter is nil then the default layout is assumed.
 */
+ (BCDataMatrix *)dataMatrixWithContentsOfFile: (NSString *)aFile andEncode: (char *)anEncode andFormat: (NSDictionary *)format;

/*!
	@method     dataMatrixWithRowMajorMatrix:numberOfRows:andColumns:andEncode:
	@abstract   Create data matrix from data.
	@discussion This method creates a BCDataMatrix with the provided data matrix.
	It is assumed the data matrix is C style matrix with values in row major form.
 */
+ (BCDataMatrix *)dataMatrixWithRowMajorMatrix: (void *)aMatrix numberOfRows: (unsigned int)rows
	andColumns: (unsigned int)cols andEncode: (char *)anEncode;

/*!
	@method     dataMatrixWithColumnMajorMatrix:numberOfRows:andColumns:andEncode:
	@abstract   Create data matrix from data.
	@discussion This method creates a BCDataMatrix with the provided data matrix.
	It is assumed the data matrix is FORTRAN style matrix with values in column major form.
 */
+ (BCDataMatrix *)dataMatrixWithColumnMajorMatrix: (void *)aMatrix numberOfRows: (unsigned int)rows
	andColumns: (unsigned int)cols andEncode: (char *)anEncode;

/*!
	@method     initEmptyDataMatrixWithRows:andColumns:andEncode:
	@abstract   Initialize an empty data matrix.
	@discussion This method initializes an empty BCDataMatrix with the specfied number
	of rows and column, using the specified encoding.
 */
- (BCDataMatrix *)initEmptyDataMatrixWithRows: (unsigned int)rows andColumns: (unsigned int)cols andEncode: (char *)anEncode;

/*!
	@method     initWithContentsOfFile:andEncode:
	@abstract   Initializes data matrix with contents of file.
	@discussion This method initializes a BCDataMatrix with the data in the specified file.
	The data is assumed to be in the default layout which is BCMatrixFormat without
	row or column names.
 */
- (BCDataMatrix *)initWithContentsOfFile: (NSString *)aFile andEncode: (char *)anEncode;

/*!
	@method     initWithContentsOfFile:andEncode:andFormat:
	@abstract   Initializes data matrix with contents of file.
	@discussion This method initializes a BCDataMatrix with the data in the specified file.
	The layout of the data is specified with the format dictionary.  If the format
	dictionary parameter is nil then the default layout is assumed.
 */
- (BCDataMatrix *)initWithContentsOfFile: (NSString *)aFile andEncode: (char *)anEncode andFormat: (NSDictionary *)format;

/*!
	@method     initWithRowMajorMatrix:numberOfRows:andColumns:andEncode:
	@abstract   Initializes data matrix from data.
	@discussion This method initializes a BCDataMatrix with the provided data matrix.
	It is assumed the data matrix is C-style matrix with values in row major form.
 */
- (BCDataMatrix *)initWithRowMajorMatrix: (void *)aMatrix numberOfRows: (unsigned int)rows
	andColumns: (unsigned int)cols andEncode: (char *)anEncode;

/*!
	@method     initWithColumnMajorMatrix:numberOfRows:andColumns:andEncode:
	@abstract   Initializes data matrix from data.
	@discussion This method initializes a BCDataMatrix with the provided data matrix.
	It is assumed the data matrix is FORTRAN-style matrix with values in column major form.
 */
- (BCDataMatrix *)initWithColumnMajorMatrix: (void *)aMatrix numberOfRows: (unsigned int)rows
	andColumns: (unsigned int)cols andEncode: (char *)anEncode;

/*!
	@method     numberOfRows
	@abstract   Returns number of rows in data matrix.
 */
- (unsigned int)numberOfRows;

/*!
	@method     numberOfColumns
	@abstract   Returns number of columns in data matrix.
 */
- (unsigned int)numberOfColumns;

/*!
	@method     dataMatrix
	@abstract   Returns the underlying memory allocation of the data matrix.
	@discussion	This method provides the underlying memory allocation of the data matrix to
	allow for fast access and updating of the matrix elements; the memory is allocated in a
	single contiguous block so the memory can be cast to a C-style matrix for simplified access.
	Be sure to use the proper encoding to access the matrix elements when casting the pointer,
	and check isColumnMajor if you need to support both C and FORTRAN layouts.  The following
	code shows a simple iterator assuming double encoding.
 <pre>
 @textblock
int numRows = [aDataMatrix numberOfRows];
int numCols = [aDataMatrix numberOfCols];
double (*grid)[numRows][numCols];
grid = [aDataMatrix dataMatrix];
for (i = 0; i < numRows; ++i)
	for (j = 0; j < numCols; ++j)
		(*grid)[i][j] = 1.0;
	
 @/textblock
 </pre>
 */
- (void *)dataMatrix;

/*!
	@method     matrixEncoding
	@abstract   Returns encoding string for data matrix.
 */
- (char *)matrixEncoding;

/*!
	@method     isColumnMajor
	@abstract   Returns data layout in underlying memory allocation.
	@discussion Returns YES if data is in FORTRAN-style column major format
	otherwise returns NO for data in C-style row major format.
 */
- (BOOL)isColumnMajor;

/*!
	@method     setColumnMajor:
	@abstract   Changes data layout in underlying memory allocation.
	@discussion C-style matrices are in row major form which means that all columns
	for a single row are contiguous in memory.  FORTRAN-style matrices are in column
	major form which means that all rows for a single column are contiguous in memory.
	This method can switch the memory layout from one format to the other.  This is
	a convenience method for mixed C and FORTRAN programs where data needs to be passed back and
	forth between C and FORTRAN functions.  By default, BCDataMatrix stores data
	in C-style row major format.
 */
- (void)setColumnMajor: (BOOL)aFlag;

/*!
	@method     dataMatrixFromRowRange:andColumnRange:
	@abstract   Returns new BCDataMatrix with subset of data matrix.
	@discussion This method extracts the specified sub-matrix and creates a new BCDataMatrix
	with the data from that sub-matrix.  Returns nil if the ranges are outside the bounds
	of the data matrix or if no row/column size is zero.  The new BCDataMatrix has the same
	data encoding and data layout with the number of rows and columns equal to the sizes
	of the specified ranges.
 */
- (BCDataMatrix *)dataMatrixFromRowRange: (NSRange)rows andColumnRange: (NSRange)cols;

@end
