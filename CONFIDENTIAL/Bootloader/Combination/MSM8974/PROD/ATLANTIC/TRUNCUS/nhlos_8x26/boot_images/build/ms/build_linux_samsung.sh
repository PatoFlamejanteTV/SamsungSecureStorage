
#===============================================================================
# Build boot & jsdcc tool
#===============================================================================
echo "## Start of build_linux_samsung.sh ##"

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

cd $NHLOS_ROOT_DIR/wcnss_proc/build/ms
WCNSS_BUILD_DIR=`pwd`

if [[ "$TARGET_PRODUCT" == "matissewifiue" && "$SEC_BUILD_OPTION_HW_REVISION" == "00" ]] ; then
  cd $WCNSS_BUILD_DIR/bin/8x26/cxo
  WCNSS_BUILD_DIR=`pwd`
else
  cd $WCNSS_BUILD_DIR/bin/8x26
  WCNSS_BUILD_DIR=`pwd`
fi

# delete mbn files
rm -rf $BUILD_DIR/bin/FAAAANAZ
rm -rf $BUILD_DIR/bin/8x26

#create new BUILD_ID folder
mkdir -p $BUILD_DIR/bin/FAAAANAZ

#for model define
cd $BUILD_DIR

export $*

SECURE_NAME=''
DDR_SIZE=ONE_AND_HALF_GB

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
			DEFINE KNOX_A_TAKEOVER 1
			DEFINE CERT_HASH_INDEX	0xE1000000
			CSB_SUFFIX=ROOT1
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxb" ]]; then
			DEFINE KNOX_B_TAKEOVER 1
			DEFINE CERT_HASH_INDEX	0xD2000000
			CSB_SUFFIX=ROOT2
		elif [[ "$SEC_BUILD_OPTION_KNOX_CERT_TYPE" == "knoxc" ]]; then
			DEFINE KNOX_C_TAKEOVER 1
			DEFINE CERT_HASH_INDEX	0xC3000000
			CSB_SUFFIX=ROOT3
		else 
			DEFINE KNOX_CSB 1
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
	SEC_BAM_TZ_DISABLE_SPI=1

	## Model Defines
	# SECURE_NAME/SMPL Setting
	echo 'BUILD : '$T_MODEL'_'$T_CARRIER
	SECURE_NAME=SECUREBOOT_NOT_DEFINED
	case $T_MODEL'_'$T_CARRIER in
		MILLET3G_EUR_OPEN)
			MODEL_NAME=SM-T331_EUR_XX
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
			DEFINE SBL_DVDD_HARD_RESET 1
            ;;
		
		MILLET3G_MEA)
			MODEL_NAME=SM-T332_MEA_JT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
            ;;
		MILLETWIFI_EUR_OPEN)
			MODEL_NAME=SM-T330_EUR_XX
			DDR_SIZE=AUTO_DETECT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
			DEFINE SBL_DVDD_HARD_RESET 1
            ;;
		MILLETWIFIDEMO_EUR_OPEN)
			#Using MILLETWIFI_EUR_OPEN as base model.
			#Using same security key as used by MILLETWIFI_EUR_OPEN
			MODEL_NAME=SM-T330_EUR_XX
			DDR_SIZE=ONE_GB
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
            ;;
		MILLETWIFI_US_OPEN)
			MODEL_NAME=SM-T330NU_NA_XAR
			DDR_SIZE=AUTO_DETECT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
			DEFINE SBL_DVDD_HARD_RESET 1
            ;;
		MATISSE3G_EUR_OPEN)
			MODEL_NAME=SM-T531_EUR_XX
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
            		DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1			
            ;;
		MATISSE3G_MEA_JT)
			MODEL_NAME=SM-T532_MEA_JT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
            		DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
            ;;
		MATISSEWIFI_EUR_OPEN)
			MODEL_NAME=SM-T530_EUR_XX
			DDR_SIZE=AUTO_DETECT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
            		DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
	    ;;
		MATISSEWIFIDEMO_EUR_OPEN)
			#Using MATISSEWIFI_EUR_OPEN as base model
			#Using same security key as used by MATISSEWIFI_EUR_OPEN
			MODEL_NAME=SM-T530_EUR_XX
			DDR_SIZE=ONE_GB
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
            		DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
	    ;;
		MATISSEWIFI_US_OPEN)
			MODEL_NAME=SM-T530NU_NA_XAR
			DDR_SIZE=AUTO_DETECT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
	    ;;
		MATISSEWIFIGOOGLE_US_OPEN)
			MODEL_NAME=SM-T530NN_NA_STA
			DDR_SIZE=AUTO_DETECT
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
	    ;;
		MATISSEWIFI_US_OPEN_AMP)
            		SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
            		DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
            ;;	
	    	AFYONLTE_USA_TMO)
            		SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
            		DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
            ;;	
		ATLANTIC3G_EUR_OPEN)
			MODEL_NAME=SM-G800H_CIS_SKZ
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE ENABLE_LDO15_BOOST_KMINI_IRDA 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
            ;;
		BERLUTI3G_EUR_OPEN)
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
            ;;
        	S3VE3G_EUR_OPEN)
			MODEL_NAME=GT-I9301I_EUR_XX
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
            ;;
		S3VEDS_EUR_OPEN)
			MODEL_NAME=GT-I9300I_CHN_CHN
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE WA_CODE_FOR_PDN 1
            ;;
			MS013G_EUR_OPEN)
			MODEL_NAME=SM-G7102_CIS_SER
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
            DEFINE SEC_SMPL_FEATURE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
            ;;
        	VICTOR3GDTV_LTN_OPEN)
			MODEL_NAME=SM-B8282_LA_ZTO
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DDR_SIZE=AUTO_DETECT
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			SEC_BAM_TZ_DISABLE_SPI=0
            ;;
		MILLET3G_CHN_OPEN)
			MODEL_NAME=SM-T331C_CHN_CHN
			SECURE_NAME=$MODEL_NAME'_'$CSB_SUFFIX
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
			DEFINE ANTI_ROLLBACK_ENABLE 1
            ;;
		MEGA23G_EUR_OPEN)
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
			DEFINE VREG_XO_ENABLE 1
            ;;
		T10_3G_EUR_OPEN)
			MODEL_NAME=SM-T541_EUR_XX
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
              ;;
		T8_3G_EUR_OPEN)
			MODEL_NAME=SM-T341_EUR_XX
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
              ;;
	      T10_WIFI_EUR_OPEN)
			MODEL_NAME=SM-T540_EUR_XX
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 4
			DEFINE SEC_SMPL_FEATURE 1
			DEFINE FEATURE_QHSUSB_FLCB_STOP_CHARGING 1
              ;;

		# Default
		*)
			echo "use default define value"
			SECURE_NAME=SECUREBOOT_NOT_DEFINED
			DEFINE NUM_OF_ROOT_CERTS 0
			DEFINE SEC_SMPL_FEATURE 1
			;;
	esac

	## COMMON Defines to support variables
	DEFINE BAM_TZ_DISABLE_SPI $SEC_BAM_TZ_DISABLE_SPI

	## Model Defines
	echo 'BUILD : '$T_MODEL
	case $T_MODEL'_'$T_CARRIER in
		MILLET3G_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
                        ;;
		MILLET3G_MEA)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
                        ;;
		MILLETWIFI_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
                        ;;
		MILLETWIFIDEMO_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
                        ;;
		MILLETWIFI_US_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
            ;;
		MATISSE3G_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			            DEFINE HW_REV_3 114
			            DEFINE ENABLE_LDO23 1
		                ;;
		MATISSE3G_MEA_JT)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
						DEFINE HW_REV_3 114
						DEFINE ENABLE_LDO23 1
						;;
		MATISSEWIFI_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			DEFINE HW_REV_3 114
			DEFINE ENABLE_LDO23 1
			;;
		MATISSEWIFIDEMO_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			DEFINE HW_REV_3 114
			DEFINE ENABLE_LDO23 1
			;;
		MATISSEWIFI_US_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			DEFINE HW_REV_3 114
			DEFINE ENABLE_LDO23 1
			;;
		MATISSEWIFIGOOGLE_US_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			DEFINE HW_REV_3 114
			DEFINE ENABLE_LDO23 1
			;;
		MATISSEWIFI_US_OPEN_AMP)
			DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			DEFINE HW_REV_3 114
			DEFINE ENABLE_LDO23 1
			;;
		AFYONLTE_USA_TMO)
                        DEFINE HW_REV_0 15
                        DEFINE HW_REV_1 14
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
	                ;;
		BERLUTI3G_EUR_OPEN)
                        DEFINE HW_REV_0 15
                        DEFINE HW_REV_1 14
                        DEFINE HW_REV_2 13
                        DEFINE HW_REV_3 12
			DEFINE SEC_HWREV_LPDDR3 0
                        ;;
        	S3VE3G_EUR_OPEN)
                        DEFINE HW_REV_0 15
                        DEFINE HW_REV_1 14
                        DEFINE HW_REV_2 13
                        DEFINE HW_REV_3 12
                        ;;
			S3VEDS_EUR_OPEN)
                        DEFINE HW_REV_0 81
                        DEFINE HW_REV_1 14
                        DEFINE HW_REV_2 13
                        ;;
			MS013G_EUR_OPEN)
						DEFINE HW_REV_0 81
						DEFINE HW_REV_1 14
						DEFINE HW_REV_2 13
						;;
        	VICTOR3GDTV_LTN_OPEN)
                        DEFINE HW_REV_0 15
                        DEFINE HW_REV_1 14
                        DEFINE HW_REV_2 13
                        DEFINE HW_REV_3 12
                        ;;
		ATLANTIC3G_EUR_OPEN)
                        DEFINE HW_REV_0 24
                        DEFINE HW_REV_1 67
                        DEFINE HW_REV_2 13
                        DEFINE HW_REV_3 12
                        ;;
		MILLET3G_CHN_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
			DEFINE HW_REV_3 12
                        ;;
		MEGA23G_EUR_OPEN)
                        DEFINE HW_REV_0 24
                        DEFINE HW_REV_1 67
                        DEFINE HW_REV_2 13
                        DEFINE HW_REV_3 12
                        ;;
		T10_3G_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
			DEFINE HW_REV_3 114
			DEFINE ENABLE_LDO23 1
                        ;;
		T8_3G_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 32
                        DEFINE HW_REV_2 13
                        DEFINE HW_REV_3 12
			;;
		T10_WIFI_EUR_OPEN)
                        DEFINE HW_REV_0 63
                        DEFINE HW_REV_1 49
                        DEFINE HW_REV_2 50
                        DEFINE HW_REV_3 114
                        DEFINE ENABLE_LDO23 1
			;;

		# Default
		*)
			echo "use default define value"
			;;
	esac
	
	# Secureboot default value (no evironment variable)
	echo 'Secureboot Environment : '$QUALCOMM_SECURE_BOOT_DISABLE
	if [[ "$QUALCOMM_SECURE_BOOT_DISABLE" == "" ]] ; then
		case $T_MODEL'_'$T_CARRIER in


			MILLET3G_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MILLET3G_MEA)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MILLETWIFI_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MILLETWIFIDEMO_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MILLETWIFI_US_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSE3G_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSE3G_MEA_JT)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSEWIFI_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSEWIFIDEMO_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSEWIFI_US_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSEWIFIGOOGLE_US_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MATISSEWIFI_US_OPEN_AMP)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
				;;
			AFYONLTE_USA_TMO)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;
			ATLANTIC3G_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			T10_3G_EUR_OPEN)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;
			T8_3G_EUR_OPEN)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;
			T10_WIFI_EUR_OPEN)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;

			BERLUTI3G_EUR_OPEN)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;
			S3VE3G_EUR_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			S3VEDS_EUR_OPEN)
								if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
									QUALCOMM_SECURE_BOOT_DISABLE=false
								else
									QUALCOMM_SECURE_BOOT_DISABLE=true
								fi
                                ;;
			MS013G_EUR_OPEN)
				if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
					QUALCOMM_SECURE_BOOT_DISABLE=false
				else
					QUALCOMM_SECURE_BOOT_DISABLE=true
				fi
                ;;
			VICTOR3GDTV_LTN_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MILLET3G_CHN_OPEN)
                                if [[ $SEC_BUILD_OPTION_KNOX_CSB == true ]]; then
                                    QUALCOMM_SECURE_BOOT_DISABLE=false
                                else
                                    QUALCOMM_SECURE_BOOT_DISABLE=true
                                fi
                                ;;
			MEGA23G_EUR_OPEN)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;
			*)
                                QUALCOMM_SECURE_BOOT_DISABLE=true
                                ;;
		esac
	fi

	# Set Secureboot Setting
	if [[ "$QUALCOMM_SECURE_BOOT_DISABLE" == "true" ]] ; then
		DEFINE SEC_SECURE_FUSE 0
		DEFINE SEC_SECURE_FUSE_NO_DEBUG 0
	else
		DEFINE SEC_SECURE_FUSE 1
		DEFINE SEC_SECURE_FUSE_NO_DEBUG 1
	fi
}

QPSA_SIGNING()
{
  if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
    cd $COMM_BUILD_DIR
    SIGN_LOG_FILE=$BUILD_DIR/build-log.txt
    echo "5-NHLOS build: Secure boot 3.0 signing" | tee -a ${SIGN_LOG_FILE}

    ##### Bootloader secureboot signing : sbl1, tz, rpm, sdi, appsboot, emmcbld
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sbl1 -input $BUILD_DIR/bin/8x26/sbl1.mbn -output $BUILD_DIR/bin/8x26/signed_sbl1.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sbl1 -input $BUILD_DIR/bin/8x26/sbl1.mbn -output $BUILD_DIR/bin/8x26/signed_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8x26/signed_sbl1.mbn ] ; then
      mv $BUILD_DIR/bin/8x26/sbl1.mbn $BUILD_DIR/bin/8x26/unsigned_sbl1.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/bin/8x26/signed_sbl1.mbn $BUILD_DIR/bin/8x26/sbl1.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sbl1.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tz -input $TZ_BUILD_DIR/bin/FARAANBA/tz.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tz.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tz -input $TZ_BUILD_DIR/bin/FARAANBA/tz.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tz.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tz.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/tz.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tz.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tz.mbn $TZ_BUILD_DIR/bin/FARAANBA/tz.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tz.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_rpm -input $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn -output $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn ] ; then
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/unsigned_rpm.mbn | tee -a ${SIGN_LOG_FILE}
      mv $RPM_BUILD_DIR/ms/bin/AAAAANAAR/signed_rpm.mbn $RPM_BUILD_DIR/ms/bin/AAAAANAAR/rpm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_rpm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_htelfsdi -input $SDI_BUILD_DIR/bin/AAAAANAZ/sdi.mbn -output $SDI_BUILD_DIR/bin/AAAAANAZ/signed_sdi.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_htelfsdi -input $SDI_BUILD_DIR/bin/AAAAANAZ/sdi.mbn -output $SDI_BUILD_DIR/bin/AAAAANAZ/signed_sdi.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $SDI_BUILD_DIR/bin/AAAAANAZ/signed_sdi.mbn ] ; then
      mv $SDI_BUILD_DIR/bin/AAAAANAZ/sdi.mbn $SDI_BUILD_DIR/bin/AAAAANAZ/unsigned_sdi.mbn | tee -a ${SIGN_LOG_FILE}
      mv $SDI_BUILD_DIR/bin/AAAAANAZ/signed_sdi.mbn $SDI_BUILD_DIR/bin/AAAAANAZ/sdi.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sdi.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_appsbl -input $BUILD_DIR/emmc_appsboot.mbn -output $BUILD_DIR/signed_emmc_appsboot.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/signed_emmc_appsboot.mbn ] ; then
      mv $BUILD_DIR/emmc_appsboot.mbn $BUILD_DIR/bin/FAAAANAZ/unsigned_aboot.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/signed_emmc_appsboot.mbn $BUILD_DIR/bin/FAAAANAZ/aboot.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_emmc_appsboot.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_emmcbld -input $BUILD_DIR/bin/8x26/MPRG8x26.mbn -output $BUILD_DIR/bin/8x26/signed_MPRG8x26.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_emmcbld -input $BUILD_DIR/bin/8x26/MPRG8x26.mbn -output $BUILD_DIR/bin/8x26/signed_MPRG8x26.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $BUILD_DIR/bin/8x26/signed_MPRG8x26.mbn ] ; then
      mv $BUILD_DIR/bin/8x26/MPRG8x26.mbn $BUILD_DIR/bin/8x26/unsigned_MPRG8x26.mbn | tee -a ${SIGN_LOG_FILE}
      mv $BUILD_DIR/bin/8x26/signed_MPRG8x26.mbn $BUILD_DIR/bin/8x26/MPRG8x26.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_MPRG8x26.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    ##### Non-HLOS secureboot signing : wcnss, cmnlib, isdbtmm, playready, sshdcpapp, sec_storage, devauth, widevine, mc_v2, tima_pkm, tima_lkm, prov, skm, keymaster, dtcpip, tzpr25, securefp, fp_asm

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_wcnss -input $WCNSS_BUILD_DIR/wcnss.mbn -output $WCNSS_BUILD_DIR/signed_wcnss.mbn" | tee -a ${SIGN_LOG_FILE}
    if [ -f $WCNSS_BUILD_DIR/wcnss.mbn ] ; then
		chmod 0644 $WCNSS_BUILD_DIR/wcnss.mbn
		java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_wcnss -input $WCNSS_BUILD_DIR/wcnss.mbn -output $WCNSS_BUILD_DIR/signed_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		if [ -f $WCNSS_BUILD_DIR/signed_wcnss.mbn ] ; then
		  mv $WCNSS_BUILD_DIR/wcnss.mbn $WCNSS_BUILD_DIR/unsigned_wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		  mv $WCNSS_BUILD_DIR/signed_wcnss.mbn $WCNSS_BUILD_DIR/wcnss.mbn | tee -a ${SIGN_LOG_FILE}
		else
		  echo "secureboot signing error for signed_wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "secureboot signing skip $WCNSS_BUILD_DIR/wcnss.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_cmnlib -input $TZ_BUILD_DIR/bin/FARAANBA/cmnlib.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_cmnlib.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_cmnlib -input $TZ_BUILD_DIR/bin/FARAANBA/cmnlib.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_cmnlib.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/cmnlib.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_cmnlib.mbn $TZ_BUILD_DIR/bin/FARAANBA/cmnlib.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_cmnlib.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_isdbtmm -input $TZ_BUILD_DIR/bin/FARAANBA/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_isdbtmm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_isdbtmm -input $TZ_BUILD_DIR/bin/FARAANBA/isdbtmm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_isdbtmm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/isdbtmm.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_isdbtmm.mbn $TZ_BUILD_DIR/bin/FARAANBA/isdbtmm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_isdbtmm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/playready.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_playready -input $TZ_BUILD_DIR/bin/FARAANBA/playready.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_playready.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_playready -input $TZ_BUILD_DIR/bin/FARAANBA/playready.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_playready.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_playready.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/playready.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_playready.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_playready.mbn $TZ_BUILD_DIR/bin/FARAANBA/playready.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_playready.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/playready.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/tzpr25.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/FARAANBA/tzpr25.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tzpr25.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tzpr25 -input $TZ_BUILD_DIR/bin/FARAANBA/tzpr25.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tzpr25.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/tzpr25.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tzpr25.mbn $TZ_BUILD_DIR/bin/FARAANBA/tzpr25.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tzpr25.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/tzpr25.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/securefp.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/FARAANBA/securefp.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_securefp.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_securefp -input $TZ_BUILD_DIR/bin/FARAANBA/securefp.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_securefp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_securefp.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/securefp.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_securefp.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_securefp.mbn $TZ_BUILD_DIR/bin/FARAANBA/securefp.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_securefp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/securefp.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/fp_asm.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/FARAANBA/fp_asm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_fp_asm.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_fp_asm -input $TZ_BUILD_DIR/bin/FARAANBA/fp_asm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_fp_asm.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/fp_asm.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_fp_asm.mbn $TZ_BUILD_DIR/bin/FARAANBA/fp_asm.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_fp_asm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/fp_asm.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/venus.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_venus -input $TZ_BUILD_DIR/bin/FARAANBA/venus.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_venus.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_venus -input $TZ_BUILD_DIR/bin/FARAANBA/venus.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_venus.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_venus.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/venus.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_venus.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_venus.mbn $TZ_BUILD_DIR/bin/FARAANBA/venus.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_venus.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi   
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/venus.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    if [[ "$DTCPIP_ENABLED" == 1 ]] ; then
      echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/FARAANBA/dtcpip.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_dtcpip.mbn" | tee -a ${SIGN_LOG_FILE}
      java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_dtcpip -input $TZ_BUILD_DIR/bin/FARAANBA/dtcpip.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_dtcpip.mbn ] ; then
        mv $TZ_BUILD_DIR/bin/FARAANBA/dtcpip.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
        mv $TZ_BUILD_DIR/bin/FARAANBA/signed_dtcpip.mbn $TZ_BUILD_DIR/bin/FARAANBA/dtcpip.mbn | tee -a ${SIGN_LOG_FILE}
      else
        echo "secureboot signing error for signed_dtcpip.mbn!" | tee -a ${SIGN_LOG_FILE}
      fi
    fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/sshdcpapp.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sshdcpapp -input $TZ_BUILD_DIR/bin/FARAANBA/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_sshdcpapp.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sshdcpapp -input $TZ_BUILD_DIR/bin/FARAANBA/sshdcpapp.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_sshdcpapp.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/sshdcpapp.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_sshdcpapp.mbn $TZ_BUILD_DIR/bin/FARAANBA/sshdcpapp.mbn | tee -a ${SIGN_LOG_FILE}
    else
		  echo "secureboot signing error for signed_sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
		fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/sshdcpapp.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/mldap.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mldap -input $TZ_BUILD_DIR/bin/FARAANBA/mldap.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_mldap.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mldap -input $TZ_BUILD_DIR/bin/FARAANBA/mldap.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_mldap.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_mldap.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/mldap.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_mldap.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_mldap.mbn $TZ_BUILD_DIR/bin/FARAANBA/mldap.mbn | tee -a ${SIGN_LOG_FILE}
    else
          echo "secureboot signing error for signed_mldap.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/mldap.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/sec_storage.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sec_storage -input $TZ_BUILD_DIR/bin/FARAANBA/sec_storage.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_sec_storage.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_sec_storage -input $TZ_BUILD_DIR/bin/FARAANBA/sec_storage.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_sec_storage.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/sec_storage.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_sec_storage.mbn $TZ_BUILD_DIR/bin/FARAANBA/sec_storage.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/sec_storage.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/devauth.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/FARAANBA/devauth.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_devauth.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_devauth -input $TZ_BUILD_DIR/bin/FARAANBA/devauth.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_devauth.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_devauth.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/devauth.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_devauth.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_devauth.mbn $TZ_BUILD_DIR/bin/FARAANBA/devauth.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
	else
		echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/devauth.mbn!" | tee -a ${SIGN_LOG_FILE}
	fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_widevine -input $TZ_BUILD_DIR/bin/FARAANBA/widevine.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_widevine.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_widevine -input $TZ_BUILD_DIR/bin/FARAANBA/widevine.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_widevine.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_widevine.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/widevine.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_widevine.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_widevine.mbn $TZ_BUILD_DIR/bin/FARAANBA/widevine.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_widevine.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    ## IF TIMA_ENABLED, signing tima_pkm, tima_lkm
    if [[ "$TIMA_ENABLED" == "1" ]] ; then
	  ##++++++++++++++++++++ temporarily rename tima_*.mbn to lkmauth, tima for signing
	  cp -v -f $TZ_BUILD_DIR/bin/FARAANBA/tima_lkm.mbn $TZ_BUILD_DIR/bin/FARAANBA/lkmauth.mbn
	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_lkmauth -input $TZ_BUILD_DIR/bin/FARAANBA/lkmauth.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_lkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/lkmauth.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_lkmauth.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_lkm.mbn $TZ_BUILD_DIR/bin/FARAANBA/tima_lkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_lkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tima_pkm -input $TZ_BUILD_DIR/bin/FARAANBA/tima_pkm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_pkm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/tima_pkm.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_pkm.mbn $TZ_BUILD_DIR/bin/FARAANBA/tima_pkm.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_pkm.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tima_atn -input $TZ_BUILD_DIR/bin/FARAANBA/tima_atn.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_atn.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/tima_atn.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_atn.mbn $TZ_BUILD_DIR/bin/FARAANBA/tima_atn.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_atn.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

	  java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tima_key -input $TZ_BUILD_DIR/bin/FARAANBA/tima_key.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_key.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/tima_key.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tima_key.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tima_key.mbn $TZ_BUILD_DIR/bin/FARAANBA/tima_key.mbn | tee -a ${SIGN_LOG_FILE}
          else
            echo "secureboot signing error for signed_tima_key.mbn!" | tee -a ${SIGN_LOG_FILE}
          fi

          if [[ "$TIMA_VERSION" == "3" ]] ; then
 	  	java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tz_ccm -input $TZ_BUILD_DIR/bin/FARAANBA/tz_ccm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tz_ccm.mbn ] ; then
            		mv $TZ_BUILD_DIR/bin/FARAANBA/tz_ccm.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
            		mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tz_ccm.mbn $TZ_BUILD_DIR/bin/FARAANBA/tz_ccm.mbn | tee -a ${SIGN_LOG_FILE}
          	else
            		echo "secureboot signing error for signed_tz_ccm.mbn!" | tee -a ${SIGN_LOG_FILE}
          	fi
          fi
	  ##++++++++++++++++++++
    ################
	fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/mc_v2.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/FARAANBA/mc_v2.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_mc_v2.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_mc_v2 -input $TZ_BUILD_DIR/bin/FARAANBA/mc_v2.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_mc_v2.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/mc_v2.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_mc_v2.mbn $TZ_BUILD_DIR/bin/FARAANBA/mc_v2.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/mc_v2.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/tbase300.mbn ] ; then
    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tbase300 -input $TZ_BUILD_DIR/bin/FARAANBA/tbase300.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tbase300.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_tbase300 -input $TZ_BUILD_DIR/bin/FARAANBA/tbase300.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_tbase300.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_tbase300.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/tbase300.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_tbase300.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_tbase300.mbn $TZ_BUILD_DIR/bin/FARAANBA/tbase300.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_tbase300.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/tbase300.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/prov.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_prov -input $TZ_BUILD_DIR/bin/FARAANBA/prov.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_prov.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_prov -input $TZ_BUILD_DIR/bin/FARAANBA/prov.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_prov.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_prov.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/prov.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_prov.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_prov.mbn $TZ_BUILD_DIR/bin/FARAANBA/prov.mbn | tee -a ${SIGN_LOG_FILE}
        else
            echo "secureboot signing error for signed_prov.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/prov.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/skm.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skm -input $TZ_BUILD_DIR/bin/FARAANBA/skm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_skm.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skm -input $TZ_BUILD_DIR/bin/FARAANBA/skm.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_skm.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_skm.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/skm.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_skm.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_skm.mbn $TZ_BUILD_DIR/bin/FARAANBA/skm.mbn | tee -a ${SIGN_LOG_FILE}
        else
            echo "secureboot signing error for signed_skm.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/skm.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/skmm_ta.mbn ] ; then
        echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/FARAANBA/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_skmm_ta.mbn" | tee -a ${SIGN_LOG_FILE}
        java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_skmm_ta -input $TZ_BUILD_DIR/bin/FARAANBA/skmm_ta.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
        if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_skmm_ta.mbn ] ; then
            mv $TZ_BUILD_DIR/bin/FARAANBA/skmm_ta.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
            mv $TZ_BUILD_DIR/bin/FARAANBA/signed_skmm_ta.mbn $TZ_BUILD_DIR/bin/FARAANBA/skmm_ta.mbn | tee -a ${SIGN_LOG_FILE}
        else
            echo "secureboot signing error for signed_skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
        fi
    else
        echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/skmm_ta.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_keymaster -input $TZ_BUILD_DIR/bin/FARAANBA/keymaster.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_keymaster.mbn" | tee -a ${SIGN_LOG_FILE}
    java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_keymaster -input $TZ_BUILD_DIR/bin/FARAANBA/keymaster.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_keymaster.mbn ] ; then
      mv $TZ_BUILD_DIR/bin/FARAANBA/keymaster.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_keymaster.mbn | tee -a ${SIGN_LOG_FILE}
      mv $TZ_BUILD_DIR/bin/FARAANBA/signed_keymaster.mbn $TZ_BUILD_DIR/bin/FARAANBA/keymaster.mbn | tee -a ${SIGN_LOG_FILE}
    else
      echo "secureboot signing error for signed_keymaster.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi

    if [ -f $TZ_BUILD_DIR/bin/FARAANBA/reactive.mbn ] ; then
      #	temporarily rename to act_lock.mbn for signing
      mv $TZ_BUILD_DIR/bin/FARAANBA/reactive.mbn $TZ_BUILD_DIR/bin/FARAANBA/act_lock.mbn | tee -a ${SIGN_LOG_FILE}
      echo "java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_act_lock -input $TZ_BUILD_DIR/bin/FARAANBA/act_lock.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_act_lock.mbn" | tee -a ${SIGN_LOG_FILE}
      java -jar signclient.jar -model ${SECURE_NAME} -runtype qc_qpsa_act_lock -input $TZ_BUILD_DIR/bin/FARAANBA/act_lock.mbn -output $TZ_BUILD_DIR/bin/FARAANBA/signed_act_lock.mbn | tee -a ${SIGN_LOG_FILE}
      if [ -f $TZ_BUILD_DIR/bin/FARAANBA/signed_act_lock.mbn ] ; then
        mv $TZ_BUILD_DIR/bin/FARAANBA/act_lock.mbn $TZ_BUILD_DIR/bin/FARAANBA/unsigned_reactive.mbn | tee -a ${SIGN_LOG_FILE}
        mv $TZ_BUILD_DIR/bin/FARAANBA/signed_act_lock.mbn $TZ_BUILD_DIR/bin/FARAANBA/reactive.mbn | tee -a ${SIGN_LOG_FILE}
      else
        echo "secureboot signing error for signed_reactive.mbn!" | tee -a ${SIGN_LOG_FILE}
      fi
    else
      echo "secureboot signing skip $TZ_BUILD_DIR/bin/FARAANBA/reactive.mbn!" | tee -a ${SIGN_LOG_FILE}
    fi
  fi
}

MAKE_EMERGENCY_TOOL()
{
	echo "make emergency download packages"
	cd $NHLOS_ROOT_DIR/common/tools/emergency_download
	mkdir -p IMAGES/
	cp -v $BUILD_DIR/bin/FAAAANAZ/sbl1.mbn IMAGES/
	cp -v $BUILD_DIR/bin/FAAAANAZ/rpm.mbn IMAGES/
	cp -v $BUILD_DIR/bin/FAAAANAZ/tz.mbn IMAGES/
	cp -v $BUILD_DIR/bin/FAAAANAZ/sdi.mbn IMAGES/

  if [[ "$PROJECT_NAME" == "jvelte" ]] ; then
    echo "This project should be enabled the WCNSS"
    cp -v $BUILD_DIR/bin/FAAAANAZ/wcnss.mbn IMAGES/
  else
    echo "This project should be disabled the WCNSS"
  fi

	if [[ "$SECURE_NAME" != "SECUREBOOT_NOT_DEFINED" ]] ; then
		cp -v $BUILD_DIR/bin/FAAAANAZ/aboot.mbn IMAGES/
		cp -v $BUILD_DIR/bin/FAAAANAZ/MPRG8x26.mbn IMAGES/
	else	
		cp -v $BUILD_DIR/emmc_appsboot.mbn IMAGES/aboot.mbn
		cp -v $BUILD_DIR/bin/8x26/MPRG8x26.mbn IMAGES/
	fi
}

MAKE_MODEL_DEFINE

echo "1-NHLOS build: build rpm on $PROJECT_NAME"
cd $RPM_BUILD_DIR
./buildss.sh

echo "2-NHLOS build: build trustzone"
cd $TZ_BUILD_DIR
#./build.sh CHIPSET=msm8974 tz playready widevine drmprov isdbtmm tzbsp_no_xpu sampleapp securitytest
./buildss.sh $SECURE_NAME

echo "3-NHLOS build: build sbl image"
cd $BUILD_DIR
./buildss.sh

echo "4-NHLOS build: build sdi(system debug image)"
cd $SDI_BUILD_DIR
./buildss.sh $DDR_SIZE

QPSA_SIGNING

cp -v -f $RPM_BUILD_DIR/ms/bin/AAAAANAAR/* $BUILD_DIR/bin/FAAAANAZ/
cp -v -f $TZ_BUILD_DIR/bin/FARAANBA/* $BUILD_DIR/bin/FAAAANAZ/
cp -v -f $BUILD_DIR/bin/8x26/* $BUILD_DIR/bin/FAAAANAZ/
cp -v -f $SDI_BUILD_DIR/bin/AAAAANAZ/* $BUILD_DIR/bin/FAAAANAZ/
cp -v -f $WCNSS_BUILD_DIR/* $BUILD_DIR/bin/FAAAANAZ/

MAKE_EMERGENCY_TOOL

echo "## End of build_linux_samsung.sh ##"
