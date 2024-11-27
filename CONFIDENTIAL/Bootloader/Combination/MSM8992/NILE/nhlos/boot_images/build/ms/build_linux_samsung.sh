
#===============================================================================
# Build boot & jsdcc tool
#===============================================================================
echo "## Start of build_linux_samsung.sh ##"

echo "Allow writing to nhlos for building bootloader"
chmod u+w -R ../../../../nhlos

LK_DIR=../../../../android/bootable/bootloader/lk

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

cd $NHLOS_ROOT_DIR/common/build
COMM_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/adsp_proc/build/
ADSP_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/modem_proc/build/ms
MPSS_BUILD_DIR=`pwd`

#for model define
cd $BUILD_DIR

export $*

SECURE_NAME=''
# For Rollback Prevention.
ANTI_ROLLBACK_ENABLE=false
# For Testbit Binary
ANTI_ROLLBACK_IGNORE=false
# For CSB debugging purpose through JTAG.
SECURE_FUSE_DEBUG_ENABLE=false

DDR_SIZE=ONE_AND_HALF_GB

DEFINE()
{
	DEFINE_NAME=$1
	DEFINE_VALUE=$2
	echo 'DEFINE : '$DEFINE_NAME' VALUE='$DEFINE_VALUE
	echo '#define '$DEFINE_NAME'	'$DEFINE_VALUE >> board.h
}

DEFINE_TIMA()
{
	DEFINE_NAME=$1
	DEFINE_VALUE=$2
	echo 'DEFINE_TIMA : '$DEFINE_NAME' VALUE='$DEFINE_VALUE
	echo '#define '$DEFINE_NAME'	'$DEFINE_VALUE >> tima_config.h
}

MAKE_MODEL_DEFINE()
{
	echo 'T_MODEL='$T_MODEL
	echo 'T_CARRIER='$T_CARRIER
	echo 'T_TARGET='$T_TARGET

	if [ -f board.h ] ; then
		rm board.h
	fi

	if [ -f tima_config.h ] ; then
		rm tima_config.h
	fi

	if [ -f $TZ_BUILD_DIR/tima_config.h ] ; then
		rm $TZ_BUILD_DIR/tima_config.h
	fi

	if [ ! "$T_MODEL" == "" ] ; then
		echo '#define BOARD_'$T_MODEL'_'$T_CARRIER'	1' > board.h
	fi

	## COMMON Defines
	DEFINE SEC_FOTA_FEATURE 1
	DEFINE SEC_DEBUG_FEATURE 1
	SEC_BAM_TZ_DISABLE_SPI=1

	## Model Defines
	# SECURE_NAME/SMPL Setting
	echo 'BUILD : '$T_MODEL'_'$T_CARRIER
	MODEL_NAME=MODEL_NAME_NOT_DEFINED
	QUALCOMM_SECURE_BOOT=disable
	case $T_MODEL'_'$T_CARRIER in
		PHILIPPELTE_CHN_CMCC)
			MODEL_NAME=SM-G9198_CHN_ZM
			QUALCOMM_SECURE_BOOT=enable
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE ZERO_ERR 1
			DEFINE SEC_ENABLE_LVS2 1
			;;
		# Default
		*)
			echo "use default define value"
			MODEL_NAME=MODEL_NAME_NOT_DEFINED
			QUALCOMM_SECURE_BOOT=disable
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
	esac

	## COMMON Defines to support variables
	DEFINE BAM_TZ_DISABLE_SPI $SEC_BAM_TZ_DISABLE_SPI

	## Model Defines
	echo 'BUILD : '$T_MODEL
	case $T_MODEL'_'$T_CARRIER in
		PHILIPPELTE_CHN_CMCC)
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

	## default RKP is disabled
	TIMA_RKP_DISABLED=true

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
	
	# FixMe : after refactoring of code related with memory,
        #            below TIMA_ENABLED value should be changed
	DEFINE_TIMA TIMA_BASE_ADDR			0x06400000
	DEFINE_TIMA TIMA_VPCR_ADDR			TIMA_BASE_ADDR
	DEFINE_TIMA TIMA_VPCR_SIZE			0x1000
	DEFINE_TIMA TIMA_BOOT_MEASUREMENT_ADDR		"(TIMA_VPCR_ADDR + 0x20)"
	DEFINE_TIMA TIMA_GOLDEN_MEASUREMENT_ADDR	"(TIMA_VPCR_ADDR + 0x800)"
	DEFINE_TIMA RKP_DASHBOARD_START			"(TIMA_BASE_ADDR + 0x1000)"
	DEFINE_TIMA RKP_DASHBOARD_SIZE			0x1000
	DEFINE_TIMA DASHBOARD_START			"(TIMA_BASE_ADDR + 0x2000)"
	DEFINE_TIMA DASHBOARD_SIZE			0x1000
	DEFINE_TIMA SEC_LOG_START			"(TIMA_BASE_ADDR + 0x3000)"
	DEFINE_TIMA SEC_LOG_SIZE			0x3D000
	DEFINE_TIMA RKP_SEC_LOG_START			"(TIMA_BASE_ADDR + 0x40000)"
	DEFINE_TIMA RKP_SEC_LOG_SIZE			"(1<<18)"
	DEFINE_TIMA PGTBL_LOG_START			"(TIMA_BASE_ADDR + 0x40000)"
	DEFINE_TIMA PGTBL_LOG_SIZE			"(1<<18)"
	DEFINE_TIMA DEBUG_LOG_START			"(TIMA_BASE_ADDR + 0x80000)"
	DEFINE_TIMA DEBUG_LOG_SIZE			"(1<<18)"
	DEFINE_TIMA LOG_MEM_ADDR			"(TIMA_BASE_ADDR + 0xC0000)"
	DEFINE_TIMA LOG_MEM_SIZE			"(1<<18)"
	DEFINE_TIMA SEC_TO_PGT_MEM_ADDR			"(TIMA_BASE_ADDR + 0x100000)"
	DEFINE_TIMA SEC_TO_PGT_MEM_SIZE			0x100000
	DEFINE_TIMA PHYS_MAP_ADDR			"(TIMA_BASE_ADDR + 0x200000)"
	DEFINE_TIMA PHYS_MAP_SIZE			0x400000

	if [[ $TIMA_RKP_DISABLED == "true" ]]; then
		DEFINE_TIMA TIMA_RKP_DISABLED			1
	else
		export TIMA_RKP_DISABLED=0
		DEFINE_TIMA TIMA_RKP_DISABLED			0
	fi
	cp -v tima_config.h $TZ_BUILD_DIR/tima_config.h

	# delete mbn files
	rm -rf $BUILD_DIR/bin
	#create new output folder
	mkdir -p $BUILD_DIR/bin/$T_TARGET
}

QPSA_SIGNING()
{
  if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
    cd $COMM_BUILD_DIR
    SIGN_LOG_FILE=$BUILD_DIR/build-log.txt
    echo "5-NHLOS build: Secure boot 3.0 signing" | tee -a ${SIGN_LOG_FILE}

    ##### Bootloader secureboot signing : sbl1, pmic, sbl_takeover, tz, hyp, rpm, sdi, appsboot, emmcbld,
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sbl1 -input $BUILD_DIR/bin/8992/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_sbl1.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sbl1 -input $BUILD_DIR/bin/8992/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8992/unsigned/signed_sbl1.mbn ] ; then
      mkdir -p $BUILD_DIR/bin/8992/qcom_signed
      mv $BUILD_DIR/bin/8992/sbl1.mbn $BUILD_DIR/bin/8992/qcom_signed/
      mv $BUILD_DIR/bin/8992/unsigned/signed_sbl1.mbn $BUILD_DIR/bin/8992/sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_pmic -input $BUILD_DIR/bin/8992/unsigned/pmic.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_pmic.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_pmic -input $BUILD_DIR/bin/8992/unsigned/pmic.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_pmic.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8992/unsigned/signed_pmic.mbn ] ; then
      mkdir -p $BUILD_DIR/bin/8992/qcom_signed
      mv $BUILD_DIR/bin/8992/pmic.mbn $BUILD_DIR/bin/8992/qcom_signed/
      mv $BUILD_DIR/bin/8992/unsigned/signed_pmic.mbn $BUILD_DIR/bin/8992/pmic.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_pmic.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    if [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" != "" ]] ; then
   	echo "java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_secimg20_sbl1 -input $BUILD_DIR/bin/8992/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8992/unsigned/sbl1_root0.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_secimg20_sbl1 -input $BUILD_DIR/bin/8992/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8992/unsigned/sbl1_root0.mbn | tee -a ${SIGN_LOG_FILE}
	if [ -f $BUILD_DIR/bin/8992/unsigned/sbl1_root0.mbn ] ; then
		mkdir -p $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE | tee -a ${SIGN_LOG_FILE}
	      	mv $BUILD_DIR/bin/8992/unsigned/sbl1_root0.mbn $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn | tee -a ${SIGN_LOG_FILE}

	      	openssl dgst -sha256 -binary $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn > sig_32
		java -jar signclient.jar -runtype ss_openssl_sha -model ${MODEL_NAME}_ROOT0 -input sig_32 -output sig_256 | tee -a ${SIGN_LOG_FILE}
		cat $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn sig_256 > $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_sbl1.mbn
		rm sig_32 -f
		rm sig_256 -f
		if [ -f $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_sbl1.mbn ] ; then
			mv $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1_CSB_signed.mbn | tee -a ${SIGN_LOG_FILE}
			mv $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_sbl1.mbn $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/sbl1.mbn | tee -a ${SIGN_LOG_FILE}

			cd $BUILD_DIR/bin/8992/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE
			tar -cvf SBL1_takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE.tar sbl1.mbn | tee -a ${SIGN_LOG_FILE}
			cd $COMM_BUILD_DIR
		else
			echo "securedownload signing error for takeover signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
    	else
      		echo "secureboot signing error for takeover signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_qsee -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_qsee -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tz.mbn ] ; then
      mkdir -p $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed
      mv $TZ_BUILD_DIR/bin/BAWAANAA/tz.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tz.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tz.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_hyp -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/hyp.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_hyp.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_qhee -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/hyp.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_hyp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_hyp.mbn ] ; then
      mkdir -p $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed
      mv $TZ_BUILD_DIR/bin/BAWAANAA/hyp.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_hyp.mbn $TZ_BUILD_DIR/bin/BAWAANAA/hyp.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_hyp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn ] ; then
      mkdir -p $RPM_BUILD_DIR/ms/bin/AAAAANAAR/qcom_signed
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/qcom_signed/
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned/signed_rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn | tee -a ${SIGN_LOG_FILE}
								 
    else
      echo "secureboot signing error for signed_rpm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sdi -input $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/sdi.mbn -output $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/signed_sdi.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sdi -input $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/sdi.mbn -output $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/signed_sdi.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/signed_sdi.mbn ] ; then
      mkdir -p $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/qcom_signed
      mv $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/sdi.mbn $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/qcom_signed/
      mv $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/unsigned/signed_sdi.mbn $SDI_BUILD_DIR/bin/AAAAANAZ/msm8992/sdi.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sdi.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/signed_emmc_appsboot.mbn ] ; then
      mv $BUILD_DIR/emmc_appsboot.mbn $BUILD_DIR/bin/8992/unsigned/aboot.mbn | tee -a ${SIGN_LOG_FILE}
      cp  -v -f $BUILD_DIR/signed_emmc_appsboot.mbn $BUILD_DIR/bin/$T_TARGET/emmc_appsboot.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/signed_emmc_appsboot.mbn $BUILD_DIR/bin/$T_TARGET/aboot.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_emmc_appsboot.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/prog_emmc_firehose_8992_ddr.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_ddr.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/prog_emmc_firehose_8992_ddr.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_ddr.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_ddr.mbn ] ; then
      mv $BUILD_DIR/bin/8992/prog_emmc_firehose_8992_ddr.mbn $BUILD_DIR/bin/8992/qcom_signed/
      mv $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_ddr.mbn $BUILD_DIR/bin/8992/prog_emmc_firehose_8992_ddr.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prog_emmc_firehose_8992_ddr.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/prog_emmc_firehose_8992_lite.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_lite.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/prog_emmc_firehose_8992_lite.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_lite.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_lite.mbn ] ; then
      mv $BUILD_DIR/bin/8992/prog_emmc_firehose_8992_lite.mbn $BUILD_DIR/bin/8992/qcom_signed/
      mv $BUILD_DIR/bin/8992/unsigned/signed_prog_emmc_firehose_8992_lite.mbn $BUILD_DIR/bin/8992/prog_emmc_firehose_8992_lite.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prog_emmc_firehose_8992_lite.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi


#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/validated_emmc_firehose_8992_ddr.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_ddr.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/validated_emmc_firehose_8992_ddr.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_ddr.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_ddr.mbn ] ; then
#      mv $BUILD_DIR/bin/8992/validated_emmc_firehose_8992_ddr.mbn $BUILD_DIR/bin/8992/qcom_signed/
#      mv $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_ddr.mbn $BUILD_DIR/bin/8992/validated_emmc_firehose_8992_ddr.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_prog_emmc_firehose_8992_ddr.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/validated_emmc_firehose_8992_lite.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_lite.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_emmcbld -input $BUILD_DIR/bin/8992/unsigned/validated_emmc_firehose_8992_lite.mbn -output $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_lite.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_lite.mbn ] ; then
#      mv $BUILD_DIR/bin/8992/validated_emmc_firehose_8992_lite.mbn $BUILD_DIR/bin/8992/qcom_signed/
#      mv $BUILD_DIR/bin/8992/unsigned/signed_validated_emmc_firehose_8992_lite.mbn $BUILD_DIR/bin/8992/validated_emmc_firehose_8992_lite.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_prog_emmc_firehose_8992_lite.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi



    ##### Non-HLOS(subsystem) secureboot signing : wcnss, adsp, venus
#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_wcnss -input $WCNSS_BUILD_DIR/bin/8992/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/8992/signed_wcnss.mbn" | tee -a ${SIGN_LOG_FILE}
#    if [ -f $WCNSS_BUILD_DIR/bin/8992/wcnss.mbn ] ; then
#		chmod 0644 $WCNSS_BUILD_DIR/bin/8992/wcnss.mbn
#		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_wcnss -input $WCNSS_BUILD_DIR/bin/8992/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/8992/signed_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
#		if [ -f $WCNSS_BUILD_DIR/bin/8992/signed_wcnss.mbn ] ; then
#		  mv $WCNSS_BUILD_DIR/bin/8992/wcnss.mbn $WCNSS_BUILD_DIR/bin/8992/unsigned_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
#		  mv $WCNSS_BUILD_DIR/bin/8992/signed_wcnss.mbn $WCNSS_BUILD_DIR/bin/8992/wcnss.mbn | tee -a ${SIGN_LOG_FILE}
#		else
#		  echo "secureboot signing error for signed_wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
#		fi
#	fi
#
#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_adsp -input $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn -output $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_adsp -input $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn -output $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn ] ; then
#      mv $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/unsigned_dsp2.mbn | tee -a ${SIGN_LOG_FILE}
#      mv $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/signed_dsp2.mbn $ADSP_BUILD_DIR/ms/bin/AAAAAAAA/dsp2.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_adsp.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_venus -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_venus.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_venus -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_venus.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_venus.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/venus.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_venus.mbn $TZ_BUILD_DIR/bin/BAWAANAA/venus.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_venus.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_vpu -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/vpu.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_vpu.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_vpu -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/vpu.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_vpu.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_vpu.mbn ] ; then
#      mv $TZ_BUILD_DIR/bin/BAWAANAA/vpu.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
#      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_vpu.mbn $TZ_BUILD_DIR/bin/BAWAANAA/vpu.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_vpu.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

    ##### Non-HLOS(tzapps) secureboot signing : cmnlib, cpe, isdbtmm, keymaster, playread, securemm, widevine, tbase, sshdcpapp, skmm_ta, prov, skm, sec_storage
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_cmnlib -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_cmnlib.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_cmnlib -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_cmnlib.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/cmnlib.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_cmnlib.mbn $TZ_BUILD_DIR/bin/BAWAANAA/cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_cmnlib.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/sshdcpapp.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sshdcpapp -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sshdcpapp -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sshdcpapp.mbn ] ; then
          mv $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
          mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
        else
          echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    elif [ -f $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sshdcpapp -input $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sshdcpapp -input $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_sshdcpapp.mbn ] ; then
          mv $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
          mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/BAWAANAA/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
        else
          echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
      echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/sec_storage.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sec_storage -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/sec_storage.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sec_storage -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/sec_storage.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sec_storage.mbn ] ; then
          mv $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
          mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
        else
          echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    elif [ -f $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sec_storage -input $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_sec_storage -input $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_sec_storage.mbn ] ; then
          mv $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
          mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/BAWAANAA/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
        else
          echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
      echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_cpe -input $CPE_BUILD_DIR/bin/AAAAAAAA/cpe.mbn -output $CPE_BUILD_DIR/bin/AAAAAAAA/signed_cpe.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_cpe -input $CPE_BUILD_DIR/bin/AAAAAAAA/cpe.mbn -output $CPE_BUILD_DIR/bin/AAAAAAAA/signed_cpe.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $CPE_BUILD_DIR/bin/AAAAAAAA/signed_cpe.mbn ] ; then
#      mv $CPE_BUILD_DIR/bin/AAAAAAAA/cpe.mbn $CPE_BUILD_DIR/bin/AAAAAAAA/qcom_signed/
#      mv $CPE_BUILD_DIR/bin/AAAAAAAA/unsigned/signed_cpe.mbn $CPE_BUILD_DIR/bin/AAAAAAAA/cpe.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_cpe.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_isdbtmm -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_isdbtmm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_isdbtmm -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_isdbtmm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/isdbtmm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_isdbtmm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_isdbtmm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_keymaster -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/keymaster.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_keymaster.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_keymaster -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/keymaster.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_keymaster.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/keymaster.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_keymaster.mbn $TZ_BUILD_DIR/bin/BAWAANAA/keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_prov -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/prov.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_prov.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_prov -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/prov.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_prov.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_prov.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/prov.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_prov.mbn $TZ_BUILD_DIR/bin/BAWAANAA/prov.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prov.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_skm -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/skm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_skm -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/skm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/skm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/skm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/tbase.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_tbase -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/tbase.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tbase.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_tbase -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/tbase.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tbase.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tbase.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/tbase.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_tbase.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tbase.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tbase.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/BAWAANAA/tbase.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_playready -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_playready.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_playready -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_playready.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_playready.mbn ] ; then
#      mv $TZ_BUILD_DIR/bin/BAWAANAA/playready.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
#      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_playready.mbn $TZ_BUILD_DIR/bin/BAWAANAA/playready.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_playready.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

#    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_securemm -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/securemm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_securemm.mbn" | tee -a ${SIGN_LOG_FILE}
#    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_securemm -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/securemm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_securemm.mbn | tee -a ${SIGN_LOG_FILE}
#    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_securemm.mbn ] ; then
#      mv $TZ_BUILD_DIR/bin/BAWAANAA/securemm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_securemm.mbn | tee -a ${SIGN_LOG_FILE}
#      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_securemm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/securemm.mbn | tee -a ${SIGN_LOG_FILE}
#    else
#      echo "secureboot signing error for signed_securemm.mbn!" | tee -a ${SIGN_LOG_FILE}
#    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_widevine -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_widevine.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_widevine -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_widevine.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_widevine.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/BAWAANAA/widevine.mbn $TZ_BUILD_DIR/bin/BAWAANAA/qcom_signed/
      mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_widevine.mbn $TZ_BUILD_DIR/bin/BAWAANAA/widevine.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_widevine.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

#   for TIMA apps signing S
    ## IF TIMA_ENABLED, signing tima_pkm, tima_lkm
    if [[ "$TIMA_ENABLED" == "1" ]] ; then
	  ##++++++++++++++++++++ temporarily rename tima_*.mbn to lkmauth, tima for signing
	  cp -v -f $TZ_BUILD_DIR/bin/BAWAANAA/tima_lkm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/lkmauth.mbn
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_lkmauth -input $TZ_BUILD_DIR/bin/BAWAANAA/lkmauth.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_lkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/BAWAANAA/lkmauth.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_lkmauth.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_lkm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_lkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_tima_pkm -input $TZ_BUILD_DIR/bin/BAWAANAA/tima_pkm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_pkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/BAWAANAA/tima_pkm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_pkm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_pkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_tima_atn -input $TZ_BUILD_DIR/bin/BAWAANAA/tima_atn.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_atn.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/BAWAANAA/tima_atn.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_atn.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_atn.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_tima_key -input $TZ_BUILD_DIR/bin/BAWAANAA/tima_key.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_key.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/BAWAANAA/tima_key.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_tima_key.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_key.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi
          if [[ "$TIMA_VERSION" == "3" ]] ; then
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_tz_ccm -input $TZ_BUILD_DIR/bin/BAWAANAA/tz_ccm.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_tz_ccm.mbn ] ; then
			mv $TZ_BUILD_DIR/bin/BAWAANAA/tz_ccm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
			mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_tz_ccm.mbn $TZ_BUILD_DIR/bin/BAWAANAA/tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
		else
			echo "secureboot signing error for signed_tz_ccm.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	fi
	fi
#   for TIMA apps signing E

    if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/skmm_ta.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_skmmta -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skmm_ta.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_skmmta -input $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skmm_ta.mbn ] ; then
          mv $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
          mv $TZ_BUILD_DIR/bin/BAWAANAA/unsigned/signed_skmm_ta.mbn $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
        else
          echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    elif [ -f $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_skmmta -input $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_skmm_ta.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg20_skmmta -input $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/BAWAANAA/signed_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/BAWAANAA/signed_skmm_ta.mbn ] ; then
          mv $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn $TZ_BUILD_DIR/bin/BAWAANAA/unsigned_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
          mv $TZ_BUILD_DIR/bin/BAWAANAA/signed_skmm_ta.mbn $TZ_BUILD_DIR/bin/BAWAANAA/skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
        else
          echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
      echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

  else
  	echo 'Making a qcom signed aboot.mbn'
        echo '$OUT'
	echo '$BOOT_IMAGES_DIR'
	python $BOOT_IMAGES_DIR/tools/build/scons/sectools/sectools.py secimage -i $OUT/emmc_appsboot.mbn -o bin/8992/signed -g appsbl -c $BOOT_IMAGES_DIR/tools/build/scons/sectools/config/integration/secimage.xml -s
	cp -v -f bin/8992/signed/default/appsbl/emmc_appsboot.mbn emmc_appsboot.mbn
	cp -v -f bin/8992/signed/default/appsbl/emmc_appsboot.mbn $OUT/emmc_appsboot.mbn
	cp -v -f bin/8992/signed/default/appsbl/emmc_appsboot.mbn $OUT/aboot.mbn
  fi
}

MAKE_EMERGENCY_TOOL()
{
	echo "make emergency download packages"
	cd $NHLOS_ROOT_DIR/common/tools/emergency_download
	mkdir -p QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/sbl1.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/rpm.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/tz.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/sdi.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/hyp.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/pmic.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/emmc_appsboot.mbn QFIL_IMAGES/
	cp -v $BUILD_DIR/bin/$T_TARGET/prog_emmc_firehose_8992_*.mbn QFIL_IMAGES/
	rm -rf PARTITION/
	rm -r flash.xml
	rm -r emergency_download.xml

	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
		cp -v $BUILD_DIR/bin/$T_TARGET/aboot.mbn QFIL_IMAGES/
		cp -v $BUILD_DIR/bin/$T_TARGET/prog_emmc_firehose_8992.mbn QFIL_IMAGES/
	else
		cp -v $BUILD_DIR/emmc_appsboot.mbn QFIL_IMAGES/aboot.mbn
		if [ -f $BUILD_DIR/bin/8992/unsigned/prog_emmc_firehose_8992.mbn ] ; then
			cp -v $BUILD_DIR/bin/8992/unsigned/prog_emmc_firehose_8992.mbn QFIL_IMAGES/
		else
			cp -v $BUILD_DIR/bin/8992/prog_emmc_firehose_8992.mbn QFIL_IMAGES/
		fi
	fi
	cp -v PARTITION/* QFIL_IMAGES/
}


MAKE_SECDAT_FILE()
{
    cd $NHLOS_ROOT_DIR/common/tools/sectools
	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then		
		if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
			echo "Make sec.dat File "
						
			if [[ "$SECURE_FUSE_DEBUG_ENABLE" == "true" ]] ; then
				cp -v -f config/8992/8992_fuseblower_$T_MODEL'_'$T_CARRIER'_DEBUG_USER'.xml config/8992/USER.xml
			else
				cp -v -f config/8992/8992_fuseblower_$T_MODEL'_'$T_CARRIER'_USER.xml' config/8992/USER.xml
			fi
			
			if [[ "$ANTI_ROLLBACK_ENABLE" == "true" ]] ; then
				echo " Preparing Rollback Prevention Enabled binary"
				#lets use default QC, OEM XML files provided by Qcom.
				cp -v -f config/8992/8992_fuseblower_QC.xml config/8992/QC.xml
				cp -v -f config/8992/8992_fuseblower_OEM.xml config/8992/OEM.xml
			elif [[ "$ANTI_ROLLBACK_IGNORE" == "true" ]] ; then
				echo " Preparing Testbit binary "
				cp -v -f config/8992/8992_fuseblower_QC_Testbit.xml config/8992/QC.xml
				cp -v -f config/8992/8992_fuseblower_OEM.xml config/8992/OEM.xml
			elif [[ "$SECURE_FUSE_DEBUG_ENABLE" == "true" ]] ; then
				echo " Preparing Secure boot binary with JTAG Enabled "
				cp -v -f config/8992/8992_fuseblower_QC_DEBUG.xml config/8992/QC.xml
				cp -v -f config/8992/8992_fuseblower_OEM_WithoutRP.xml config/8992/OEM.xml
			else
				echo " Preparing SecureBoot Binary with RP Disabled "
				cp -v -f config/8992/8992_fuseblower_QC_WithoutRP.xml config/8992/QC.xml
				cp -v -f config/8992/8992_fuseblower_OEM_WithoutRP.xml config/8992/OEM.xml
			fi
			
			python sectools.py fuseblower -e config/8992/OEM.xml -q config/8992/QC.xml -u config/8992/USER.xml -g -a -d
			cp -v -f ./fuseblower_output/* $BUILD_DIR/bin/$T_TARGET/
			cp -v -f ./fuseblower_output/v2/* $BUILD_DIR/bin/$T_TARGET/
		else
			echo "Copying Dummy sec.dat file"
#			cp -v -f ./resources/build/* $BUILD_DIR/bin/$T_TARGET/
			cp -v -f ./resources/build/fileversion2/sec.dat $BUILD_DIR/bin/$T_TARGET/sec.dat
		fi        
	else
        echo "Copying Dummy sec.dat file"
#        cp -v -f ./resources/build/* $BUILD_DIR/bin/$T_TARGET/
	cp -v -f ./resources/build/fileversion2/sec.dat $BUILD_DIR/bin/$T_TARGET/sec.dat
	fi    
}

MAKE_MODEL_DEFINE

cp -v board.h $TZ_BUILD_DIR/board.h
MAKE_SECDAT_FILE

echo "1-NHLOS build: build rpm on $PROJECT_NAME"
cd $RPM_BUILD_DIR
./buildss.sh || exit 1

echo "2-NHLOS build: build trustzone"
cd $TZ_BUILD_DIR
./buildss.sh $SECURE_NAME || exit 1

echo "3-NHLOS build: build sbl image"
cd $BUILD_DIR
./buildss.sh || exit 1

echo "4-NHLOS build: build sdi(system debug image)"
cd $SDI_BUILD_DIR
./buildss.sh $DDR_SIZE || exit 1

#echo "5-NHLOS build: build adsp image"
#cd $ADSP_BUILD_DIR
#./buildss.sh || exit 1

#echo "6-NHLOS build: build mpss image"
#cd $MPSS_BUILD_DIR
#./buildss.sh || exit 1

QPSA_SIGNING

cp -v -f -r $RPM_BUILD_DIR/ms/bin/AAAAANAAR/* $BUILD_DIR/bin/$T_TARGET/
cp -v -f -r $TZ_BUILD_DIR/bin/BAWAANAA/* $BUILD_DIR/bin/$T_TARGET/
cp -v -f -r $BUILD_DIR/bin/8992/* $BUILD_DIR/bin/$T_TARGET/
cp -v -f -r $SDI_BUILD_DIR/bin/AAAAANAZ/$T_TARGET/* $BUILD_DIR/bin/$T_TARGET/

MAKE_EMERGENCY_TOOL

echo "## End of build_linux_samsung.sh ##"
