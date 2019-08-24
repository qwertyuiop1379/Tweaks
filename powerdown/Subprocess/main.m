#include <stdio.h>
#include <dlfcn.h>
#include <spawn.h>

#define FLAG_PLATFORMIZE (1 << 1)

void fixsetuid_electra_chimera()
{
    void *handle = dlopen("/usr/lib/libjailbreak.dylib", RTLD_LAZY);
    if (!handle)
        return;

    dlerror();
    typedef void (*fix_entitle_prt_t)(pid_t pid, uint32_t what);
    fix_entitle_prt_t entitle_ptr = (fix_entitle_prt_t)dlsym(handle, "jb_oneshot_entitle_now");

    const char *dlsym_error = dlerror();
    if (dlsym_error)
        return;

    entitle_ptr(getpid(), FLAG_PLATFORMIZE);
    
    dlerror();
    typedef void (*fix_setuid_prt_t)(pid_t pid);
    fix_setuid_prt_t setuid_ptr = (fix_setuid_prt_t)dlsym(handle,"jb_oneshot_fix_setuid_now");
    
    dlsym_error = dlerror();
    if (dlsym_error)
        return;
    
    setuid_ptr(getpid());
}

int main(int argc, char *argv[], char *envp[])
{
	setuid(0);
	if (getuid() != 0)
	{
        printf("Failed to setuid, attempting fix patch...\n");
		fixsetuid_electra_chimera();
		setuid(0);
	}
	
	if (getuid() != 0)
    {
        printf("Patch failed, exiting.\n");
		return 1;
    }

	pid_t pid;
	int status;
	const char *args[] = {"ldrestart", NULL};
	posix_spawn(&pid, "/usr/bin/ldrestart", NULL, NULL, (char * const *)args, NULL);
	waitpid(pid, &status, WEXITED);

	return 0;
}