
#===============================================================================
# Build boot & jsdcc tool
#===============================================================================
echo "## Start of build_linux_samsung.sh ##"

echo "Allow writing to nhlos for building bootloader"
chmod u+w -R ../../../../nhlos

cd ../..
BOOT_IMAGES_DIR=`pwd`
BUILD_DIR=$BOOT_IMAGES_DIR/build/ms

cd $BOOT_IMAGES_DIR/..
NHLOS_ROOT_DIR=`pwd`

cd $NHLOS_ROOT_DIR/trustzone_images/build/ms
TZ_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/rpm_proc/build
RPM_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/common/build
COMM_BUILD_DIR=`pwd`

cd $NHLOS_ROOT_DIR/wcnss_proc/build/ms
WCNSS_BUILD_DIR=`pwd`

# delete mbn files
rm -rf $BUILD_DIR/bin

# create new BUILD_ID folder
mkdir -p $BUILD_DIR/bin/AAAAANAZ

#for model define
cd $BUILD_DIR

export $*

VARIANT_TARGET=''
TZ_BUILD_ID=''
SECURE_NAME=''
# For Rollback Prevention.
ANTI_ROLLBACK_ENABLE=false
# For Testbit Binary
ANTI_ROLLBACK_IGNORE=false

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


	case $T_TARGET in
		msm8916)
		VARIANT_TARGET=8916
		SEC_DAT_TARGET=8916
		TZ_BUILD_ID=MAUAANAA
			;;
		msm8939)
		VARIANT_TARGET=8936
		SEC_DAT_TARGET=8939
		TZ_BUILD_ID=MAWAANAA
			;;
		*)
			echo "use default define value"
			;;
	esac

	echo "VARIANT_TARGET="$VARIANT_TARGET""

	# GTC Secure boot defined only if Secure boot is enabled
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

	## COMMON Defines
	DEFINE SEC_FOTA_FEATURE 1
	DEFINE SEC_DEBUG_FEATURE 1
	DEFINE SEC_READ_PARAM_FEATURE 1
	DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
	SEC_BAM_TZ_DISABLE_SPI=1

	## Model Defines
	# SECURE_NAME/SMPL Setting
	echo 'BUILD : '$T_MODEL'_'$T_CARRIER
	SECURE_NAME=SECUREBOOT_NOT_DEFINED
	case $T_MODEL'_'$T_CARRIER in
	#HERE,,,, start of MSM8916 PROJECT LIST.............
		KLEOSLTE_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		ROSSALTE_USA_SPR)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		ROSSALTE_USA_AIO)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		A3ULTE_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			MODEL_NAME=SM-A300FU_EUR_XX
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE FUSE_HW_ID 0x7050E1
			DEFINE DDR_6Gb_tMRS_ENABLE
			;;
		A5ULTE_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
	#HERE,,,, end of MSM8916 PROJECT LIST.............
	#HERE,,,, start of MSM8936 PROJECT LIST.............
		A7LTE_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			MODEL_NAME=SM-A700FD_CIS_SER
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE FUSE_HW_ID 0x90B0E1
			;;
		A7LTE_CHN_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			MODEL_NAME=SM-A7000_CHN_CHC
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE FUSE_HW_ID 0x90B0E1
			;;
		A7LTE_CHN_CTC)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		A73G_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			MODEL_NAME=SM-A700H_CIS_SER
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE FUSE_HW_ID 0x9570E1
			;;
	#HERE,,,, endif of MSM8936 PROJECT LIST.............
		# Default
		*)
			echo "use default define value"
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 1
			DEFINE SEC_SMPL_FEATURE 1
			;;
	esac

	## COMMON Defines to support variables
	DEFINE SEC_BAM_TZ_DISABLE_SPI $SEC_BAM_TZ_DISABLE_SPI

	## Model Defines
	echo 'BUILD : '$T_MODEL
	case $T_MODEL in
	#HERE,,,, start of MSM8916 PROJECT LIST.............
		KLEOSLTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 117
			DEFINE HW_REV_2 118
			DEFINE HW_REV_3 119
			;;
		ROSSALTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 117
			DEFINE HW_REV_2 118
			DEFINE HW_REV_3 119
			;;
		A3ULTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 77
			DEFINE HW_REV_2 72
			DEFINE HW_REV_3 97
			;;
		A5ULTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 77
			DEFINE HW_REV_2 72
			DEFINE HW_REV_3 108
			;;
	#HERE,,,, end of MSM8916 PROJECT LIST.............
	#HERE,,,, start of MSM8936 PROJECT LIST.............
		A7LTE)
			DEFINE HW_REV_0 78
			DEFINE HW_REV_1 79
			DEFINE HW_REV_2 101
			DEFINE HW_REV_3 102
			;;
		A73G)
			DEFINE HW_REV_0 78
			DEFINE HW_REV_1 79
			DEFINE HW_REV_2 101
			DEFINE HW_REV_3 102
			;;
	#HERE,,,, endif of MSM8936 PROJECT LIST.............
		# Default
		*)
			echo "use default define value"
			;;
	esac

	if [[ $TIMA_RKP_DISABLED == "true" ]]; then
		DEFINE_TIMA TIMA_RKP_DISABLED			1
		DEFINE_TIMA TIMA_BASE_ADDR			0x85D00000
		DEFINE_TIMA TIMA_VPCR_ADDR			TIMA_BASE_ADDR
		DEFINE_TIMA TIMA_VPCR_SIZE 			0x1000
		DEFINE_TIMA TIMA_BOOT_MEASUREMENT_ADDR		"(TIMA_VPCR_ADDR + 0x20)"
		DEFINE_TIMA TIMA_GOLDEN_MEASUREMENT_ADDR	"(TIMA_VPCR_ADDR + 0x800)"
		DEFINE_TIMA DASHBOARD_START			"(TIMA_BASE_ADDR + 0x2000)"
		DEFINE_TIMA DASHBOARD_SIZE			0x1000
		DEFINE_TIMA SEC_LOG_START			"(TIMA_BASE_ADDR + 0x3000)"
		DEFINE_TIMA SEC_LOG_SIZE			0x3D000
		DEFINE_TIMA PGTBL_LOG_START			"(TIMA_BASE_ADDR + 0x40000)"
		DEFINE_TIMA PGTBL_LOG_SIZE			"(1<<18)"
		DEFINE_TIMA DEBUG_LOG_START			"(TIMA_BASE_ADDR + 0x80000)"			
		DEFINE_TIMA DEBUG_LOG_SIZE			"(1<<18)"
	else
		export TIMA_RKP_DISABLED=0
		DEFINE_TIMA TIMA_RKP_DISABLED			0
		DEFINE_TIMA TIMA_BASE_ADDR			0x85D00000
		DEFINE_TIMA TIMA_VPCR_ADDR			TIMA_BASE_ADDR
		DEFINE_TIMA TIMA_VPCR_SIZE 			0x1000
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
		DEFINE_TIMA SEC_TO_PGT_MEM_SIZE 		0x100000
		DEFINE_TIMA PHYS_MAP_ADDR			"(TIMA_BASE_ADDR + 0x200000)"
		DEFINE_TIMA PHYS_MAP_SIZE			0x400000
	fi
	cp -v tima_config.h $TZ_BUILD_DIR/tima_config.h
}


QPSA_SIGNING()
{
  if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
  if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
    cd $COMM_BUILD_DIR
    SIGN_LOG_FILE=$BUILD_DIR/build-log.txt
    echo "5-NHLOS build: Secure boot 3.0 signing" | tee -a ${SIGN_LOG_FILE}

    ##### Bootloader secureboot signing : sbl1, tz, rpm, sdi, appsboot, emmcbld
    if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/sbl1.mbn ] ; then 
		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sbl1 -input $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/sbl1.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_sbl1.mbn" | tee -a ${SIGN_LOG_FILE}
	mkdir -p $BUILD_DIR/bin/$VARIANT_TARGET/qcom_default_signed
	mv $BUILD_DIR/bin/$VARIANT_TARGET/sbl1.mbn $BUILD_DIR/bin/$VARIANT_TARGET/qcom_default_signed/sbl1.mbn
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sbl1 -input $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/sbl1.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_sbl1.mbn ] ; then
			mv $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_sbl1.mbn $BUILD_DIR/bin/$VARIANT_TARGET/sbl1.mbn | tee -a ${SIGN_LOG_FILE}
		else
			echo "secureboot signing error for signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sbl1 -input $BUILD_DIR/bin/$VARIANT_TARGET/sbl1.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_sbl1.mbn" | tee -a ${SIGN_LOG_FILE}
		mkdir -p $BUILD_DIR/bin/$VARIANT_TARGET/unsigned
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sbl1 -input $BUILD_DIR/bin/$VARIANT_TARGET/sbl1.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/signed_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
	mv $BUILD_DIR/bin/$VARIANT_TARGET/sbl1.mbn $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/sbl1.mbn
		if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/signed_sbl1.mbn ] ; then
      		mv $BUILD_DIR/bin/$VARIANT_TARGET/signed_sbl1.mbn $BUILD_DIR/bin/$VARIANT_TARGET/sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz.mbn ] ; then 
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
    	mkdir -p $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/qcom_default_signed
    	mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/qcom_default_signed
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz.mbn ] ; then      
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz.mbn ] ; then      
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi

    if [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" != "" ]] ; then
        mkdir -p $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE | tee -a ${SIGN_LOG_FILE}
  	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz.mbn ] ; then 
        	cp -v $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
	else
		cp -v $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
	fi
        echo "java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/unsigned_tz.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
            openssl dgst -sha256 -binary $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn > sig_32
            java -jar signclient.jar -runtype ss_openssl_sha -model ${MODEL_NAME}_ROOT0 -input sig_32 -output sig_256 | tee -a ${SIGN_LOG_FILE}
            cat $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn sig_256 > $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn
            rm sig_32 -f
            rm sig_256 -f
            if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn ] ; then
                mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz_CSB_signed.mbn | tee -a ${SIGN_LOG_FILE}
                mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
                cd $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE
                tar -cvf qsee_takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE.tar tz.mbn | tee -a ${SIGN_LOG_FILE}
                cd $COMM_BUILD_DIR
            else
                echo "securedownload signing error for takeover signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
            fi
            else
                echo "secureboot signing error for takeover signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    fi
	
    if [ -f $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/rpm.mbn ] ; then      
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_rpm  -input $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/signed_rpm.mbn" | tee -a ${SIGN_LOG_FILE}
    	mkdir -p $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/qcom_default_signed	
    	mv $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/rpm.mbn $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/qcom_default_signed/rpm.mbn 
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_rpm -input $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/signed_rpm.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/signed_rpm.mbn ] ; then      
      		mv $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/unsigned/signed_rpm.mbn $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/rpm.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_rpm.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_rpm  -input $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/signed_rpm.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_rpm -input $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/signed_rpm.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/signed_rpm.mbn ] ; then      
      		mv $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/signed_rpm.mbn $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/rpm.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_rpm.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/hyp.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_qhee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/hyp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/hyp.mbn" | tee -a ${SIGN_LOG_FILE}
    	mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/hyp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/qcom_default_signed
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_qhee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/hyp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_hyp.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_hyp.mbn ] ; then     
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_hyp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/hyp.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_sdi.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_qhee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/hyp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_hyp.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_qhee -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/hyp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_hyp.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_hyp.mbn ] ; then     
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_hyp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/hyp.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_sdi.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi
    
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/signed_emmc_appsboot.mbn ] ; then
      mv $BUILD_DIR/emmc_appsboot.mbn $BUILD_DIR/bin/AAAAANAZ/unsigned_aboot.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/signed_emmc_appsboot.mbn $BUILD_DIR/bin/AAAAANAZ/aboot.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_emmc_appsboot.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/MPRG$VARIANT_TARGET.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_emmcbld -input $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/MPRG$VARIANT_TARGET.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_MPRG$VARIANT_TARGET.mbn" | tee -a ${SIGN_LOG_FILE}
	#mv $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/MPRG$VARIANT_TARGET.mbn $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn | tee -a ${SIGN_LOG_FILE}
	mkdir -p $BUILD_DIR/bin/$VARIANT_TARGET/qcom_default_signed	
    	mv $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn $BUILD_DIR/bin/$VARIANT_TARGET/qcom_default_signed/MPRG$VARIANT_TARGET.mbn	
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_emmcbld -input $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/MPRG$VARIANT_TARGET.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_MPRG$VARIANT_TARGET.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_MPRG$VARIANT_TARGET.mbn ] ; then
      		mv $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/signed_MPRG$VARIANT_TARGET.mbn $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_MPRG$VARIANT_TARGET.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_emmcbld -input $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/signed_MPRG$VARIANT_TARGET.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_emmcbld -input $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn -output $BUILD_DIR/bin/$VARIANT_TARGET/signed_MPRG$VARIANT_TARGET.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/signed_MPRG$VARIANT_TARGET.mbn ] ; then
      		mv $BUILD_DIR/bin/$VARIANT_TARGET/signed_MPRG$VARIANT_TARGET.mbn $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_MPRG$VARIANT_TARGET.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    fi

    ##### Non-HLOS secureboot signing : wcnss, cmnlib, isdbtmm, playready, sshdcpapp, mldap, sec_storage, devauth, widevine, mc_v2, tima_pkm, tima_lkm, tima_key, tima_atn, tz_ccm, prov, skm, keymaster, dtcpip, dxprdy, tzpr25, skmm_ta, securefp, act_lock, fp_asm

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_wcnss -input $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/signed_wcnss.mbn" | tee -a ${SIGN_LOG_FILE}
    if [ -f $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn ] ; then
		chmod 0644 $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_wcnss -input $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/signed_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/signed_wcnss.mbn ] ; then
		  mv $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/unsigned_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		  mv $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/signed_wcnss.mbn $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		else
		  echo "secureboot signing error for signed_wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "secureboot signing skip $WCNSS_BUILD_DIR/bin/$VARIANT_TARGET/reloc/wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/cmnlib.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_cmnlib  -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_cmnlib.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_cmnlib -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_cmnlib.mbn ] ; then      
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_cmnlib.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_cmnlib.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/cmnlib.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_cmnlib  -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/cmnlib.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_cmnlib.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_cmnlib -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/cmnlib.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_cmnlib.mbn ] ; then      
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_cmnlib.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_cmnlib.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/isdbtmm.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_isdbtmm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_isdbtmm.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_isdbtmm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_isdbtmm.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_isdbtmm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_isdbtmm.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/isdbtmm.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_isdbtmm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_isdbtmm.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_isdbtmm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_isdbtmm.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_isdbtmm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_isdbtmm.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/playready.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_playready -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_playready.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_playready -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_playready.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_playready.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_playready.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/playready.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_playready.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/playready.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_playready -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/playready.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_playready.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_playready -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/playready.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_playready.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_playready.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_playready.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/playready.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_playready.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tzpr25.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tzpr25.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tzpr25.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tzpr25.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tzpr25.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tzpr25.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_tzpr25.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tzpr25.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tzpr25.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tzpr25.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tzpr25.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tzpr25.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tzpr25.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_tzpr25.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi	

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/securefp.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/securefp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_securefp.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/securefp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_securefp.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_securefp.mbn ] ; then      
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_securefp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/securefp.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_securefp.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/securefp.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/securefp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_securefp.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/securefp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_securefp.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_securefp.mbn ] ; then      
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_securefp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/securefp.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_securefp.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/fp_asm.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/fp_asm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_fp_asm.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/fp_asm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_fp_asm.mbn ] ; then     
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_fp_asm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_fp_asm.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/fp_asm.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/fp_asm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_fp_asm.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/fp_asm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_fp_asm.mbn ] ; then     
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_fp_asm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_fp_asm.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/venus.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_venus  -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_venus.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_venus -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_venus.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_venus.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_venus.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/venus.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_venus.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi   
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/venus.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_venus  -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/venus.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_venus.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_venus -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/venus.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_venus.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_venus.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_venus.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/venus.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_venus.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi   
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dtcpip.mbn ] ; then
    	if [[ "$DTCPIP_ENABLED" == 1 ]] ; then
      		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dtcpip.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dtcpip.mbn" | tee -a ${SIGN_LOG_FILE}
      		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dtcpip.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dtcpip.mbn ] ; then
       	 		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dtcpip.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      		else
        		echo "secureboot signing error for signed_dtcpip.mbn!" | tee -a ${SIGN_LOG_FILE}
      		fi
    	fi
    else
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dtcpip.mbn ] ; then
    	if [[ "$DTCPIP_ENABLED" == 1 ]] ; then
      		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dtcpip.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dtcpip.mbn" | tee -a ${SIGN_LOG_FILE}
      		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dtcpip.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dtcpip.mbn ] ; then
       	 		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dtcpip.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      		else
        		echo "secureboot signing error for signed_dtcpip.mbn!" | tee -a ${SIGN_LOG_FILE}
      		fi
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dxprdy.mbn ] ; then
    	if [[ "$DXPRDY_ENABLED" == 1 ]] ; then
      		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dxprdy -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dxprdy.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dxprdy.mbn" | tee -a ${SIGN_LOG_FILE}
      		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dxprdy -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dxprdy.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dxprdy.mbn | tee -a ${SIGN_LOG_FILE}
      		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dxprdy.mbn ] ; then
        		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dxprdy.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dxprdy.mbn | tee -a ${SIGN_LOG_FILE}
      		else
        		echo "secureboot signing error for signed_dxprdy.mbn!" | tee -a ${SIGN_LOG_FILE}
      		fi
   	fi
    else
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dxprdy.mbn ] ; then
    	if [[ "$DXPRDY_ENABLED" == 1 ]] ; then
      		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dxprdy -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dxprdy.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dxprdy.mbn" | tee -a ${SIGN_LOG_FILE}
      		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dxprdy -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dxprdy.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dxprdy.mbn | tee -a ${SIGN_LOG_FILE}
      		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dxprdy.mbn ] ; then
        		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dxprdy.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dxprdy.mbn | tee -a ${SIGN_LOG_FILE}
      		else
        		echo "secureboot signing error for signed_dxprdy.mbn!" | tee -a ${SIGN_LOG_FILE}
      		fi
   	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/sshdcpapp.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sshdcpapp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sshdcpapp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sshdcpapp.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    	else
	 	echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sshdcpapp.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sshdcpapp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sshdcpapp -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sshdcpapp.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    	else
	 	echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/mldap.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_mldap -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/mldap.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mldap.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_mldap -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/mldap.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mldap.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mldap.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mldap.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mldap.mbn | tee -a ${SIGN_LOG_FILE}
    	else
		echo "secureboot signing error for signed_mldap.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mldap.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_mldap -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mldap.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mldap.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_mldap -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mldap.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mldap.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mldap.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mldap.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mldap.mbn | tee -a ${SIGN_LOG_FILE}
    	else
		echo "secureboot signing error for signed_mldap.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/sec_storage.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sec_storage -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/sec_storage.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sec_storage -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/sec_storage.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sec_storage.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sec_storage.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sec_storage -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sec_storage.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sec_storage -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sec_storage.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sec_storage.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/devauth.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/devauth.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_devauth.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/devauth.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_devauth.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_devauth.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_devauth.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/devauth.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/devauth.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/devauth.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_devauth.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/devauth.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_devauth.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_devauth.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_devauth.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/devauth.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/widevine.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_widevine  -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_widevine.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_widevine -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_widevine.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_widevine.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_widevine.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/widevine.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_widevine.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/widevine.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_widevine  -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/widevine.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_widevine.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_widevine -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/widevine.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_widevine.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_widevine.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_widevine.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/widevine.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_widevine.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dmverity.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dmverity -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dmverity.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dmverity.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dmverity -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/dmverity.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dmverity.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dmverity.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_dmverity.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dmverity.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_dmverity.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
    else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dmverity.mbn ] ; then
    	echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dmverity -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dmverity.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dmverity.mbn" | tee -a ${SIGN_LOG_FILE}
    	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dmverity -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dmverity.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dmverity.mbn | tee -a ${SIGN_LOG_FILE}
    	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dmverity.mbn ] ; then
      		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_dmverity.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/dmverity.mbn | tee -a ${SIGN_LOG_FILE}
    	else
      		echo "secureboot signing error for signed_dmverity.mbn!" | tee -a ${SIGN_LOG_FILE}
    	fi
	fi
    fi

    ## IF TIMA_ENABLED, signing tima_pkm, tima_lkm, tima_key, tima_atn, tz_ccm
    if [[ "$TIMA_ENABLED" == "1" ]] ; then
	  ##++++++++++++++++++++ temporarily rename tima_*.mbn to lkmauth, tima for signing
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_lkm.mbn ] ; then
	  	cp -v -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_lkm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/lkmauth.mbn
	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_lkmauth -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/lkmauth.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_lkm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_lkm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tima_lkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
	else
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_lkm.mbn ] ; then
	  	cp -v -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_lkm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/lkmauth.mbn
	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_lkmauth -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/lkmauth.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_lkm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_lkm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tima_lkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
		fi
	fi
	
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_pkm.mbn ] ; then
	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_pkm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_pkm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_pkm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_pkm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tima_pkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
	else
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_pkm.mbn ] ; then
	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_pkm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_pkm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_pkm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_pkm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tima_pkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
		fi
	fi

          if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_atn.mbn ] ; then
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_atn -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_atn.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_atn.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_atn.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_atn.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi
	  else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_atn.mbn ] ; then
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_atn -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_atn.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_atn.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_atn.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_atn.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi
	fi
	  fi

	  if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_key.mbn ] ; then
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_key -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tima_key.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_key.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tima_key.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_key.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi
	  else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_key.mbn ] ; then
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_key -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_key.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_key.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tima_key.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_key.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi
	fi
	  fi

          if [[ "$TIMA_VERSION" == "3" ]] ; then
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz_ccm.mbn ] ; then
 	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tz_ccm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/tz_ccm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz_ccm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_tz_ccm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tz_ccm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
		else
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz_ccm.mbn ] ; then
 	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tz_ccm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz_ccm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz_ccm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_tz_ccm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tz_ccm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
		fi
		fi
          fi
	  ##++++++++++++++++++++
    ################
    fi

	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/mc_v2.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/mc_v2.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mc_v2.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/mc_v2.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mc_v2.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_mc_v2.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mc_v2.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mc_v2.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mc_v2.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mc_v2.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mc_v2.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_mc_v2.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	fi
	fi

	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/prov.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_prov -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/prov.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_prov.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_prov -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/prov.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_prov.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_prov.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_prov.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/prov.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prov.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/prov.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_prov -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/prov.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_prov.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_prov -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/prov.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_prov.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_prov.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_prov.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/prov.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prov.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	fi
	fi

	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/skm.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_skm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/skm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_skm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/skm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skm.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_skm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_skm -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skm.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skm.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	fi
	fi

	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/skmm_ta.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skmm_ta.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skmm_ta.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_skmm_ta.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skmm_ta.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skmm_ta.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skmm_ta.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_skmm_ta.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	fi
	fi


	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/keymaster.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_keymaster -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/keymaster.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_keymaster.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_keymaster -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/keymaster.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_keymaster.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_keymaster.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
	if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/keymaster.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_keymaster -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/keymaster.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_keymaster.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_keymaster -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/keymaster.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_keymaster.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_keymaster.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	fi
	fi
    
    if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/act_lock.mbn ] ; then
		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_act_lock -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/act_lock.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_act_lock.mbn" | tee -a ${SIGN_LOG_FILE}
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_act_lock -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/act_lock.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_act_lock.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_act_lock.mbn ] ; then
		  mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/unsigned/signed_act_lock.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/act_lock.mbn | tee -a ${SIGN_LOG_FILE}
		else
		  echo "secureboot signing error for signed_act_lock.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/act_lock.mbn ] ; then
		echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_act_lock -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/act_lock.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_act_lock.mbn" | tee -a ${SIGN_LOG_FILE}
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_act_lock -input $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/act_lock.mbn -output $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_act_lock.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_act_lock.mbn ] ; then
		  mv $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/signed_act_lock.mbn $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/act_lock.mbn | tee -a ${SIGN_LOG_FILE}
		else
		  echo "secureboot signing error for signed_act_lock.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
		fi
	fi
	fi
  fi
}

MAKE_EMERGENCY_TOOL()
{
	echo "make emergency download packages"
	cd $NHLOS_ROOT_DIR/common/tools/emergency_download
	mkdir -p IMAGES/
	cp -v $BUILD_DIR/bin/AAAAANAZ/sbl1.mbn IMAGES/
	cp -v $BUILD_DIR/bin/AAAAANAZ/rpm.mbn IMAGES/
	cp -v $BUILD_DIR/bin/AAAAANAZ/tz.mbn IMAGES/
	cp -v $BUILD_DIR/bin/AAAAANAZ/hyp.mbn IMAGES/

	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
		cp -v $BUILD_DIR/bin/AAAAANAZ/aboot.mbn IMAGES/
		cp -v $BUILD_DIR/bin/AAAAANAZ/MPRG$VARIANT_TARGET.mbn IMAGES/
	else
		cp -v $BUILD_DIR/emmc_appsboot.mbn IMAGES/aboot.mbn
    		if [ -f $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/MPRG$VARIANT_TARGET.mbn ] ; then
			cp -v $BUILD_DIR/bin/$VARIANT_TARGET/unsigned/MPRG$VARIANT_TARGET.mbn IMAGES/
		else
			cp -v $BUILD_DIR/bin/$VARIANT_TARGET/MPRG$VARIANT_TARGET.mbn IMAGES/
		fi
	fi
}

MAKE_SECDAT_FILE()
{
    cd $NHLOS_ROOT_DIR/common/tools/sectools
	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then		
		if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
			echo "Make sec.dat File "		
						
			case $T_MODEL'_'$T_CARRIER in
				A7LTE_EUR_OPEN)
					cp -v -f config/$SEC_DAT_TARGET/A7LTE_EUR_OPEN.xml config/$SEC_DAT_TARGET/USER.xml
					;;
				A3ULTE_EUR_OPEN)
					cp -v -f config/$SEC_DAT_TARGET/A3ULTE_EUR_OPEN.xml config/$SEC_DAT_TARGET/USER.xml
					;;
				A7LTE_CHN_OPEN)
					cp -v -f config/$SEC_DAT_TARGET/A7LTE_CHN_OPEN.xml config/$SEC_DAT_TARGET/USER.xml
					;;
				A73G_EUR_OPEN)
					cp -v -f config/$SEC_DAT_TARGET/A73G_EUR_OPEN.xml config/$SEC_DAT_TARGET/USER.xml
					;;
				# Default
				*)
					echo "Using default 8916_fuseblower_USER.xml file"			
					;;
			esac
			
			if [[ "$ANTI_ROLLBACK_ENABLE" == "true" ]] ; then
				echo " Preparing Rollback Prevention Enabled binary"
				#lets use default QC, OEM XML files provided by Qcom.
				cp -v -f config/$SEC_DAT_TARGET/$SEC_DAT_TARGET_fuseblower_QC.xml config/$SEC_DAT_TARGET/QC.xml
				cp -v -f config/$SEC_DAT_TARGET/$SEC_DAT_TARGET_fuseblower_OEM.xml config/$SEC_DAT_TARGET/OEM.xml
			elif [[ "$ANTI_ROLLBACK_IGNORE" == "true" ]] ; then
				echo " Preparing Testbit binary "
				cp -v -f config/$SEC_DAT_TARGET/${SEC_DAT_TARGET}_fuseblower_QC_Testbit.xml config/$SEC_DAT_TARGET/QC.xml
				cp -v -f config/$SEC_DAT_TARGET/${SEC_DAT_TARGET}_fuseblower_OEM.xml config/$SEC_DAT_TARGET/OEM.xml	
			else
				echo " Preparing SecureBoot Binary with RP Disabled "
				cp -v -f config/$SEC_DAT_TARGET/${SEC_DAT_TARGET}_fuseblower_QC_WithoutRP.xml config/$SEC_DAT_TARGET/QC.xml
				cp -v -f config/$SEC_DAT_TARGET/${SEC_DAT_TARGET}_fuseblower_OEM_WithoutRP.xml config/$SEC_DAT_TARGET/OEM.xml
			fi
			
			python sectools.py fuseblower -e config/$SEC_DAT_TARGET/OEM.xml -q config/$SEC_DAT_TARGET/QC.xml -u config/$SEC_DAT_TARGET/USER.xml -g -a -d
			cp -v -f ./fuseblower_output/* $BUILD_DIR/bin/AAAAANAZ/
		else
			echo "Copying Dummy sec.dat file"
			cp -v -f ./resources/build/* $BUILD_DIR/bin/AAAAANAZ/
		fi        
	else
        echo "Copying Dummy sec.dat file"
        cp -v -f ./resources/build/* $BUILD_DIR/bin/AAAAANAZ/
	fi    
}

MAKE_MODEL_DEFINE
cp -v board.h $TZ_BUILD_DIR/board.h
MAKE_SECDAT_FILE

echo "1-NHLOS build: build rpm on $PROJECT_NAME"
cd $RPM_BUILD_DIR
./buildss.sh $VARIANT_TARGET

echo "2-NHLOS build: build trustzone"
cd $TZ_BUILD_DIR
./buildss.sh $VARIANT_TARGET $SECURE_NAME

echo "3-NHLOS build: build sbl image"
cd $BUILD_DIR
./buildss.sh $VARIANT_TARGET

QPSA_SIGNING


cd $BUILD_DIR
cp -v -f $RPM_BUILD_DIR/ms/bin/$VARIANT_TARGET/* $BUILD_DIR/bin/AAAAANAZ/
cp -v -f $TZ_BUILD_DIR/bin/$TZ_BUILD_ID/* $BUILD_DIR/bin/AAAAANAZ/
cp -v -f $BUILD_DIR/bin/$VARIANT_TARGET/* $BUILD_DIR/bin/AAAAANAZ/

MAKE_EMERGENCY_TOOL
echo "## End of build_linux_samsung.sh ##"
