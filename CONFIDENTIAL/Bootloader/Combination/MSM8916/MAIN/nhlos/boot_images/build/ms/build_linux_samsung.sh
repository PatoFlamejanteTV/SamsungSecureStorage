
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

SECURE_NAME=''
# For Rollback Prevention.
ANTI_ROLLBACK_ENABLE=false
# For Testbit Binary
ANTI_ROLLBACK_IGNORE=false
# For CSB debugging purpose through JTAG.
SECURE_FUSE_DEBUG_ENABLE=false

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

	## COMMON Defines
	DEFINE SEC_FOTA_FEATURE 1
	DEFINE SEC_DEBUG_FEATURE 1
	DEFINE SEC_READ_PARAM_FEATURE 1
	DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
	SEC_BAM_TZ_DISABLE_SPI=1
	DEFINE SBL_DVDD_HARD_RESET 1

	## Model Defines
	# SECURE_NAME/SMPL Setting
	echo 'BUILD : '$T_MODEL'_'$T_CARRIER
	SECURE_NAME=SECUREBOOT_NOT_DEFINED
	case $T_MODEL'_'$T_CARRIER in
		KLEOSLTE_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			MODEL_NAME=SM-G510F_EUR_XX
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX            
			#ANTI_ROLLBACK_ENABLE=true #These flags enables rollback prevention
			#DEFINE ANTI_ROLLBACK 1	
			;;
		VASTALTE_CHN_CMCC)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		VASTALTE_CHN_TDOPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			MODEL_NAME=SM-G7508Q_CHN_CHC
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX            
			#ANTI_ROLLBACK_ENABLE=true #These flags enables rollback prevention
			#DEFINE ANTI_ROLLBACK 1	
			;;
		VASTA3G_EUR_OPEN)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
      #temp secure.
			MODEL_NAME=SM-G7508Q_CHN_CHC
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX            
			#ANTI_ROLLBACK_ENABLE=true #These flags enables rollback prevention
			#DEFINE ANTI_ROLLBACK 1	
			;;
		ROSSALTE_CHN_CMCC)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		FORTUNALTE_CHN_CMCC)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		LEVILTE_CHN_CMCC)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
		LEVILTE_CHN_CTC)
			DEFINE NUM_OF_ROOT_CERTS 16
			DEFINE SEC_SMPL_FEATURE 1
			;;
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

		KLEOSLTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 117
			DEFINE HW_REV_2 118
			DEFINE HW_REV_3 119
			;;
		VASTALTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 117
			DEFINE HW_REV_2 118
			DEFINE HW_REV_3 119
			;;
		VASTA3G)
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
		FORTUNALTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 117
			DEFINE HW_REV_2 118
			DEFINE HW_REV_3 119
			;;
		LEVILTE)
			DEFINE HW_REV_0 116
			DEFINE HW_REV_1 117
			DEFINE HW_REV_2 118
			DEFINE HW_REV_3 119
			;;
		# Default
		*)
			echo "use default define value"
			;;
	esac
}
QPSA_SIGNING()
{
  if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
    cd $COMM_BUILD_DIR
    SIGN_LOG_FILE=$BUILD_DIR/build-log.txt
    echo "5-NHLOS build: Secure boot 3.0 signing" | tee -a ${SIGN_LOG_FILE}

    ##### Bootloader secureboot signing : sbl1, tz, rpm, sdi, appsboot, emmcbld
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sbl1 -input $BUILD_DIR/bin/8916/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8916/unsigned/signed_sbl1.mbn" | tee -a ${SIGN_LOG_FILE}
	mkdir -p $BUILD_DIR/bin/8916/qcom_default_signed	
	mv $BUILD_DIR/bin/8916/sbl1.mbn $BUILD_DIR/bin/8916/qcom_default_signed/sbl1.mbn	
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sbl1 -input $BUILD_DIR/bin/8916/unsigned/sbl1.mbn -output $BUILD_DIR/bin/8916/unsigned/signed_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8916/unsigned/signed_sbl1.mbn ] ; then      
      mv $BUILD_DIR/bin/8916/unsigned/signed_sbl1.mbn $BUILD_DIR/bin/8916/sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
    mkdir -p $TZ_BUILD_DIR/bin/MAUAANAA/qcom_default_signed
    mv $TZ_BUILD_DIR/bin/MAUAANAA/tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/qcom_default_signed
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tz.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz.mbn ] ; then      
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tz.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    if [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" != "" ]] ; then
        mkdir -p $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE | tee -a ${SIGN_LOG_FILE}
        cp -v $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
        echo "java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${MODEL_NAME}_ROOT0 -runtype qc_secimg_qsee -input $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/unsigned_tz.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
            openssl dgst -sha256 -binary $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn > sig_32
            java -jar signclient.jar -runtype ss_openssl_sha -model ${MODEL_NAME}_ROOT0 -input sig_32 -output sig_256 | tee -a ${SIGN_LOG_FILE}
            cat $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn sig_256 > $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn
            rm sig_32 -f
            rm sig_256 -f
            if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn ] ; then
                mv $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz_CSB_signed.mbn | tee -a ${SIGN_LOG_FILE}
                mv $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/signed_tz.mbn $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE/tz.mbn | tee -a ${SIGN_LOG_FILE}
                cd $TZ_BUILD_DIR/bin/MAUAANAA/takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE
                tar -cvf qsee_takeover_$SEC_BUILD_OPTION_KNOX_CERT_TYPE.tar tz.mbn | tee -a ${SIGN_LOG_FILE}
                cd $COMM_BUILD_DIR
            else
                echo "securedownload signing error for takeover signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
            fi
            else
                echo "secureboot signing error for takeover signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
	fi
	
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_rpm  -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn ] ; then
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned_rpm.mbn | tee -a ${SIGN_LOG_FILE}
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_rpm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_qhee -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/hyp.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/hyp.mbn" | tee -a ${SIGN_LOG_FILE}
    mv $TZ_BUILD_DIR/bin/MAUAANAA/hyp.mbn $TZ_BUILD_DIR/bin/MAUAANAA/qcom_default_signed
    java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_qhee -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/hyp.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_hyp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_hyp.mbn ] ; then     
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_hyp.mbn $TZ_BUILD_DIR/bin/MAUAANAA/hyp.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_hyp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/signed_emmc_appsboot.mbn ] ; then
      mv $BUILD_DIR/emmc_appsboot.mbn $BUILD_DIR/bin/AAAAANAZ/unsigned_aboot.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/signed_emmc_appsboot.mbn $BUILD_DIR/bin/AAAAANAZ/aboot.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_emmc_appsboot.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_emmcbld -input $BUILD_DIR/bin/8916/unsigned/MPRG8916.mbn -output $BUILD_DIR/bin/8916/unsigned/signed_MPRG8916.mbn" | tee -a ${SIGN_LOG_FILE}
    mv $BUILD_DIR/bin/8916/MPRG8916.mbn $BUILD_DIR/bin/8916/qcom_default_signed/MPRG8916.mbn	
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_emmcbld -input $BUILD_DIR/bin/8916/unsigned/MPRG8916.mbn -output $BUILD_DIR/bin/8916/unsigned/signed_MPRG8916.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8916/unsigned/signed_MPRG8916.mbn ] ; then
      mv $BUILD_DIR/bin/8916/unsigned/signed_MPRG8916.mbn $BUILD_DIR/bin/8916/MPRG8916.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_MPRG8916.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    ##### Non-HLOS secureboot signing : wcnss, cmnlib, isdbtmm, playready, sshdcpapp, mldap, sec_storage, devauth, widevine, mc_v2, tima_pkm, tima_lkm, tima_key, tima_atn, tz_ccm, prov, skm, keymaster, dtcpip, dxprdy, tzpr25, skmm_ta, securefp, reactive, fp_asm

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_wcnss -input $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/8916/reloc/signed_wcnss.mbn" | tee -a ${SIGN_LOG_FILE}
    if [ -f $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn ] ; then
		chmod 0644 $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_wcnss -input $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn -output $WCNSS_BUILD_DIR/bin/8916/reloc/signed_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $WCNSS_BUILD_DIR/bin/8916/reloc/signed_wcnss.mbn ] ; then
		  mv $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn $WCNSS_BUILD_DIR/bin/8916/reloc/unsigned_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		  mv $WCNSS_BUILD_DIR/bin/8916/reloc/signed_wcnss.mbn $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		else
		  echo "secureboot signing error for signed_wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "secureboot signing skip $WCNSS_BUILD_DIR/bin/8916/reloc/wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_cmnlib  -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_cmnlib.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_cmnlib -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/cmnlib.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_cmnlib.mbn ] ; then      
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_cmnlib.mbn $TZ_BUILD_DIR/bin/MAUAANAA/cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_cmnlib.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_isdbtmm -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_isdbtmm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_isdbtmm -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_isdbtmm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_isdbtmm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_isdbtmm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/playready.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_playready -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_playready.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_playready -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/playready.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_playready.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_playready.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_playready.mbn $TZ_BUILD_DIR/bin/MAUAANAA/playready.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_playready.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/playready.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tzpr25.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tzpr25.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tzpr25.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tzpr25.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tzpr25.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tzpr25.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tzpr25.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/tzpr25.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi	

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/securefp.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/securefp.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_securefp.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/securefp.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_securefp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_securefp.mbn ] ; then      
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_securefp.mbn $TZ_BUILD_DIR/bin/MAUAANAA/securefp.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_securefp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/securefp.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/fp_asm.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/fp_asm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_fp_asm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/fp_asm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_fp_asm.mbn ] ; then     
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_fp_asm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_fp_asm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/fp_asm.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/venus.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_venus  -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_venus.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_venus -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/venus.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_venus.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_venus.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_venus.mbn $TZ_BUILD_DIR/bin/MAUAANAA/venus.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_venus.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi   
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/venus.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    if [[ "$DTCPIP_ENABLED" == 1 ]] ; then
      echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dtcpip.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dtcpip.mbn" | tee -a ${SIGN_LOG_FILE}
      java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dtcpip.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dtcpip.mbn ] ; then
        mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dtcpip.mbn $TZ_BUILD_DIR/bin/MAUAANAA/dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      else
        echo "secureboot signing error for signed_dtcpip.mbn!" | tee -a ${SIGN_LOG_FILE}
      fi
    fi

    if [[ "$DXPRDY_ENABLED" == 1 ]] ; then
      echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dxprdy -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dxprdy.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dxprdy.mbn" | tee -a ${SIGN_LOG_FILE}
      java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dxprdy -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dxprdy.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dxprdy.mbn | tee -a ${SIGN_LOG_FILE}
      if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dxprdy.mbn ] ; then
        mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dxprdy.mbn $TZ_BUILD_DIR/bin/MAUAANAA/dxprdy.mbn | tee -a ${SIGN_LOG_FILE}
      else
        echo "secureboot signing error for signed_dxprdy.mbn!" | tee -a ${SIGN_LOG_FILE}
      fi
    fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sshdcpapp.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sshdcpapp -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sshdcpapp -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sshdcpapp.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/MAUAANAA/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    else
		  echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mldap.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_mldap -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mldap.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mldap.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_mldap -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mldap.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mldap.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mldap.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mldap.mbn $TZ_BUILD_DIR/bin/MAUAANAA/mldap.mbn | tee -a ${SIGN_LOG_FILE}
    else
		  echo "secureboot signing error for signed_mldap.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mldap.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi


	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sec_storage.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sec_storage -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sec_storage.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_sec_storage -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sec_storage.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sec_storage.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/MAUAANAA/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/devauth.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/devauth.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_devauth.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/devauth.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_devauth.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_devauth.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_devauth.mbn $TZ_BUILD_DIR/bin/MAUAANAA/devauth.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_widevine  -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_widevine.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype  qc_secimg_widevine -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/widevine.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_widevine.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_widevine.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_widevine.mbn $TZ_BUILD_DIR/bin/MAUAANAA/widevine.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_widevine.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dmverity.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dmverity -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dmverity.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dmverity.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dmverity -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dmverity.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dmverity.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dmverity.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_dmverity.mbn $TZ_BUILD_DIR/bin/MAUAANAA/dmverity.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_dmverity.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/dmverity.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    ## IF TIMA_ENABLED, signing tima_pkm, tima_lkm, tima_key, tima_atn, tz_ccm
    if [[ "$TIMA_ENABLED" == "1" ]] ; then
	  ##++++++++++++++++++++ temporarily rename tima_*.mbn to lkmauth, tima for signing
	  cp -v -f $TZ_BUILD_DIR/bin/MAUAANAA/tima_lkm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/lkmauth.mbn
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_lkmauth -input $TZ_BUILD_DIR/bin/MAUAANAA/lkmauth.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_lkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_lkm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_lkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_pkm -input $TZ_BUILD_DIR/bin/MAUAANAA/tima_pkm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_pkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_pkm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_pkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_atn -input $TZ_BUILD_DIR/bin/MAUAANAA/tima_atn.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_atn.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_atn.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_atn.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tima_key -input $TZ_BUILD_DIR/bin/MAUAANAA/tima_key.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_key.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tima_key.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_key.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

          if [[ "$TIMA_VERSION" == "3" ]] ; then
 	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_tz_ccm -input $TZ_BUILD_DIR/bin/MAUAANAA/tz_ccm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz_ccm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_tz_ccm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tz_ccm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
          fi
	  ##++++++++++++++++++++
    ################
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mc_v2.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mc_v2.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mc_v2.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mc_v2.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mc_v2.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_mc_v2.mbn $TZ_BUILD_DIR/bin/MAUAANAA/mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/prov.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_prov -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/prov.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_prov.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_prov -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/prov.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_prov.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_prov.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_prov.mbn $TZ_BUILD_DIR/bin/MAUAANAA/prov.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_prov.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/prov.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skm.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_skm -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_skm -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skm.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skm.mbn $TZ_BUILD_DIR/bin/MAUAANAA/skm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skm.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skmm_ta.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skmm_ta.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skmm_ta.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_skmm_ta.mbn $TZ_BUILD_DIR/bin/MAUAANAA/skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/keymaster.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_keymaster -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/keymaster.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_keymaster.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_keymaster -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/keymaster.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_keymaster.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_keymaster.mbn $TZ_BUILD_DIR/bin/MAUAANAA/keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/reactive.mbn ] ; then
      # temporarily rename to act_lock.mbn for signing
      mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/reactive.mbn $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/act_lock.mbn | tee -a ${SIGN_LOG_FILE}
      echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_actlock -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/act_lock.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_act_lock.mbn" | tee -a ${SIGN_LOG_FILE}
      java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_secimg_actlock -input $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/act_lock.mbn -output $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_act_lock.mbn | tee -a ${SIGN_LOG_FILE}
      if [ -f $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_act_lock.mbn ] ; then
        mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/act_lock.mbn $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/reactive.mbn | tee -a ${SIGN_LOG_FILE}
        mv $TZ_BUILD_DIR/bin/MAUAANAA/unsigned/signed_act_lock.mbn $TZ_BUILD_DIR/bin/MAUAANAA/reactive.mbn | tee -a ${SIGN_LOG_FILE}
      else
        echo "secureboot signing error for signed_reactive.mbn!" | tee -a ${SIGN_LOG_FILE}
      fi
    else
      echo "secureboot signing skip $TZ_BUILD_DIR/bin/MAUAANAA/reactive.mbn!" | tee -a ${SIGN_LOG_FILE}
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
		cp -v $BUILD_DIR/bin/AAAAANAZ/MPRG8916.mbn IMAGES/
	else	
		cp -v $BUILD_DIR/emmc_appsboot.mbn IMAGES/aboot.mbn
		cp -v $BUILD_DIR/bin/8916/unsigned/MPRG8916.mbn IMAGES/
	fi
}

MAKE_SECDAT_FILE()
{
    cd $NHLOS_ROOT_DIR/common/tools/sectools
	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then		
		if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
			echo "Make sec.dat File "		
						
			case $T_MODEL'_'$T_CARRIER in
				KLEOSLTE_EUR_OPEN)
					if [[ "$SECURE_FUSE_DEBUG_ENABLE" == "true" ]] ; then
						cp -v -f config/8916/8916_fuseblower_kleoslte_eur_open_JTAGEnabled_USER.xml config/8916/USER.xml
					else
						cp -v -f config/8916/8916_fuseblower_kleoslte_eur_open_USER.xml config/8916/USER.xml					
					fi
					;;
				FORTUNALTE_CHN_CMCC)
					if [[ "$SECURE_FUSE_DEBUG_ENABLE" == "true" ]] ; then
						cp -v -f config/8916/8916_fuseblower_fortunalte_cmcc_JTAGEnabled_USER.xml config/8916/USER.xml
					else
						cp -v -f config/8916/8916_fuseblower_fortunalte_cmcc_USER.xml config/8916/USER.xml
					fi
					;;
				VASTALTE_CHN_TDOPEN)
					if [[ "$SECURE_FUSE_DEBUG_ENABLE" == "true" ]] ; then
						cp -v -f config/8916/8916_fuseblower_vastalte_chn_chc_JTAGEnabled_USER.xml config/8916/USER.xml
					else
						cp -v -f config/8916/8916_fuseblower_vastalte_chn_chc_USER.xml config/8916/USER.xml
					fi
					;;
				# Default
				*)
					echo "Using default 8916_fuseblower_USER.xml file"			
					;;
			esac
			
			if [[ "$ANTI_ROLLBACK_ENABLE" == "true" ]] ; then
				echo " Preparing Rollback Prevention Enabled binary"
				#lets use default QC, OEM XML files provided by Qcom.
				cp -v -f config/8916/8916_fuseblower_QC.xml config/8916/QC.xml
				cp -v -f config/8916/8916_fuseblower_OEM.xml config/8916/OEM.xml
			elif [[ "$ANTI_ROLLBACK_IGNORE" == "true" ]] ; then
				echo " Preparing Testbit binary "
				cp -v -f config/8916/8916_fuseblower_QC_Testbit.xml config/8916/QC.xml
				cp -v -f config/8916/8916_fuseblower_OEM.xml config/8916/OEM.xml
			elif [[ "$SECURE_FUSE_DEBUG_ENABLE" == "true" ]] ; then
				echo " Preparing Secure boot binary with JTAG Enabled "
				cp -v -f config/8916/8916_fuseblower_QC_JTAGEnable.xml config/8916/QC.xml
				cp -v -f config/8916/8916_fuseblower_OEM_WithoutRP.xml config/8916/OEM.xml
			else
				echo " Preparing SecureBoot Binary with RP Disabled "
				cp -v -f config/8916/8916_fuseblower_QC_WithoutRP.xml config/8916/QC.xml
				cp -v -f config/8916/8916_fuseblower_OEM_WithoutRP.xml config/8916/OEM.xml
			fi
			
			python sectools.py fuseblower -e config/8916/OEM.xml -q config/8916/QC.xml -u config/8916/USER.xml -g -a -d
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
./buildss.sh

echo "2-NHLOS build: build trustzone"
cd $TZ_BUILD_DIR
./buildss.sh $SECURE_NAME

echo "3-NHLOS build: build sbl image"
cd $BUILD_DIR
./buildss.sh

QPSA_SIGNING


cd $BUILD_DIR
cp -v -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/* $BUILD_DIR/bin/AAAAANAZ/
cp -v -f $TZ_BUILD_DIR/bin/MAUAANAA/* $BUILD_DIR/bin/AAAAANAZ/
cp -v -f $BUILD_DIR/bin/8916/* $BUILD_DIR/bin/AAAAANAZ/

#This is temporarily fix till solve hyp hang isue
#echo "hyp binary should be chanaged as FC"
#cp -v -f $TZ_BUILD_DIR/bin/bin_for_hyp/* $BUILD_DIR/bin/AAAAANAZ/

MAKE_EMERGENCY_TOOL

echo "## End of build_linux_samsung.sh ##"
