#line 1 "/home/sungho/disk/Perforce/1716/DS/NILE/Combination/MSM8976/nhlos/trustzone_images/core/securemsm/trustzone/qsapps/sec_storage/build/sec_storage.scl"
TZ_TEST_APP 0 PI
{  
  TZ_APP_CODE  +0  
  {
    tzapp_entry.o (TZAPPENTRYCODE, +FIRST)
    * (+RO)
  }  
 
}
TZ_TEST_APP_DATA  +0  ALIGN 4096
{
  TZ_APP_RW +0
  {
    * (+RW, +ZI)
  }

  TZ_APP_STACK +0 EMPTY (0xA000)
  {
  }
  TZ_APP_HEAP +0 EMPTY (0x100000)
  {
  }
}
