      PROGRAM MOON
          implicit none
          REAL *8,DIMENSION(6) :: PO                !�������
          INTEGER :: B                              !Ŀ��������
          INTEGER :: C                              !����������    
          INTEGER :: YEAR=2017                      !��
          INTEGER :: MONTH=8                        !��
          INTEGER :: DAY=7                          !��
          REAL*8 :: DDAY                            !��С������
          INTEGER :: HOUR                           !ʱ
          INTEGER :: MIN                            !��
          REAL*8 :: SECOND                          !��
          REAL *8 :: DJM0                           !������1
          REAL *8 :: DJM                            !������2
          INTEGER :: J                              !״̬
          INTEGER :: NDP=3                          !С����λ��
          INTEGER ,DIMENSION(4) :: IHMSF            !ʱ����С��������
          CHARACTER :: SIGN                         !������
          CHARACTER*6 :: nams                       !��������
          REAL *8::vals                             !����ֵ
          REAL *8::iteration_val=1.0/(24*3600)      !ѭ����������1sΪ������
          REAL *8::ERR                              !�ǶȲ�ж��Ƿ���ʳ��
          REAL *8::ASUN                             !̫���뾶
          REAL *8::RE                               !�������뾶
          REAL *8::AM                               !����뾶
          REAL *8::CLIGHT                           !����
          REAL *8::AU                               !���ĵ�λ          
          REAL *8,DIMENSION(3)::E2S                 !���վ���
          REAL *8,DIMENSION(3)::E2O                 !������Ӱ׶����
          REAL *8,DIMENSION(3)::E2M                 !���¾���
          REAL *8,DIMENSION(3)::M2O                 !������Ӱ׶�ľ���
          REAL *8,DIMENSION(3)::S2M                 !����ʸ��
          REAL *8::ANGLE_EOM                        !��׶�½Ƕ�
          REAL *8::ANGLE_EO                         !��׶��
          REAL *8::ANGLE_MO                         !��׶��
          REAL *8::PRODUCT                          !�ڻ�
!************************��������**************************
          nams='AU'         !���ĵ�λ
          CALL selconQ(nams,vals)
          AU=VALS          
          nams='ASUN'       !̫���뾶
          CALL selconQ(nams,vals)
          ASUN=VALS/AU          
          nams='RE'         !����뾶
          CALL selconQ(nams,vals)
          RE=(VALS+65D0)/AU        
          nams='AM'         !����뾶
          CALL selconQ(nams,vals)
          AM=VALS/AU          
          nams='CLIGHT'     !����
          CALL selconQ(nams,vals)
          CLIGHT=VALS/AU
          
          CALL iau_CAL2JD ( YEAR, MONTH, DAY, DJM0, DJM, J )    !������תΪ������
!***********************ѭ������**************************
     DO
         B=11    !̫��
         C=3     !����
         CALL PLEPH(DJM0+DJM, B, C, PO)       !����ʸ��
         CALL PLEPH(DJM0+DJM-((SQRT(PO(1)*PO(1)+PO(2)*PO(2)+PO(3)*PO(3))-ASUN-RE)*iteration_val)/CLIGHT, B, C, PO)!��Լ8����ǰ�յ�ʸ������
         E2S(1)=PO(1)                      !����ʸ��
         E2S(2)=PO(2)
         E2S(3)=PO(3)         
         E2O(1)=(RE/(RE-ASUN))*E2S(1)      !��׶ʸ��
         E2O(2)=(RE/(RE-ASUN))*E2S(2)
         E2O(3)=(RE/(RE-ASUN))*E2S(3)

         B=10   !����
         C=3    !����
         CALL PLEPH(DJM0+DJM, B, C, PO)
         E2M(1)=PO(1)            !��������ʸ��
         E2M(2)=PO(2)
         E2M(3)=PO(3)
         M2O(1)=E2O(1)-E2M(1)    !����׶��ʸ��
         M2O(2)=E2O(2)-E2M(2)
         M2O(3)=E2O(3)-E2M(3)
         CALL iau_PDP (E2O,M2O,PRODUCT)      !���ڻ�
         ANGLE_EOM=ACOS(PRODUCT/(SQRT(E2O(1)*E2O(1)+E2O(2)*E2O(2)+E2O(3)*E2O(3))*SQRT(M2O(1)*M2O(1)+M2O(2)*M2O(2)+M2O(3)*M2O(3))))
         ANGLE_EO=ASIN(RE/SQRT(E2O(1)*E2O(1)+E2O(2)*E2O(2)+E2O(3)*E2O(3)))
         ANGLE_MO=ASIN(AM/SQRT(M2O(1)*M2O(1)+M2O(2)*M2O(2)+M2O(3)*M2O(3)))
         ERR=ANGLE_EOM-ANGLE_EO-ANGLE_MO       !��Ƕ�֮��
         DJM=DJM+iteration_val    !����������1s
         IF(ERR.LE.0D0) EXIT      !�˿�ERRС��0����ʱ��ERR_LASE����0ʱ�˳�         
     END DO
!*************************������******************************     
         CALL iau_JD2CAL ( DJM0, DJM, YEAR, MONTH, DAY, DDAY, J )     !������תΪ������
         DDAY=DDAY-(32.164+37)*iteration_val               !תΪUCT
         CALL sla_DD2TF (NDP, DDAY, SIGN, IHMSF)           !С����תΪʱ����С����.
         WRITE (*,*)'����ʱ�䣺'
         WRITE (*,*) YEAR,'��',MONTH,'��',DAY,'��',IHMSF(1),':',IHMSF(2),':',IHMSF(3)+IHMSF(4)/1000.0   !������
        
      END PROGRAM MOON

