/* МГП-8: минимальные системные вызовы newlib-nano (sprintf с плавающей точкой использует кучу:
 * область .heap, ld/sections.ld). Файлов и консоли нет. */
#include <errno.h>
#include <stddef.h>
#include <sys/stat.h>

extern char _heap_start, _heap_end;

void *_sbrk(ptrdiff_t inc)
{
    static char *brk = &_heap_start;
    if (inc > &_heap_end - brk || inc < &_heap_start - brk) { errno = ENOMEM; return (void *)-1; }
    char *p = brk;
    brk += inc;
    return p;
}

int _close(int f) { (void)f; return -1; }
int _fstat(int f, struct stat *st) { (void)f; st->st_mode = S_IFCHR; return 0; }
int _isatty(int f) { (void)f; return 1; }
int _lseek(int f, int o, int w) { (void)f; (void)o; (void)w; return 0; }
int _read(int f, char *p, int n) { (void)f; (void)p; (void)n; return 0; }
int _write(int f, const char *p, int n) { (void)f; (void)p; return n; }
void _exit(int c) { (void)c; for (;;) {} }
int _kill(int pid, int sig) { (void)pid; (void)sig; errno = EINVAL; return -1; }
int _getpid(void) { return 1; }
