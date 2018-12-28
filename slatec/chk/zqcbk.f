*DECK ZQCBK
      SUBROUTINE ZQCBK (LUN, KPRINT, IPASS)
C***BEGIN PROLOGUE  ZQCBK
C***SUBSIDIARY
C***PURPOSE  Quick check for SLATEC subroutine
C            ZBESK
C***LIBRARY   SLATEC
C***CATEGORY  C10B4
C***TYPE      COMPLEX (CQCBK-C, ZQCBK-Z)
C***KEYWORDS  QUICK CHECK, ZBESK
C***AUTHOR  Amos, Don, (SNL)
C           Goudy, Sue, (SNL)
C           Walton, Lee, (SNL)
C***DESCRIPTION
C
C *Usage:
C
C        INTEGER  LUN, KPRINT, IPASS
C
C        CALL ZQCBK (LUN, KPRINT, IPASS)
C
C *Arguments:
C
C     LUN    :IN  is the unit number to which output is to be written.
C
C     KPRINT :IN  controls the amount of output, as specified in the
C                 SLATEC Guidelines.
C
C     IPASS  :OUT indicates whether the test passed or failed.
C                 A value of one is good, indicating no failures.
C
C *Description:
C
C                  *** A DOUBLE PRECISION ROUTINE ***
C
C   ZQCBK is a quick check routine for the complex K Bessel function
C    generated by subroutine ZBESK.
C
C   ZQCBK generates sequences of I and K Bessel functions from
C    ZBESI and ZBESK and checks them against the Wronskian evaluation
C    in the (Z,FNU) space.
C
C***REFERENCES  Abramowitz, M. and Stegun, I. A., Handbook
C                 of Mathematical Functions, Dover Publications,
C                 New York, 1964.
C               Amos, D. E., A Subroutine Package for Bessel
C                 Functions of a Complex Argument and Nonnegative
C                 Order, SAND85-1018, May, 1985.
C***ROUTINES CALLED  ZBESI, ZBESK, ZABS, ZDIV, ZEXP, I1MACH, D1MACH
C***REVISION HISTORY  (YYMMDD)
C   830501  DATE WRITTEN
C   890831  Revised to meet new SLATEC standard
C   930122  Added ZEXP to EXTERNAL Statement.  (RWC)
C***END PROLOGUE  ZQCBK
C
C*Internal Notes:
C   Machine constants are defined by functions I1MACH and D1MACH.
C
C   The parameter MQC can have values 1 (the default) for a faster,
C   less definitive test or 2 for a slower, more definitive test.
C
C**End
C
C  Set test complexity parameter.
C
      INTEGER  MQC
      PARAMETER (MQC=1)
C
C  Declare arguments.
C
      INTEGER  LUN, KPRINT, IPASS
C
C  Declare external functions.
C
      INTEGER  I1MACH
      DOUBLE PRECISION  D1MACH, ZABS
      EXTERNAL  I1MACH, D1MACH, ZABS, ZEXP
C
C  Declare local variables.
C
      DOUBLE PRECISION  CONER,CONEI, CSGNR,CSGNI, CVR,CVI, CWR,CWI,
     *   CYR,CYI, WR,WI, YR,YI, ZR,ZI, ZNR,ZNI
      DOUBLE PRECISION  AA, AB, AER, ALIM, ARG, ATOL, AXX, CT, DIG,
     *   ELIM, EPS, ER, ERTOL, FFNU, FILM, FNU, FNUL, HPI, PI, R, RL,
     *   RM, R1M4, R1M5, R2, SLAK, ST, STI, STR, T, TOL, TS, XNU
      INTEGER  I, ICASE, IERR, IFNU, IL, IR, IRB, IT, ITL, K, KDO, KEPS,
     *   KK, KODE, K1, K2, LFLG, MFLG, N, NL, NU, NUL, NZ1, NZ2, N1
      DIMENSION  AER(20), KDO(20), KEPS(20), T(20), WR(20), WI(20),
     *   XNU(20), YR(20), YI(20)
C
C***FIRST EXECUTABLE STATEMENT  ZQCBK
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99999)
99999   FORMAT (' QUICK CHECK ROUTINE FOR THE K BESSEL FUNCTION FROM ',
     *     'ZBESK'/)
      ENDIF
C-----------------------------------------------------------------------
C     Set parameters related to machine constants.
C     TOL is the approximate unit roundoff limited to 1.0D-18.
C     ELIM is the approximate exponential over- and underflow limit.
C     exp(-ELIM).lt.exp(-ALIM)=exp(-ELIM)/TOL    and
C     exp(ELIM).gt.exp(ALIM)=exp(ELIM)*TOL       are intervals near
C     underflow and overflow limits where scaled arithmetic is done.
C     RL is the lower boundary of the asymptotic expansion for large Z.
C     DIG = number of base 10 digits in TOL = 10**(-DIG).
C     FNUL is the lower boundary of the asymptotic series for large FNU.
C-----------------------------------------------------------------------
      R1M4 = D1MACH(4)
      TOL = MAX(R1M4,1.0D-18)
      ATOL = 100.0D0*TOL
      AA = -LOG10(R1M4)
      K1 = I1MACH(12)
      K2 = I1MACH(13)
      R1M5 = D1MACH(5)
      K = MIN(ABS(K1),ABS(K2))
      ELIM = 2.303D0*(K*R1M5-3.0D0)
      AB = AA*2.303D0
      ALIM = ELIM + MAX(-AB,-41.45D0)
      DIG = MIN(AA,18.0D0)
      FNUL = 10.0D0 + 6.0D0*(DIG-3.0D0)
      RL = 1.2D0*DIG + 3.0D0
      SLAK = 3.0D0+4.0D0*(-LOG10(TOL)-7.0D0)/11.0D0
      SLAK = MAX(SLAK,3.0D0)
      ERTOL = TOL*10.0D0**SLAK
      RM = 0.5D0*(ALIM + ELIM)
      RM = MIN(RM,200.0D0)
      RM = MAX(RM,RL+10.0D0)
      R2 = MIN(RM,FNUL)
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99998)
99998   FORMAT (' PARAMETERS'/
     *     5X,'TOL ',8X,'ELIM',8X,'ALIM',8X,'RL  ',8X,'FNUL',8X,'DIG')
        WRITE (LUN,99997) TOL, ELIM, ALIM, RL, FNUL, DIG
99997   FORMAT (1X,6D12.4/)
      ENDIF
C-----------------------------------------------------------------------
C     Set other constants needed in the tests.
C-----------------------------------------------------------------------
      CONER = 1.0D0
      CONEI = 0.0D0
      HPI = 2.0D0*ATAN(1.0D0)
      PI = HPI + HPI
C-----------------------------------------------------------------------
C     Generate angles for construction of complex Z to be used in tests.
C-----------------------------------------------------------------------
C     KDO(K), K = 1,IL  determines which of the IL angles in -PI to PI
C     are used to compute values of Z.
C       KDO(K) = 0  means that the index K will be used for one or two
C                   values of Z, depending on the choice of KEPS(K)
C              = 1  means that the index K and the corresponding angle
C                   will be skipped
C     KEPS(K), K = 1,IL determines which of the angles get incremented
C     up and down to put values of Z in regions where different
C     formulae are used.
C       KEPS(K)  = 0  means that the angle will be used without change
C                = 1  means that the angle will be incremented up and
C                   down by EPS
C     The angles to be used are stored in the T(I) array, I = 1,ITL.
C-----------------------------------------------------------------------
      IF (MQC.NE.2) THEN
        NL = 2
        IL = 5
        DO 5 I = 1,IL
          KEPS(I) = 0
          KDO(I) = 0
    5   CONTINUE
        NUL = 5
        XNU(1) = 0.0D0
        XNU(2) = 1.0D0
        XNU(3) = 2.0D0
        XNU(4) = 0.5D0*FNUL
        XNU(5) = FNUL + 1.1D0
      ELSE
        NL = 4
        IL = 13
        DO 6 I = 1,IL
          KDO(I) = 0
          KEPS(I) = 0
    6   CONTINUE
        KDO(2) = 1
        KDO(6) = 1
        KDO(8) = 1
        KDO(12) = 1
        KEPS(3) = 1
        KEPS(4) = 1
        KEPS(5) = 1
        KEPS(9) = 1
        KEPS(10) = 1
        KEPS(11) = 1
        NUL = 6
        XNU(1) = 0.0D0
        XNU(2) = 0.6D0
        XNU(3) = 1.3D0
        XNU(4) = 2.0D0
        XNU(5) = 0.5D0*FNUL
        XNU(6) = FNUL + 1.1D0
      ENDIF
      I = 2
      EPS = 0.01D0
      FILM = IL - 1
      T(1) = -PI + EPS
      DO 30 K = 2,IL
        IF (KDO(K).EQ.0) THEN
          T(I) = PI*(-IL+2*K-1)/FILM
          IF (KEPS(K).NE.0) THEN
            TS = T(I)
            T(I) = TS - EPS
            I = I + 1
            T(I) = TS + EPS
          ELSE
            I = I + 1
          ENDIF
        ENDIF
   30 CONTINUE
      ITL = I - 1
C-----------------------------------------------------------------------
C     Test values of Z IN -PI.lt.arg(Z).le.PI near formula boundaries.
C-----------------------------------------------------------------------
      IF (KPRINT.GE.2) THEN
        WRITE (LUN,99996)
99996   FORMAT (' CHECKS IN THE (Z,FNU) SPACE')
      ENDIF
      LFLG = 0
      DO 200 KODE = 1,2
        DO 190 N = 1,NL
          N1 = N + 1
          DO 180 NU = 1,NUL
            FNU = XNU(NU)
            IFNU = INT(FNU)
            FFNU = FNU - IFNU
            ARG = PI*FFNU
            CSGNR = COS(ARG)
            CSGNI = SIN(ARG)
            IF (MOD(IFNU,2).EQ.1) THEN
              CSGNR = -CSGNR
              CSGNI = -CSGNI
            ENDIF
            DO 170 ICASE = 1,3
              IRB = MIN(2,ICASE)
              DO 160 IR = IRB,4
C-------------- switch (icase)
                GO TO (50, 60, 70), ICASE
   50           CONTINUE
                  R = (EPS*(4-IR)+2.0D0*(IR-1))/3.0D0
                  GO TO 80
   60           CONTINUE
                  R = (2.0D0*(4-IR)+R2*(IR-1))/3.0D0
                  GO TO 80
   70           CONTINUE
                  IF (R2.GE.RM) GO TO 170
                  R = (R2*(4-IR)+RM*(IR-1))/3.0D0
   80           CONTINUE
C-------------- end switch
                DO 150 IT = 1,ITL
                  CT = COS(T(IT))
                  ST = SIN(T(IT))
                  IF (ABS(CT).LT.ATOL) CT = 0.0D0
                  IF (ABS(ST).LT.ATOL) ST = 0.0D0
                  ZR = R*CT
                  ZI = R*ST
                  CALL ZBESI(ZR, ZI, FNU, KODE, N1, WR, WI, NZ2, IERR)
C---------------- Underflow? - skip test for this case.
                  IF (NZ2.NE.0) GO TO 150
C-----------------------------------------------------------------------
C     In the left half plane, the analytic continuation formula for K
C     introduces an I function. The dominant terms in the Wronskian
C     I(FNU,Z)*I(FNU+1,Z) cancel out, giving losses of significance.
C     This cancellation can be done analytically to give a Wronskian in
C     terms of I in the left half plane and K in the right half plane.
C-----------------------------------------------------------------------
                  IF (ICASE.EQ.1.OR.CT.GE.0.0D0) THEN
C------------------ Z is in the right half plane
                    CALL ZBESK(ZR, ZI, FNU, KODE, N1, YR, YI, NZ1, IERR)
                    CALL ZDIV(CONER, CONEI, ZR, ZI, CVR, CVI)
                    IF (KODE.EQ.2) THEN
C-------------------- Adjust Wronskian due to scaled I and K functions
                      AXX = ABS(ZR)
                      ZNR = -AXX
                      ZNI = 0.0D0
                      CVR = ZNR + ZR
                      CVI = ZNI + ZI
                      CALL ZEXP(CVR, CVI, STR, STI)
                      CALL ZDIV(STR, STI, ZR, ZI, CVR, CVI)
                    ENDIF
                  ELSE
C------------------ Z is in the left half plane
                    ZNR = -ZR
                    ZNI = -ZI
                    CALL ZBESK(ZNR, ZNI, FNU, KODE, N1, YR, YI, NZ1,
     *                 IERR)
                    ZNR = CSGNR
                    ZNI = CSGNI
C------------------ CSGNR and CSGNI set near top of DO 180 loop
                  IF (ST.GT.0.0D0 .OR. (ST.EQ.0.0D0.AND.CT.LT.0.0D0))
     *                ZNI = -ZNI
                    DO 90 KK = 1,N1
                      STR = YR(KK)*ZNR - YI(KK)*ZNI
                      YI(KK) = YR(KK)*ZNI + YI(KK)*ZNR
                      YR(KK) = STR
                      ZNR = -ZNR
                      ZNI = -ZNI
   90               CONTINUE
                    CALL ZDIV(CONER, CONEI, ZR, ZI, CVR, CVI)
                    IF (KODE.EQ.2) THEN
C-------------------- Adjust Wronskian due to scaled I and K functions
                      AXX = ABS(ZR)
                      ZNR = -AXX
                      ZNI = 0.0D0
                      CVR = ZNR - ZR
                      CVI = ZNI - ZI
                      CALL ZEXP(CVR, CVI, STR, STI)
                      CALL ZDIV(STR, STI, ZR, ZI, CVR, CVI)
                    ENDIF
                  ENDIF
                  MFLG = 0
                  DO 130 I = 1,N
                    CWR = WR(I)*YR(I+1) - WI(I)*YI(I+1)
                    CWI = WR(I)*YI(I+1) + WI(I)*YR(I+1)
                    CYR = WR(I+1)*YR(I) - WI(I+1)*YI(I)
                    CYI = WR(I+1)*YI(I) + WI(I+1)*YR(I)
                    CYR = CYR + CWR - CVR
                    CYI = CYI + CWI - CVI
                    ER = ZABS(CYR,CYI)/ZABS(CVR,CVI)
                    AER(I) = ER
                    IF (ER.GT.ERTOL) THEN
                      MFLG = 1
                    ENDIF
  130             CONTINUE
                  IF (MFLG.NE.0) THEN
                    IF (LFLG.EQ.0) THEN
                      IF (KPRINT.GE.2) THEN
                        WRITE (LUN,99995) ERTOL
99995                   FORMAT (/' CASES WHICH OR VIOLATE THE RELATIVE',
     *                     ' ERROR TEST WITH ERTOL = ',D12.4/)
                        WRITE (LUN,99994)
99994                   FORMAT (' INPUT TO ZBESK   Z, FNU, KODE, N')
                      ENDIF
                      IF (KPRINT.GE.3) THEN
                        WRITE (LUN,99993)
99993                   FORMAT (' ERROR TEST ON THE WRONSKIAN OF ',
     *                     'ZBESI(Z,FNU) AND ZBESK(Z,FNU)')
                        WRITE (LUN,99992)
99992                   FORMAT (' RESULTS FROM ZBESK   NZ1, Y(KK)'/,
     *                     ' RESULTS FROM ZBESI   NZ2, W(KK)')
                        WRITE (LUN,99991)
99991                   FORMAT (' TEST CASE INDICES   IT, IR, ICASE'/)
                      ENDIF
                    ENDIF
                    LFLG = LFLG + 1
                    IF (KPRINT.GE.2) THEN
                      WRITE (LUN,99990) ZR, ZI, FNU, KODE, N
99990                 FORMAT ('   INPUT:    Z=',2D12.4,4X,'FNU=',D12.4,
     *                   4X,'KODE=',I3,4X,'N=',I3)
                    ENDIF
                    IF (KPRINT.GE.3) THEN
                      WRITE (LUN,99989) (AER(K),K=1,N)
99989                 FORMAT ('   ERROR:  AER(K)=',4D12.4)
                      KK = MAX(NZ1,NZ2) + 1
                      KK = MIN(N,KK)
                      WRITE (LUN,99988) NZ1, YR(KK), YI(KK),
     *                   NZ2, WR(KK), WI(KK)
99988                 FORMAT (' RESULTS:  NZ1=',I3,4X,'Y(KK)=',2D12.4,
     *                   /11X,'NZ2=',I3,4X,'W(KK)=',2D12.4)
                      WRITE (LUN,99987) IT, IR, ICASE
99987                 FORMAT ('    CASE:   IT=',I3,4X,'IR=',I3,4X,
     *                   'ICASE=',I3/)
                    ENDIF
                  ENDIF
  150           CONTINUE
  160         CONTINUE
  170       CONTINUE
  180     CONTINUE
  190   CONTINUE
  200 CONTINUE
      IF (KPRINT.GE.2) THEN
        IF (LFLG.EQ.0) THEN
          WRITE (LUN,99986)
99986     FORMAT (' QUICK CHECKS OK')
        ELSE
          WRITE (LUN,99985) LFLG
99985     FORMAT (' ***',I5,' FAILURE(S) FOR ZBESK NEAR FORMULA ',
     *       'BOUNDARIES')
        ENDIF
      ENDIF
      IPASS = 0
      IF (LFLG.EQ.0) THEN
        IPASS = 1
      ENDIF
      IF (IPASS.EQ.1.AND.KPRINT.GE.2) THEN
        WRITE (LUN,99984)
99984   FORMAT (/' ****** ZBESK  PASSED ALL TESTS  ******'/)
      ENDIF
      IF (IPASS.EQ.0.AND.KPRINT.GE.1) THEN
        WRITE (LUN,99983)
99983   FORMAT (/' ****** ZBESK  FAILED SOME TESTS ******'/)
      ENDIF
      RETURN
      END
