/////////////////////////////////////////////////////////////////////////////
// numutility.h - declarations for the functions in libNumUtility.so
// John Schwartzman, Forte Systems, Inc.
// Fri 13 Feb 2026 11:27:32 AM EST
/////////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
extern "C" 
{
#endif  

    unsigned long long commaSeparate(unsigned long long n, char* buffer);     // dec for global function in commaSeparate.asm
    unsigned long long toHHMMSS(unsigned long long nSeconds, char* buffer);   // dec for global function in  hhmmss.asm

#ifdef __cplusplus
};
#endif
