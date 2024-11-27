
#===============================================================================
# Build boot & jsdcc tool
#===============================================================================
echo "## Start of build_linux_samsung.sh ##"

echo "Allow writing to nhlos for building bootloader"
chmod u+w -R ../../../../

cd ../..
BOOT_IMAGES_DIR=`pwd`
BUILD_DIR=$BOOT_IMAGES_DIR/build/ms

cd $BOOT_IMAGES_DIR/..
NHLOS_ROOT_DIR=`pwd`

cd $NHLOS_ROOT_DIR/trustzone_images/build/ms
TZ_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/rpm_proc/build
RPM_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/debug_image/build/ms
SDI_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/adsp_proc/build
ADSP_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/common/build
COMM_BUILD_DIR=`pwd`

#cd $NHLOS_ROOT_DIR/wcnss_proc/build/ms
#WCNSS_BUILD_DIR=`pwd`

# delete mbn files
rm -rf $BUILD_DIR/bin/GAAAANAA
rm -rf $BUILD_DIR/bin/8084

#create new BUILD_ID folder
mkdir -p $BUILD_DIR/bin/GAAAANAA

#for model define
cd $BUILD_DIR

export $*

SECURE_NAME=''

DEFINE()
{
	DEFINE_NAME=$1
	DEFINE_VALUE=$2
	echo 'DEFINE : '$DEFINE_NAME' VALUE='$DEFINE_VALUE
	echo '#define '$DEFINE_NAME'	'$DEFINE_VALUE >> board.h
}

MAKE_MODEL_DEFINE()
{
	echo 'T_MODEL='$T_MODEL
	echo 'T_CARRIER='$T_CARRIER

	if [ -f board.h ] ; then
		rm board.h
	fi

	if [ ! "$T_MODEL" == "" ] ; then
		echo '#define BOARD_'$T_MODEL'_'$T_CARRIER'	1' > board.h	
	fi

	## COMMON Defines
	DEFINE SEC_SMPL_FEATURE 1
	DEFINE SEC_FOTA_FEATURE 1
	DEFINE SEC_DEBUG_FEATURE 1
	DEFINE SEC_READ_PARAM_FEATURE 1
	DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1

	## Model Defines
	# SECURE_NAME/SMPL Setting
	echo 'BUILD : '$T_MODEL'_'$T_CARRIER
	MODEL_NAME=MODEL_NAME_NOT_DEFINED
	QUALCOMM_SECURE_BOOT=disable
	case $T_MODEL'_'$T_CARRIER in
		LENTISLTE_KOR_SKT)
			MODEL_NAME=SM-G906S_KOR_SKC
			QUALCOMM_SECURE_BOOT=enable
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_BAM_DMB_SPI 1
			;;
		LENTISLTE_KOR_KTT)
			MODEL_NAME=SM-G906K_KOR_KTC
			QUALCOMM_SECURE_BOOT=enable
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_BAM_DMB_SPI 1
			;;
		LENTISLTE_KOR_LGT)
			MODEL_NAME=SM-G906L_KOR_LUC
			QUALCOMM_SECURE_BOOT=enable
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_BAM_DMB_SPI 1
			;;
		TRLTE_USA_ATT)
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			;;
		TRLTE_USA_USC)
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			;;
		TRLTE_USA_TMO)
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			;;
		TRLTE_USA_VZW)
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			;;
		TRLTE_USA_SPR)
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			;;
		TRLTE_CAN_OPEN)
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			;;
		# Default
		*)
			echo "use default define value"
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			;;
	esac

	## Model Defines
	echo 'BUILD : '$T_MODEL
	case $T_MODEL in

		LENTISLTE)
			DEFINE HW_REV_0 119
			DEFINE HW_REV_1 125
			DEFINE HW_REV_2 126
			DEFINE HW_REV_3 127
			DEFINE SEC_HWREV_WIFI_LDO27 7
			;;
	
		# Default
		*)
			echo "use default define value"
			;;
	esac

	## Secure Boot Defines
	echo 'Start of Secure Boot Setting'
	
	# MRC(CSB) signing setting
	echo 'SEC_BUILD_OPTION_KNOX_CSB: '$SEC_BUILD_OPTION_KNOX_CSB
	echo 'SEC_BUILD_OPTION_KNOX_CERT_TYPE: '$SEC_BUILD_OPTION_KNOX_CERT_TYPE
	if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
		if [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxa" ]]; then
			DEFINE CERT_HASH_INDEX	0xE1000000
			CSB_SUFFIX=ROOT1
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxb" ]]; then
			DEFINE CERT_HASH_INDEX	0xD2000000
			CSB_SUFFIX=ROOT2
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxc" ]]; then
			DEFINE CERT_HASH_INDEX	0xC3000000
			CSB_SUFFIX=ROOT3
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxd" ]]; then
			DEFINE CERT_HASH_INDEX	0xB4000000
			CSB_SUFFIX=ROOT4
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxe" ]]; then
			DEFINE CERT_HASH_INDEX	0xA5000000
			CSB_SUFFIX=ROOT5
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxf" ]]; then
			DEFINE CERT_HASH_INDEX	0x96000000
			CSB_SUFFIX=ROOT6
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxg" ]]; then
			DEFINE CERT_HASH_INDEX	0x87000000
			CSB_SUFFIX=ROOT7
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxh" ]]; then
			DEFINE CERT_HASH_INDEX	0x78000000
			CSB_SUFFIX=ROOT8
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxi" ]]; then
			DEFINE CERT_HASH_INDEX	0x69000000
			CSB_SUFFIX=ROOT9
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxj" ]]; then
			DEFINE CERT_HASH_INDEX	0x5A000000
			CSB_SUFFIX=ROOT10
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxk" ]]; then
			DEFINE CERT_HASH_INDEX	0x4B000000
			CSB_SUFFIX=ROOT11
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxl" ]]; then
			DEFINE CERT_HASH_INDEX	0x3C000000
			CSB_SUFFIX=ROOT12
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxm" ]]; then
			DEFINE CERT_HASH_INDEX	0x2D000000
			CSB_SUFFIX=ROOT13
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxn" ]]; then
			DEFINE CERT_HASH_INDEX	0x1E000000
			CSB_SUFFIX=ROOT14
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxo" ]]; then
			DEFINE CERT_HASH_INDEX	0x0F000000
			CSB_SUFFIX=ROOT15
		else 
			DEFINE CERT_HASH_INDEX	0
			CSB_SUFFIX=ROOT0
		fi
	else
		DEFINE CERT_HASH_INDEX	0
		CSB_SUFFIX=ROOT0
	fi

	# Check Secureboot option
	echo 'QUALCOMM_SECURE_BOOT: '$QUALCOMM_SECURE_BOOT
	echo 'MODEL_NAME: '$MODEL_NAME
	FINAL_SECURE_BOOT_DISABLE=true
	if [[ "$QUALCOMM_SECURE_BOOT" == "enable" ]] ; then
		if [[ "$MODEL_NAME" != "MODEL_NAME_NOT_DEFINED" ]] ; then
			if [[ "$SEC_BUILD_OPTION_KNOX_CSB" == "true" ]]; then
				echo 'Secure Boot Fusing is Enable by build option -B'
				FINAL_SECURE_BOOT_DISABLE=false
			else
				echo 'No secure boot option -B'
			fi

		else
			echo 'Secure Boot Setting Error:  MODEL_NAME_NOT_DEFINED'
		fi
	else
		echo 'Secure Boot Setting is NOT Enable'
	fi

	# Set Secureboot
	echo 'Final secure boot disable is '$FINAL_SECURE_BOOT_DISABLE
	if [[ "$FINAL_SECURE_BOOT_DISABLE" == "true" ]] ; then
		#secure boot fusing
		DEFINE SEC_SECURE_FUSE 0
		DEFINE SEC_SECURE_FUSE_NO_DEBUG 0

		#secure boot signing
		SECURE_NAME=SECUREBOOT_NOT_DEFINED
	else
		#secure boot fusing
		DEFINE SEC_SECURE_FUSE 1
		DEFINE SEC_SECURE_FUSE_NO_DEBUG 1

		#secure boot signing
		SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
	fi

	echo 'SECURE_NAME: '$SECURE_NAME
	echo 'End of Secure Boot Setting'
}

QPSA_SIGNING()
{
  if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
    cd $COMM_BUILD_DIR
    SIGN_LOG_FILE=$BUILD_DIR/build-log.txt
    echo "5-NHLOS build: Secure boot 3.0 signing" | tee -a ${SIGN_LOG_FILE}

    ##### Bootloader secureboot signing : sbl1, tz, rpm, sdi, appsboot, emmcbld
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sbl1 -input $BUILD_DIR/bin/8084/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8084/unsigned/signed_sbl1.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sbl1 -input $BUILD_DIR/bin/8084/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8084/unsigned/signed_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8084/unsigned/signed_sbl1.mbn ] ; then
      mkdir -p $BUILD_DIR/bin/8084/qcom_signed
      mv $BUILD_DIR/bin/8084/sbl1.mbn $BUILD_DIR/bin/8084/qcom_signed/
      mv $BUILD_DIR/bin/8084/unsigned/signed_sbl1.mbn $BUILD_DIR/bin/8084/sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    if [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" != "" ]] ; then
   	echo "java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_qpsa_sbl1 -input $BUILD_DIR/bin/8084/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8084/unsigned/sbl1_root0.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_qpsa_sbl1 -input $BUILD_DIR/bin/8084/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8084/unsigned/sbl1_root0.mbn | tee -a ${SIGN_LOG_FILE}
	if [ -f $BUILD_DIR/bin/8084/unsigned/sbl1_root0.mbn ] ; then
		mkdir -p $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE | tee -a ${SIGN_LOG_FILE}
	      	mv $BUILD_DIR/bin/8084/unsigned/sbl1_root0.mbn $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn | tee -a ${SIGN_LOG_FILE}

	      	openssl dgst -sha256 -binary $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn > sig_32
		java -jar signclient.jar -runtype ss_openssl_sha -model ${MODEL_NAME}_ROOT0 -input sig_32 -output sig_256 | tee -a ${SIGN_LOG_FILE}
		cat $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn sig_256 > $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_sbl1.mbn
		rm sig_32 -f
		rm sig_256 -f
		if [ -f $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_sbl1.mbn ] ; then
			mv $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1_CSB_signed.mbn | tee -a ${SIGN_LOG_FILE}
			mv $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_sbl1.mbn $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn | tee -a ${SIGN_LOG_FILE}

			cd $BUILD_DIR/bin/8084/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE
			tar -cvf SBL1_takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE.tar sbl1.mbn | tee -a ${SIGN_LOG_FILE}
			cd $COMM_BUILD_DIR
		else
			echo "securedownload signing error for takeover signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
    	else
      		echo "secureboot signing error for takeover signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tz -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tz -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_tz.mbn ] ; then
      mkdir -p $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed
      mv $TZ_BUILD_DIR/bin/GAAAANAA/tz.mbn $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_tz.mbn $TZ_BUILD_DIR/bin/GAAAANAA/tz.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn ] ; then
      mkdir -p $RPM_BUILD_DIR/ms/bin/AAAAANAAR/qcom_signed
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/qcom_signed/
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_rpm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_htelfsdi -input $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned/sdi.mbn -output $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned/signed_sdi.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_htelfsdi -input $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned/sdi.mbn -output $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned/signed_sdi.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned/signed_sdi.mbn ] ; then
      mkdir -p $SDI_BUILD_DIR/bin/AAAAANAZ/qcom_signed
      mv $SDI_BUILD_DIR/bin/AAAAANAZ/sdi.mbn $SDI_BUILD_DIR/bin/AAAAANAZ/qcom_signed/
      mv $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned/signed_sdi.mbn $SDI_BUILD_DIR/bin/AAAAANAZ/sdi.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sdi.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/signed_emmc_appsboot.mbn ] ; then
      mv $BUILD_DIR/emmc_appsboot.mbn $BUILD_DIR/bin/8084/unsigned/aboot.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/signed_emmc_appsboot.mbn $BUILD_DIR/bin/GAAAANAA/aboot.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_emmc_appsboot.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_emmcbld -input $BUILD_DIR/bin/8084/unsigned/MPRG8084.mbn -output $BUILD_DIR/bin/8084/unsigned/signed_MPRG8084.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_emmcbld -input $BUILD_DIR/bin/8084/unsigned/MPRG8084.mbn -output $BUILD_DIR/bin/8084/unsigned/signed_MPRG8084.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8084/unsigned/signed_MPRG8084.mbn ] ; then
      mv $BUILD_DIR/bin/8084/MPRG8084.mbn $BUILD_DIR/bin/8084/qcom_signed/
      mv $BUILD_DIR/bin/8084/unsigned/signed_MPRG8084.mbn $BUILD_DIR/bin/8084/MPRG8084.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_MPRG8084.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    ##### Non-HLOS(subsystem) secureboot signing : wcnss, adsp, venus
#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_wcnss -input $WCNSS_BUILD_DIR/bin/8084/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/8084/signed_wcnss.mbn" | tee -a ${SIGN_LOG_FILE}
#    if [ -f $WCNSS_BUILD_DIR/bin/8084/wcnss.mbn ] ; then
#		chmod 0644 $WCNSS_BUILD_DIR/bin/8084/wcnss.mbn
#		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_wcnss -input $WCNSS_BUILD_DIR/bin/8084/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/8084/signed_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
#		if [ -f $WCNSS_BUILD_DIR/bin/8084/signed_wcnss.mbn ] ; then
#		  mv $WCNSS_BUILD_DIR/bin/8084/wcnss.mbn $WCNSS_BUILD_DIR/bin/8084/unsigned_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
#		  mv $WCNSS_BUILD_DIR/bin/8084/signed_wcnss.mbn $WCNSS_BUILD_DIR/bin/8084/wcnss.mbn | tee -a ${SIGN_LOG_FILE}
#		else
#		  echo "secureboot signing error for signed_wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
#		fi
#	fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_adsp -input $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn -output $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_adsp -input $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn -output $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn ] ; then
      mv $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/unsigned_dsp2.mbn | tee -a ${SIGN_LOG_FILE}
      mv $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_adsp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_venus -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_venus.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_venus -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_venus.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_venus.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/venus.mbn $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_venus.mbn $TZ_BUILD_DIR/bin/GAAAANAA/venus.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_venus.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    ##### Non-HLOS(tzapps) secureboot signing : cmnlib, isdbtmm, playready, sshdcpapp, sec_storage, devauth, widevine, mc_v2, tima_pkm, tima_lkm, prov, skm, keymaster, dtcpip
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_cmnlib -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_cmnlib.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_cmnlib -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_cmnlib.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/cmnlib.mbn $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_cmnlib.mbn $TZ_BUILD_DIR/bin/GAAAANAA/cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_cmnlib.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_isdbtmm -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_isdbtmm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_isdbtmm -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_isdbtmm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/isdbtmm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_isdbtmm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_isdbtmm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_playready -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_playready.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_playready -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_playready.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_playready.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/playready.mbn $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_playready.mbn $TZ_BUILD_DIR/bin/GAAAANAA/playready.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_playready.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [[ "$DTCPIP_ENABLED" == 1 ]] ; then
      echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/GAAAANAA/dtcpip.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_dtcpip.mbn" | tee -a ${SIGN_LOG_FILE}
      java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/GAAAANAA/dtcpip.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_dtcpip.mbn ] ; then
        mv $TZ_BUILD_DIR/bin/GAAAANAA/dtcpip.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
        mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_dtcpip.mbn $TZ_BUILD_DIR/bin/GAAAANAA/dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      else
        echo "secureboot signing error for signed_dtcpip.mbn!" | tee -a ${SIGN_LOG_FILE}
      fi
    fi

    #sshdcpapp.mbn isn't exist qcom signing binary.
    mv $TZ_BUILD_DIR/bin/GAAAANAA/sshdcpapp.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_playready -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sshdcpapp -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_sshdcpapp.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/GAAAANAA/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_widevine -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_widevine.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_widevine -input $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_widevine.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_widevine.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/widevine.mbn $TZ_BUILD_DIR/bin/GAAAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/GAAAANAA/unsigned/signed_widevine.mbn $TZ_BUILD_DIR/bin/GAAAANAA/widevine.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_widevine.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sec_storage -input $TZ_BUILD_DIR/bin/GAAAANAA/sec_storage.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sec_storage -input $TZ_BUILD_DIR/bin/GAAAANAA/sec_storage.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_sec_storage.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/sec_storage.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/GAAAANAA/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/GAAAANAA/devauth.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_devauth.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/GAAAANAA/devauth.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_devauth.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_devauth.mbn ] ; then
#      mv $TZ_BUILD_DIR/bin/GAAAANAA/devauth.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_devauth.mbn | tee -a ${SIGN_LOG_FILE}
#      mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_devauth.mbn $TZ_BUILD_DIR/bin/GAAAANAA/devauth.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

    ## IF TIMA_ENABLED, signing tima_pkm, tima_lkm
    if [[ "$TIMA_ENABLED" == "1" ]] ; then
	  ##++++++++++++++++++++ temporarily rename tima_*.mbn to lkmauth, tima for signing
	  cp -v -f $TZ_BUILD_DIR/bin/GAAAANAA/tima_lkm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/lkmauth.mbn
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_lkmauth -input $TZ_BUILD_DIR/bin/GAAAANAA/lkmauth.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_lkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/GAAAANAA/lkmauth.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_lkmauth.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_lkm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_lkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tima_pkm -input $TZ_BUILD_DIR/bin/GAAAANAA/tima_pkm.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_pkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/GAAAANAA/tima_pkm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_pkm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_pkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tima_atn -input $TZ_BUILD_DIR/bin/GAAAANAA/tima_atn.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_atn.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/GAAAANAA/tima_atn.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_atn.mbn $TZ_BUILD_DIR/bin/GAAAANAA/tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_atn.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tima_key -input $TZ_BUILD_DIR/bin/GAAAANAA/tima_key.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_key.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/GAAAANAA/tima_key.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_tima_key.mbn $TZ_BUILD_DIR/bin/GAAAANAA/tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_key.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

          if [[ "$TIMA_VERSION" == "3" ]] ; then
 	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tz_ccm -input $TZ_BUILD_DIR/bin/GAAAANAA/tz_ccm.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_tz_ccm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/GAAAANAA/tz_ccm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
            		mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_tz_ccm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tz_ccm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
          fi
	  ##++++++++++++++++++++
    ################
	fi
#
#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/GAAAANAA/mc_v2.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_mc_v2.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/GAAAANAA/mc_v2.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_mc_v2.mbn ] ; then
#      mv $TZ_BUILD_DIR/bin/GAAAANAA/mc_v2.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
#      mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_mc_v2.mbn $TZ_BUILD_DIR/bin/GAAAANAA/mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi
#
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_prov -input $TZ_BUILD_DIR/bin/GAAAANAA/prov.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_prov.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_prov -input $TZ_BUILD_DIR/bin/GAAAANAA/prov.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_prov.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_prov.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/prov.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_prov.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_prov.mbn $TZ_BUILD_DIR/bin/GAAAANAA/prov.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prov.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skm -input $TZ_BUILD_DIR/bin/GAAAANAA/skm.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_skm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skm -input $TZ_BUILD_DIR/bin/GAAAANAA/skm.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_skm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_skm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/GAAAANAA/skm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_skm.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_skm.mbn $TZ_BUILD_DIR/bin/GAAAANAA/skm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_keymaster -input $TZ_BUILD_DIR/bin/GAAAANAA/keymaster.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_keymaster.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_keymaster -input $TZ_BUILD_DIR/bin/GAAAANAA/keymaster.mbn -output $TZ_BUILD_DIR/bin/GAAAANAA/signed_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $TZ_BUILD_DIR/bin/GAAAANAA/signed_keymaster.mbn ] ; then
#      mv $TZ_BUILD_DIR/bin/GAAAANAA/keymaster.mbn $TZ_BUILD_DIR/bin/GAAAANAA/unsigned_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
#      mv $TZ_BUILD_DIR/bin/GAAAANAA/signed_keymaster.mbn $TZ_BUILD_DIR/bin/GAAAANAA/keymaster.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi
  fi
}

MAKE_EMERGENCY_TOOL()
{
	echo "make emergency download packages"
	cd $NHLOS_ROOT_DIR/common/tools/emergency_download
	mkdir -p IMAGES/
	cp -v $BUILD_DIR/bin/GAAAANAA/sbl1.mbn IMAGES/
	cp -v $BUILD_DIR/bin/GAAAANAA/rpm.mbn IMAGES/
	cp -v $BUILD_DIR/bin/GAAAANAA/tz.mbn IMAGES/
	cp -v $BUILD_DIR/bin/GAAAANAA/sdi.mbn IMAGES/
	
	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
		cp -v $BUILD_DIR/bin/GAAAANAA/aboot.mbn IMAGES/
		cp -v $BUILD_DIR/bin/GAAAANAA/MPRG8084.mbn IMAGES/
	else	
		cp -v $BUILD_DIR/emmc_appsboot.mbn IMAGES/aboot.mbn
		cp -v $BUILD_DIR/bin/GAAAANAA/MPRG8084.mbn IMAGES/
	fi
}

MAKE_MODEL_DEFINE

echo "1-NHLOS build: build rpm on $PROJECT_NAME"
cd $RPM_BUILD_DIR
./buildss.sh || exit 1

echo "2-NHLOS build: build trustzone"
cd $TZ_BUILD_DIR
#./build.sh CHIPSET=msm8084 tz playready widevine drmprov isdbtmm tzbsp_no_xpu sampleapp securitytest
./buildss.sh $SECURE_NAME || exit 1

echo "3-NHLOS build: build sbl image"
cd $BUILD_DIR
./buildss.sh || exit 1

echo "4-NHLOS build: build sdi(system debug image)"
cd $SDI_BUILD_DIR
./buildss.sh || exit 1

echo "5-NHLOS build: build adsp"
cd $ADSP_BUILD_DIR
./buildss.sh || exit 1

# Secure Boot Signing
QPSA_SIGNING

cd $BUILD_DIR
cp -v -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/* $BUILD_DIR/bin/GAAAANAA/
cp -v -f $TZ_BUILD_DIR/bin/GAAAANAA/* $BUILD_DIR/bin/GAAAANAA/
cp -v -f $BUILD_DIR/bin/8084/* $BUILD_DIR/bin/GAAAANAA/
cp -v -f $SDI_BUILD_DIR/bin/AAAAANAZ/* $BUILD_DIR/bin/GAAAANAA/
cp -v -f $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/* $BUILD_DIR/bin/GAAAANAA/

MAKE_EMERGENCY_TOOL

echo "## End of build_linux_samsung.sh ##"
