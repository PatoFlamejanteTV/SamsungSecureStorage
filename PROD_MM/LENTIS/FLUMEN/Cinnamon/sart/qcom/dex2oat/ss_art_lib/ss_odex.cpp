
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include <sys/types.h>
#include <unistd.h>

#include "common/ss_types.h"
#include "common/tz_ta_ss_constants.h"

#include "utils/elf_utils.h"
#include "utils/hash_256.h"
#include "utils/hash_sha1.h"
#include "utils/log.h"
#include "ss_art_lib.h"

#include "ss_odex.h"
#include "ss_art_lib.h" // to define SS_APP_TYPE_ARM32 and SS_APP_TYPE_ARM64

#define SS_SHA256_FULL 1
#define SHA256_HASH_LENGTH 32
#define KEY_SIZE 128
#define SS_GENERAL_FAILURE -1

int SS_IDComposeDex(uint8_t *in_dex, uint32_t dex_len, char *key, uint32_t key_len, const char *app_name, void **out, uint32_t *out_len, uint32_t isThirdparty, int app_type, unsigned hash_type)
{
    uint8_t outHash[SHA256_HASH_LENGTH];
    uint8_t *tmp_out = NULL;
    uint32_t SS_type;
    uint32_t len_SS_ID;
    uint32_t kSHA1DigestLen = 20;
    uint32_t sha1_off = 12;
    const char dex_magic[] = "dex\n";

    if (memcmp(in_dex, dex_magic, sizeof(dex_magic) - 1))
        return -1;

    if (hash_type != SS_USE_FULL_LEN && hash_type != SS_USE_HALF_LEN)
        return -1;

    computeHash(in_dex, dex_len, outHash, hash_type);

    /*calc number of lib*/
    SS_LOGD("input lib len %d", key_len);
    char *tmp = key + 128;
    uint32_t num;
    num = (*tmp)? 1:0;

    while (*tmp)
    {
        if (*tmp == 0x20)
        {
            *tmp = 0;
            num++;
        }
        tmp++;
    }
    SS_LOGD("SS_Dalvik_lib: number of lib %d", num);

    /*=======>calc length file=============*/
    len_SS_ID = sizeof(len_SS_ID);                     //len len_SS_ID
    len_SS_ID += SHA256_HASH_LENGTH;                    //len HASH-CODE
    len_SS_ID += sizeof(SS_type);                       //len SS_type
    len_SS_ID += kSHA1DigestLen;                        //len SHA1
    len_SS_ID += sizeof(uint32_t);                    //number of skips
    len_SS_ID += 0;    //skips and original value
    len_SS_ID += key_len;                               //len RSA key and lib str
    len_SS_ID += sizeof(num);                           //len number of libs
    len_SS_ID += (strnlen(app_name, 127) + 1);                //len of package name

    /*=======>create out buf==============*/
    tmp_out = (uint8_t *)malloc(len_SS_ID);
    if(tmp_out == NULL)
    {
        SS_LOGE("SS_Dalvik_lib: SS_IDCompose: no memory.");
        *out = NULL;
        return -1;
    }
    /*=======>write data in buf===========*/
    *out = tmp_out;
    //==>write length file
    *(uint32_t*)tmp_out = len_SS_ID;
    tmp_out += sizeof(len_SS_ID);
    //==>write HASH-CODE
    memcpy(tmp_out, outHash, SHA256_HASH_LENGTH);
    tmp_out += SHA256_HASH_LENGTH;
    //==>write SS_type
    SS_type =  1 << 1;  // SS_ANDROID
    SS_type |= 1 << 27; // SS_CLASSES_DEX
    SS_type |= hash_type << SS_HASH_TYPE_OFFSET;
    if (app_type == SS_APP_TYPE_ARM64)
    {
        SS_type |= 1 << 28; // SS_ARM_64
    }
    if (isThirdparty)
    {
        SS_type |= 1 << 3; // SS_3RDPARTY
    }
    *(uint32_t*)(tmp_out) = SS_type;
    tmp_out += sizeof(SS_type);
    //==>write HASH-SHA1
    memcpy(tmp_out, in_dex + sha1_off, kSHA1DigestLen);
    tmp_out += kSHA1DigestLen;
    //insert skips address
    *(uint32_t*)(tmp_out) = 0; // skipLen
    tmp_out += sizeof(uint32_t);

    memcpy(tmp_out, key, 128);  //RSA key
    tmp_out += 128;
    *(uint32_t*)tmp_out = num;             //Number of lib
    tmp_out += sizeof(num);
    memcpy(tmp_out, key + 128, key_len - 128);//libs
    tmp_out += (key_len - 128);
    memcpy(tmp_out, app_name, (strnlen(app_name, 127) + 1));

    //==>out data
    *out_len = len_SS_ID;

    return 0;
}

int SS_IDCompose(int fd, unsigned char *key, uint32_t key_len, const char *app_name, void **out, uint32_t *out_len, uint32_t isThirdparty, int app_type, unsigned hash_type)
{
    int checker = 0;
    void *buf = NULL;
    uint8_t outHash[SHA256_HASH_LENGTH];
    uint8_t *tmp = NULL;
    uint8_t *out_tmp = NULL;
    uint32_t seg_size = 0;
    uint32_t len_SS_ID = 0;
    uint32_t SS_type = 0;
    uint32_t len_path = 0;
    uint32_t num_libs = 0;
    uint32_t num_skip = 0;

    if(NULL == key)
    {
        return -1;
    }

    if (hash_type != SS_USE_FULL_LEN && hash_type != SS_USE_HALF_LEN)
        return -1;

    checker = lseek(fd,  0, SEEK_SET);
    if (checker != 0)
    {
        SS_LOGD("Fseek SEEK_END in_odex  %i\n", checker);
        return -1;
    }

//    int get_code_seg_art(FILE *fl, void **seg, unsigned int *size, unsigned int *ss_id_type, void **seg_dyn, unsigned int *size_dyn)
    if (get_code_seg_art(fd, &buf, &seg_size, &SS_type) !=0 )
    {
        SS_LOGD("get_code_seg_art failed :(");
        return -1;
    }
    /*======>calc sha256 seg code=========*/
    computeHash((uint8_t*)buf, seg_size, outHash, hash_type);
    /*======>create seg path===============*/
    if( key && key_len > KEY_SIZE )
    {
        tmp = key + 128;
        num_libs = (*tmp)? 1:0;
        while (*tmp)
        {
            if (*tmp == 0x20)
            {
                *tmp = 0;
                num_libs++;
            }
            tmp++;
        }
        len_path = key_len - KEY_SIZE;
    }
    /*=======>calc length file=============*/
    len_SS_ID = 0;
    len_SS_ID += sizeof(len_SS_ID);  //len len_SS_ID
    len_SS_ID += SHA256_HASH_LENGTH; //len HASH-CODE
    len_SS_ID += sizeof(SS_type);    //len SS_type
    len_SS_ID += sizeof(seg_size);   //len seg_size
    len_SS_ID += sizeof(num_skip);   //len num skips
    len_SS_ID += KEY_SIZE;           //len RSA key
    len_SS_ID += sizeof(num_libs);   //len number libs
    len_SS_ID += len_path;           //len paths
    len_SS_ID += strlen(app_name)+1; //len paths

    *out_len = len_SS_ID;

    *out = malloc(len_SS_ID);
    if (*out == NULL)
    {
        if (buf != NULL)
        {
            free(buf);
        }
        SS_LOGD("Memory allocate\n");
        return SS_GENERAL_FAILURE;
    }
    /*=======>write data in buff ===========*/
    out_tmp = (uint8_t *)*out;
    memset(out_tmp, 0, len_SS_ID);
    //==>write length file
    memcpy(out_tmp, &len_SS_ID, sizeof(len_SS_ID));
    out_tmp += sizeof(len_SS_ID);
    //==>write HASH-CODE
    memcpy(out_tmp, outHash, sizeof(outHash));
    out_tmp += sizeof(outHash);
    //==>write SS_type
    SS_type = SS_ART;
    if(app_type == SS_APP_TYPE_ARM64)
    {
        SS_type |= SS_ARM_64;
    }
    SS_type |= SS_NEW_HMAC_SIGH;
    SS_type |= hash_type << SS_HASH_TYPE_OFFSET;
    if (isThirdparty) {SS_type |= SS_3RDPARTY;}
    if (!strcmp(app_name, "com.samsung.android.personalpage.service")) {SS_type |= SS_SKIP_AUTH;}
    memcpy(out_tmp, &SS_type, sizeof(SS_type));
    out_tmp += sizeof(SS_type);
    //==>write len_segm_code
    memcpy(out_tmp, &seg_size, sizeof(seg_size));
    out_tmp += sizeof(seg_size);
    //==>write num_skip
    memcpy(out_tmp, &num_skip, sizeof(num_skip));
    out_tmp += sizeof(num_skip);
    //==>write RSA key
    memcpy(out_tmp, key, KEY_SIZE);
    out_tmp += KEY_SIZE;
    //==>write path to libs
    memcpy(out_tmp, &num_libs, sizeof(num_libs));
    out_tmp += sizeof(num_libs);
    //==>write path to app
    memcpy(out_tmp, key+KEY_SIZE, key_len-KEY_SIZE);
    out_tmp += key_len-KEY_SIZE;
    //==>write path to app
    memcpy(out_tmp, app_name, strlen(app_name)+1);

    free(buf);

    return 0;
}

