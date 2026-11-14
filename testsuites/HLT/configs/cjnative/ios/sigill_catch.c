/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 *
 * SIGILL context capture for iOS simulator test runs.
 *
 * Injected via DYLD_INSERT_LIBRARIES when CJ_TRACE_STACK=1 is set for the
 * test suite. On SIGILL it prints the faulting instruction address (rip/pc),
 * the load base of the containing image, the frame-pointer chain with the
 * nearest exported symbol per frame, and then chains to the previously
 * registered SIGILL handler (the Cangjie runtime archives and calls it, see
 * runtime/src/Signal/SignalStack.cpp) so the process still dies with SIGILL.
 *
 * Design constraints:
 *   - SIGILL only. The runtime treats SIGSEGV/SIGBUS/SIGFPE as resumable
 *     (e.g. stack growth); interposing those is unsafe.
 *   - Depends on dyld initializer order: inserted libraries run before the
 *     runtime registers its own handler, so ours is archived by the runtime.
 *   - Handler does not malloc and does not dereference unverified pointers.
 */

#include <dlfcn.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/ucontext.h>

static struct sigaction saved;
static int have_saved;

static int real_sigaction(int sig, const struct sigaction *act, struct sigaction *oldact);

#if defined(__x86_64__) || defined(__aarch64__)
static int fp_plausible(uint64_t fp)
{
#if defined(__x86_64__)
    /* macOS x86_64 user space spans up to 0x800000000000; pthread stacks can
     * be mapped anywhere in it, so only reject near-null and kernel range. */
    return fp >= 0x1000000ULL && fp < 0x800000000000ULL;
#else
    return fp != 0 && (fp & 0x7ULL) == 0;
#endif
}
#endif

static void log_sigill(int sig, siginfo_t *info, void *ctx)
{
    ucontext_t *uc = (ucontext_t *)ctx;
#if defined(__x86_64__)
    _STRUCT_X86_THREAD_STATE64 *ss = &uc->uc_mcontext->__ss;
    uintptr_t pc = (uintptr_t)ss->__rip;
    uint64_t fp = ss->__rbp;
#elif defined(__aarch64__)
    _STRUCT_ARM_THREAD_STATE64 *ss = &uc->uc_mcontext->__ss;
    uintptr_t pc = (uintptr_t)ss->__pc;
    uint64_t fp = (uint64_t)ss->__fp;
#else
    return;
#endif
    Dl_info inf;
    int has_mod = pc != 0 && dladdr((void *)pc, &inf) && inf.dli_fbase != 0;
    const char *psym = has_mod && inf.dli_sname ? inf.dli_sname : 0;

    dprintf(STDERR_FILENO,
            "\n===== SIGILL pid %d si_addr %p =====\n"
            "pc %llx base %llx off %llx",
            getpid(), info ? info->si_addr : 0,
            (unsigned long long)pc, (unsigned long long)inf.dli_fbase,
            (unsigned long long)(pc - (uintptr_t)inf.dli_fbase));
    if (psym) {
        dprintf(STDERR_FILENO, " = %s+0x%llx", psym,
                (unsigned long long)(pc - (uintptr_t)inf.dli_saddr));
    }
    dprintf(STDERR_FILENO, "\n");
#if defined(__x86_64__)
    dprintf(STDERR_FILENO,
            "rsp %llx rbp %llx r11 %llx rax %llx rbx %llx\n",
            (unsigned long long)ss->__rsp, (unsigned long long)ss->__rbp,
            (unsigned long long)ss->__r11, (unsigned long long)ss->__rax,
            (unsigned long long)ss->__rbx);
#elif defined(__aarch64__)
    dprintf(STDERR_FILENO,
            "sp %llx fp %llx lr %llx x0 %llx x1 %llx\n",
            (unsigned long long)ss->__sp, (unsigned long long)ss->__fp,
            (unsigned long long)ss->__lr, (unsigned long long)ss->__x[0],
            (unsigned long long)ss->__x[1]);
#endif

    for (int i = 0; i < 12; i++) {
        if (!fp_plausible(fp)) break;
        uint64_t *p = (uint64_t *)fp;
        uint64_t ret = p[1];
        Dl_info finf;
        if (ret && dladdr((void *)ret, &finf) && finf.dli_fbase) {
            const char *sym = finf.dli_sname ? finf.dli_sname : "?";
            unsigned long long soff = finf.dli_sname ?
                (unsigned long long)((uintptr_t)ret - (uintptr_t)finf.dli_saddr) : 0;
            dprintf(STDERR_FILENO,
                    "frame[%d] ret %llx = %s+0x%llx [%s+0x%llx]\n",
                    i, (unsigned long long)ret, sym, soff,
                    finf.dli_fname ? finf.dli_fname : "?",
                    (unsigned long long)((uintptr_t)ret - (uintptr_t)finf.dli_fbase));
        } else {
            dprintf(STDERR_FILENO, "frame[%d] fp %llx ret %llx\n",
                    i, (unsigned long long)fp, (unsigned long long)ret);
        }
        uint64_t next = p[0];
        if (next <= fp || next - fp > 0x100000ULL) break;
        fp = next;
    }

    if (have_saved) {
        if ((saved.sa_flags & SA_SIGINFO) && saved.sa_sigaction)
            saved.sa_sigaction(sig, info, ctx);
        else if (saved.sa_handler && saved.sa_handler != SIG_DFL &&
                 saved.sa_handler != SIG_IGN)
            saved.sa_handler(sig);
    }
    /* If we still return, the faulting instruction re-executes; make that
     * second delivery fatal via SIG_DFL instead of looping forever. */
    struct sigaction dfl;
    memset(&dfl, 0, sizeof dfl);
    dfl.sa_handler = SIG_DFL;
    real_sigaction(SIGILL, &dfl, 0);
}

static int real_sigaction(int sig, const struct sigaction *act, struct sigaction *oldact)
{
    static int (*fn)(int, const struct sigaction *, struct sigaction *) = 0;
    if (!fn) fn = dlsym(RTLD_NEXT, "sigaction");
    return fn(sig, act, oldact);
}

int sigaction(int sig, const struct sigaction *act, struct sigaction *oldact)
{
    if (sig == SIGILL && act) {
        saved = *act;
        have_saved = 1;
        struct sigaction mine = *act;
        mine.sa_sigaction = log_sigill;
        mine.sa_flags |= SA_SIGINFO;
        return real_sigaction(SIGILL, &mine, oldact);
    }
    return real_sigaction(sig, act, oldact);
}

__attribute__((constructor))
static void init(void)
{
    struct sigaction mine;
    memset(&mine, 0, sizeof mine);
    mine.sa_sigaction = log_sigill;
    mine.sa_flags = SA_SIGINFO;
    real_sigaction(SIGILL, &mine, 0);
}
