*DECK DTBMV
      SUBROUTINE DTBMV (UPLO, TRANS, DIAG, N, K, A, LDA, X, INCX)
C***BEGIN PROLOGUE  DTBMV
C***PURPOSE  Perform one of the matrix-vector operations.
C***LIBRARY   SLATEC (BLAS)
C***CATEGORY  D1B4
C***TYPE      DOUBLE PRECISION (STBMV-S, DTBMV-D, CTBMV-C)
C***KEYWORDS  LEVEL 2 BLAS, LINEAR ALGEBRA
C***AUTHOR  Dongarra, J. J., (ANL)
C           Du Croz, J., (NAG)
C           Hammarling, S., (NAG)
C           Hanson, R. J., (SNLA)
C***DESCRIPTION
C
C  DTBMV  performs one of the matrix-vector operations
C
C     x := A*x,   or   x := A'*x,
C
C  where x is an n element vector and  A is an n by n unit, or non-unit,
C  upper or lower triangular band matrix, with ( k + 1) diagonals.
C
C  Parameters
C  ==========
C
C  UPLO   - CHARACTER*1.
C           On entry, UPLO specifies whether the matrix is an upper or
C           lower triangular matrix as follows:
C
C              UPLO = 'U' or 'u'   A is an upper triangular matrix.
C
C              UPLO = 'L' or 'l'   A is a lower triangular matrix.
C
C           Unchanged on exit.
C
C  TRANS  - CHARACTER*1.
C           On entry, TRANS specifies the operation to be performed as
C           follows:
C
C              TRANS = 'N' or 'n'   x := A*x.
C
C              TRANS = 'T' or 't'   x := A'*x.
C
C              TRANS = 'C' or 'c'   x := A'*x.
C
C           Unchanged on exit.
C
C  DIAG   - CHARACTER*1.
C           On entry, DIAG specifies whether or not A is unit
C           triangular as follows:
C
C              DIAG = 'U' or 'u'   A is assumed to be unit triangular.
C
C              DIAG = 'N' or 'n'   A is not assumed to be unit
C                                  triangular.
C
C           Unchanged on exit.
C
C  N      - INTEGER.
C           On entry, N specifies the order of the matrix A.
C           N must be at least zero.
C           Unchanged on exit.
C
C  K      - INTEGER.
C           On entry with UPLO = 'U' or 'u', K specifies the number of
C           super-diagonals of the matrix A.
C           On entry with UPLO = 'L' or 'l', K specifies the number of
C           sub-diagonals of the matrix A.
C           K must satisfy  0 .le. K.
C           Unchanged on exit.
C
C  A      - DOUBLE PRECISION array of DIMENSION ( LDA, n ).
C           Before entry with UPLO = 'U' or 'u', the leading ( k + 1 )
C           by n part of the array A must contain the upper triangular
C           band part of the matrix of coefficients, supplied column by
C           column, with the leading diagonal of the matrix in row
C           ( k + 1 ) of the array, the first super-diagonal starting at
C           position 2 in row k, and so on. The top left k by k triangle
C           of the array A is not referenced.
C           The following program segment will transfer an upper
C           triangular band matrix from conventional full matrix storage
C           to band storage:
C
C                 DO 20, J = 1, N
C                    M = K + 1 - J
C                    DO 10, I = MAX( 1, J - K ), J
C                       A( M + I, J ) = matrix( I, J )
C              10    CONTINUE
C              20 CONTINUE
C
C           Before entry with UPLO = 'L' or 'l', the leading ( k + 1 )
C           by n part of the array A must contain the lower triangular
C           band part of the matrix of coefficients, supplied column by
C           column, with the leading diagonal of the matrix in row 1 of
C           the array, the first sub-diagonal starting at position 1 in
C           row 2, and so on. The bottom right k by k triangle of the
C           array A is not referenced.
C           The following program segment will transfer a lower
C           triangular band matrix from conventional full matrix storage
C           to band storage:
C
C                 DO 20, J = 1, N
C                    M = 1 - J
C                    DO 10, I = J, MIN( N, J + K )
C                       A( M + I, J ) = matrix( I, J )
C              10    CONTINUE
C              20 CONTINUE
C
C           Note that when DIAG = 'U' or 'u' the elements of the array A
C           corresponding to the diagonal elements of the matrix are not
C           referenced, but are assumed to be unity.
C           Unchanged on exit.
C
C  LDA    - INTEGER.
C           On entry, LDA specifies the first dimension of A as declared
C           in the calling (sub) program. LDA must be at least
C           ( k + 1 ).
C           Unchanged on exit.
C
C  X      - DOUBLE PRECISION array of dimension at least
C           ( 1 + ( n - 1 )*abs( INCX ) ).
C           Before entry, the incremented array X must contain the n
C           element vector x. On exit, X is overwritten with the
C           transformed vector x.
C
C  INCX   - INTEGER.
C           On entry, INCX specifies the increment for the elements of
C           X. INCX must not be zero.
C           Unchanged on exit.
C
C***REFERENCES  Dongarra, J. J., Du Croz, J., Hammarling, S., and
C                 Hanson, R. J.  An extended set of Fortran basic linear
C                 algebra subprograms.  ACM TOMS, Vol. 14, No. 1,
C                 pp. 1-17, March 1988.
C***ROUTINES CALLED  LSAME, XERBLA
C***REVISION HISTORY  (YYMMDD)
C   861022  DATE WRITTEN
C   910605  Modified to meet SLATEC prologue standards.  Only comment
C           lines were modified.  (BKS)
C***END PROLOGUE  DTBMV
C     .. Scalar Arguments ..
      INTEGER            INCX, K, LDA, N
      CHARACTER*1        DIAG, TRANS, UPLO
C     .. Array Arguments ..
      DOUBLE PRECISION   A( LDA, * ), X( * )
C     .. Parameters ..
      DOUBLE PRECISION   ZERO
      PARAMETER        ( ZERO = 0.0D+0 )
C     .. Local Scalars ..
      DOUBLE PRECISION   TEMP
      INTEGER            I, INFO, IX, J, JX, KPLUS1, KX, L
      LOGICAL            NOUNIT
C     .. External Functions ..
      LOGICAL            LSAME
      EXTERNAL           LSAME
C     .. External Subroutines ..
      EXTERNAL           XERBLA
C     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN
C***FIRST EXECUTABLE STATEMENT  DTBMV
C
C     Test the input parameters.
C
      INFO = 0
      IF     ( .NOT.LSAME( UPLO , 'U' ).AND.
     $         .NOT.LSAME( UPLO , 'L' )      )THEN
         INFO = 1
      ELSE IF( .NOT.LSAME( TRANS, 'N' ).AND.
     $         .NOT.LSAME( TRANS, 'T' ).AND.
     $         .NOT.LSAME( TRANS, 'C' )      )THEN
         INFO = 2
      ELSE IF( .NOT.LSAME( DIAG , 'U' ).AND.
     $         .NOT.LSAME( DIAG , 'N' )      )THEN
         INFO = 3
      ELSE IF( N.LT.0 )THEN
         INFO = 4
      ELSE IF( K.LT.0 )THEN
         INFO = 5
      ELSE IF( LDA.LT.( K + 1 ) )THEN
         INFO = 7
      ELSE IF( INCX.EQ.0 )THEN
         INFO = 9
      END IF
      IF( INFO.NE.0 )THEN
         CALL XERBLA( 'DTBMV ', INFO )
         RETURN
      END IF
C
C     Quick return if possible.
C
      IF( N.EQ.0 )
     $   RETURN
C
      NOUNIT = LSAME( DIAG, 'N' )
C
C     Set up the start point in X if the increment is not unity. This
C     will be  ( N - 1 )*INCX   too small for descending loops.
C
      IF( INCX.LE.0 )THEN
         KX = 1 - ( N - 1 )*INCX
      ELSE IF( INCX.NE.1 )THEN
         KX = 1
      END IF
C
C     Start the operations. In this version the elements of A are
C     accessed sequentially with one pass through A.
C
      IF( LSAME( TRANS, 'N' ) )THEN
C
C         Form  x := A*x.
C
         IF( LSAME( UPLO, 'U' ) )THEN
            KPLUS1 = K + 1
            IF( INCX.EQ.1 )THEN
               DO 20, J = 1, N
                  IF( X( J ).NE.ZERO )THEN
                     TEMP = X( J )
                     L    = KPLUS1 - J
                     DO 10, I = MAX( 1, J - K ), J - 1
                        X( I ) = X( I ) + TEMP*A( L + I, J )
   10                CONTINUE
                     IF( NOUNIT )
     $                  X( J ) = X( J )*A( KPLUS1, J )
                  END IF
   20          CONTINUE
            ELSE
               JX = KX
               DO 40, J = 1, N
                  IF( X( JX ).NE.ZERO )THEN
                     TEMP = X( JX )
                     IX   = KX
                     L    = KPLUS1  - J
                     DO 30, I = MAX( 1, J - K ), J - 1
                        X( IX ) = X( IX ) + TEMP*A( L + I, J )
                        IX      = IX      + INCX
   30                CONTINUE
                     IF( NOUNIT )
     $                  X( JX ) = X( JX )*A( KPLUS1, J )
                  END IF
                  JX = JX + INCX
                  IF( J.GT.K )
     $               KX = KX + INCX
   40          CONTINUE
            END IF
         ELSE
            IF( INCX.EQ.1 )THEN
               DO 60, J = N, 1, -1
                  IF( X( J ).NE.ZERO )THEN
                     TEMP = X( J )
                     L    = 1      - J
                     DO 50, I = MIN( N, J + K ), J + 1, -1
                        X( I ) = X( I ) + TEMP*A( L + I, J )
   50                CONTINUE
                     IF( NOUNIT )
     $                  X( J ) = X( J )*A( 1, J )
                  END IF
   60          CONTINUE
            ELSE
               KX = KX + ( N - 1 )*INCX
               JX = KX
               DO 80, J = N, 1, -1
                  IF( X( JX ).NE.ZERO )THEN
                     TEMP = X( JX )
                     IX   = KX
                     L    = 1       - J
                     DO 70, I = MIN( N, J + K ), J + 1, -1
                        X( IX ) = X( IX ) + TEMP*A( L + I, J )
                        IX      = IX      - INCX
   70                CONTINUE
                     IF( NOUNIT )
     $                  X( JX ) = X( JX )*A( 1, J )
                  END IF
                  JX = JX - INCX
                  IF( ( N - J ).GE.K )
     $               KX = KX - INCX
   80          CONTINUE
            END IF
         END IF
      ELSE
C
C        Form  x := A'*x.
C
         IF( LSAME( UPLO, 'U' ) )THEN
            KPLUS1 = K + 1
            IF( INCX.EQ.1 )THEN
               DO 100, J = N, 1, -1
                  TEMP = X( J )
                  L    = KPLUS1 - J
                  IF( NOUNIT )
     $               TEMP = TEMP*A( KPLUS1, J )
                  DO 90, I = J - 1, MAX( 1, J - K ), -1
                     TEMP = TEMP + A( L + I, J )*X( I )
   90             CONTINUE
                  X( J ) = TEMP
  100          CONTINUE
            ELSE
               KX = KX + ( N - 1 )*INCX
               JX = KX
               DO 120, J = N, 1, -1
                  TEMP = X( JX )
                  KX   = KX      - INCX
                  IX   = KX
                  L    = KPLUS1  - J
                  IF( NOUNIT )
     $               TEMP = TEMP*A( KPLUS1, J )
                  DO 110, I = J - 1, MAX( 1, J - K ), -1
                     TEMP = TEMP + A( L + I, J )*X( IX )
                     IX   = IX   - INCX
  110             CONTINUE
                  X( JX ) = TEMP
                  JX      = JX   - INCX
  120          CONTINUE
            END IF
         ELSE
            IF( INCX.EQ.1 )THEN
               DO 140, J = 1, N
                  TEMP = X( J )
                  L    = 1      - J
                  IF( NOUNIT )
     $               TEMP = TEMP*A( 1, J )
                  DO 130, I = J + 1, MIN( N, J + K )
                     TEMP = TEMP + A( L + I, J )*X( I )
  130             CONTINUE
                  X( J ) = TEMP
  140          CONTINUE
            ELSE
               JX = KX
               DO 160, J = 1, N
                  TEMP = X( JX )
                  KX   = KX      + INCX
                  IX   = KX
                  L    = 1       - J
                  IF( NOUNIT )
     $               TEMP = TEMP*A( 1, J )
                  DO 150, I = J + 1, MIN( N, J + K )
                     TEMP = TEMP + A( L + I, J )*X( IX )
                     IX   = IX   + INCX
  150             CONTINUE
                  X( JX ) = TEMP
                  JX      = JX   + INCX
  160          CONTINUE
            END IF
         END IF
      END IF
C
      RETURN
C
C     End of DTBMV .
C
      END
