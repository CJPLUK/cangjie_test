// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#include "sancov.h"
#include <stdlib.h>
#include <string.h>

int flag_length = 0;
bool* bool_flag_array;
char* char_array;
unsigned int* uint32_array;
uint64_t* switch_array;

const char* counter;
int counter_length = 0;

const uintptr_t* pc_table;
int table_length = 0;

int8_t** pc_table_funcName;
int8_t** pc_table_fileName;
uint64_t* pc_table_lineNumber;

extern "C" {

void __sanitizer_cov_bool_flag_init(bool* start, bool* end)
{
    // [start,end) is the array of boolean flags created for the current DSO.
    // Capture this array in order to read/modify the flags.
    if (start == end || *start)
        return;
    printf("do bool_flag_init: %d\n", *start);
}

bool* __cj_sancov_bool_flag_ctor(uint64_t n)
{
    flag_length = (int)n;
    bool* p = (bool*)calloc(n, sizeof(bool));
    memset(p, false, flag_length);
    bool_flag_array = p;
    __sanitizer_cov_bool_flag_init(p, p + sizeof(bool) * n);
    return bool_flag_array;
}
 void ShowBoolArray()
{
    for (int i = 0; i < flag_length; i++) {
        printf("show bool array: %d\n", bool_flag_array[i]);
    }
    return;
}

 void ShowUInt8Array()
{
    for (int i = 0; i < flag_length; i++) {
        printf("show char array: %d\n", char_array[i]);
    }
    return;
}

 void ShowUInt32Array()
{
    for (int i = 0; i < flag_length; i++) {
        printf("show uin32 array: %d\n", uint32_array[i]);
    }
    return;
}

 int SumBoolArray()
{
    int sum = 0;
    for (int i = 0; i < flag_length; i++) {
        sum = sum + bool_flag_array[i];
    }
    return sum;
}

 void __sanitizer_cov_8bit_counters_init(char* start, char* end)
{
    // [start,end) is the array of 8-bit counters created for the current DSO.
    // Capture this array in order to read/modify the counters.
    if (start == end || *start)
        return;
    counter = start;
    counter_length = end - start;
    printf("do 8bit_counters_init: %u\n", *start);
}
 char* __cj_sancov_8bit_counters_ctor(uint64_t n)
{
    flag_length = (int)n;
    char* p = (char*)calloc(n, sizeof(char));
    memset(p, 0, flag_length);
    char_array = p;
    __sanitizer_cov_8bit_counters_init(p, p + sizeof(char) * n);
    return char_array;
}

 unsigned int* __cj_sancov_pc_guard_ctor(uint64_t n)
{
    flag_length = (int)n;
    unsigned int* p = (unsigned int*)calloc(n, sizeof(unsigned int));
    memset(p, 0, flag_length);
    uint32_array = p;
    __sanitizer_cov_trace_pc_guard_init(p, p + n);
    return uint32_array;
}

 void __sanitizer_cov_trace_pc_guard_init(uint32_t* start, uint32_t* stop)
{
    static uint64_t N; // Counter for the guards.
    if (start == stop || *start)
        return; // Initialize only once.
    printf("catch trace_pc_guard_init: %p %p\n", start, stop);
    for (uint32_t* x = start; x < stop; x++)
        *x = ++N; // Guards should start from 1.
}

 void __sanitizer_cov_trace_pc_guard(uint32_t* currentIndex)
{
    // if (!uint32_array)
    //     return; // Duplicate the guard check.
    // unsigned int* currentIndex = uint32_array + sizeof(unsigned int) * index;
    // This function is a part of the sanitizer run-time.
    // To use it, link with AddressSanitizer or other sanitizer.
    //*currentIndex = *currentIndex + 1;
    printf("trace_pc_guard: %p %x PC\n", uint32_array, *currentIndex);
}

 void __cj_sancov_update_stack_depth()
{
    void* sp = __builtin_frame_address(0);
    if (sp < __sancov_lowest_stack) {
        __sancov_lowest_stack = sp;
    }
    printf("__cj_sancov_update_stack_depth");
}

void __cj_sancov_pcs_init(int8_t *packageName, uint64_t n, int8_t** funcNameTable, int8_t **fileNameTable,
    uint64_t *lineNumberTable)
{
    printf("call  __create_pc_table size:\n");
    printf("packagename: %s\n", packageName);
    pc_table_funcName = (int8_t**)calloc(n, sizeof(int8_t*));
    pc_table_fileName = (int8_t**)calloc(n, sizeof(int8_t*));
    pc_table_lineNumber = (uint64_t*)calloc(n, sizeof(uint64_t));
    for (int i = 0; i < n; i++) {
        pc_table_funcName[i] = funcNameTable[i];
        pc_table_fileName[i] = fileNameTable[i];
        pc_table_lineNumber[i] = lineNumberTable[i];
        printf("func name :(%u) (%s)\n", i, pc_table_funcName[i]);
        printf("file name :(%u) (%s)\n", i, pc_table_fileName[i]);
        printf("func:(%u) (%lu)\n", i, pc_table_lineNumber[i]); 
    }
}

 void __sanitizer_cov_pcs_init(const uintptr_t* pcs_beg, const uintptr_t* pcs_end)
{
    // [pcs_beg,pcs_end) is the array of ptr-sized integers representing
    // pairs [PC,PCFlags] for every instrumented block in the current DSO.
    // Capture this array in order to read the PCs and their Flags.
    // The number of PCs and PCFlags for a given DSO is the same as the number
    // of 8-bit counters (-fsanitize-coverage=inline-8bit-counters), or
    // boolean flags (-fsanitize-coverage=inline=bool-flags), or trace_pc_guard
    // callbacks (-fsanitize-coverage=trace-pc-guard).
    // A PCFlags describes the basic block:
    //  * bit0: 1 if the block is the function entry block, 0 otherwise.
    printf("catch cov_pcs_init\n");
    pc_table = pcs_beg;
    table_length = pcs_end - pcs_beg;
}

 void __sanitizer_cov_trace_cmp1(uint8_t Arg1, uint8_t Arg2)
{
    printf("trace_cmp1: (%u, %u)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_const_cmp1(uint8_t Arg1, uint8_t Arg2)
{
    printf("trace_const_cmp1: (%u, %u)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_cmp2(uint16_t Arg1, uint16_t Arg2)
{
    printf("trace_cmp2: (%u, %u)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_const_cmp2(uint16_t Arg1, uint16_t Arg2)
{
    printf("trace_const_cmp2: (%u, %u)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_cmp4(uint32_t Arg1, uint32_t Arg2)
{
    printf("trace_cmp4: (%u, %u)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_const_cmp4(uint32_t Arg1, uint32_t Arg2)
{
    printf("trace_const_cmp4: (%u, %u)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_cmp8(uint64_t Arg1, uint64_t Arg2)
{
    printf("trace_cmp8: (%lu, %lu)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

 void __sanitizer_cov_trace_const_cmp8(uint64_t Arg1, uint64_t Arg2)
{
    printf("trace_const_cmp8: (%lu, %lu)\n", Arg1, Arg2);
    printf("caller PC=%p\n", __builtin_return_address(0));
}

void ShowSwitchArray()
{
    if (!switch_array) {
        printf("trace_switch array is empty \n");
    }
    uint64_t size = switch_array[0];
    printf("trace_switch pattern size: (%lu)\n", size);

    for (int i = 2; i < size; i++) {
        printf("value: (%lu)\n", switch_array[i]);
    }
    return;
}
void __sanitizer_cov_trace_switch(uint64_t Val, uint64_t* Cases)
{
    switch_array = Cases;
    uint64_t size = Cases[0];
    printf("trace_switch pattern size: (%lu)\n", size);
    printf("trace_switch selector: (%lu)\n", Val);
    for (int i = 0; i < size; i++) {
        printf("value: (%lu)\n", Cases[i]);
    }
}

void __cj_sanitizer_weak_hook_memcmp(const void *s1, const void *s2, size_t n)
{
    printf("__cj_sanitizer_weak_hook_memcmp func\n");
    if (n == 3 * (sizeof(int32_t) / (sizeof(uint8_t)))) {
        int32_t* buffer = (int32_t*)s1;
        printf("%d", buffer[0]);
        for (size_t i = 1; i < 3; i++) {
            printf(" %d", buffer[i]);
        }
        printf("\n");
        printf("size: %zu\n", n);
        return;
    }
    char* buffer = (char*)malloc(sizeof(char) * (4 + 1));
    buffer[4] = '\0';
    memcpy(buffer, s1, 4);
    char* buffer2 = (char*)malloc(sizeof(char) * (4 + 1));
    buffer2[4] = '\0';
    memcpy(buffer2, s2, 4);
    printf("string1: %s\n", buffer);
    printf("string2: %s\n", buffer2);
    printf("size: %zu\n", n);
}

void __cj_sanitizer_weak_hook_strncmp(const char *s1, const char *s2, size_t n)
{
    printf("__cj_sanitizer_weak_hook_strncmp func\n");
    char* buffer = (char*)malloc(sizeof(char) * (4 + 1));
    buffer[4] = '\0';
    memcpy(buffer, s1, 4);
    char* buffer2 = (char*)malloc(sizeof(char) * (4 + 1));
    buffer2[4] = '\0';
    memcpy(buffer2, s2, 4);
    printf("string1: %s\n", buffer);
    printf("string2: %s\n", buffer2);
    printf("size: %zu\n", n);
}

void __cj_sanitizer_weak_hook_strcasecmp(const char *s1, const char *s2)
{
    printf("__cj_sanitizer_weak_hook_strcasecmp func\n");
    char* buffer = (char*)malloc(sizeof(char) * (4 + 1));
    buffer[4] = '\0';
    memcpy(buffer, s1, 4);
    char* buffer2 = (char*)malloc(sizeof(char) * (4 + 1));
    buffer2[4] = '\0';
    memcpy(buffer2, s2, 4);
    printf("string1: %s\n", buffer);
    printf("string2: %s\n", buffer2);
}

void __cj_sanitizer_weak_hook_strcmp(const char *s1, const char *s2)
{
    printf("__cj_sanitizer_weak_hook_strcmp func\n");
    char* buffer = (char*)malloc(sizeof(char) * (4 + 1));
    buffer[4] = '\0';
    memcpy(buffer, s1, 4);
    char* buffer2 = (char*)malloc(sizeof(char) * (4 + 1));
    buffer2[4] = '\0';
    memcpy(buffer2, s2, 4);
    printf("string1: %s\n", buffer);
    printf("string2: %s\n", buffer2);
}

void ShowCounter(){
    for(int i = 0; i < counter_length; i++){
        printf("[%d] = %d\n", i, *(counter + i));
    }
}
}
