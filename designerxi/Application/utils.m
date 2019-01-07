#import <mach/error.h>
#import <spawn.h>
#import "utils.h"

NSString *lastOutput;

// this function is from unc0ver and very slightly modified: https://github.com/pwn20wndstuff/Undecimus/blob/master/Undecimus/source/utils.m
// this software is free to redistribute/modify/etc: https://github.com/pwn20wndstuff/Undecimus/blob/master/LICENSE
int _system(const char *cmd)
{
    posix_spawn_file_actions_t *actions = NULL;
    posix_spawn_file_actions_t actionsStruct;
    pid_t Pid = 0;
    int Status = 0;
    int out_pipe[2];
    bool valid_pipe = false;
    char *myenviron[] = {"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games", "PS1=\\h:\\w \\u\\$", NULL};
    char *argv[] = {"sh", "-c", (char *)cmd, NULL};
    valid_pipe = pipe(out_pipe) == ERR_SUCCESS;
    if (valid_pipe && posix_spawn_file_actions_init(&actionsStruct) == ERR_SUCCESS)
	{
        actions = &actionsStruct;
        posix_spawn_file_actions_adddup2(actions, out_pipe[1], 1);
        posix_spawn_file_actions_adddup2(actions, out_pipe[1], 2);
        posix_spawn_file_actions_addclose(actions, out_pipe[0]);
        posix_spawn_file_actions_addclose(actions, out_pipe[1]);
    }
    Status = posix_spawn(&Pid, "/bin/sh", actions, NULL, argv, myenviron);
    if (valid_pipe)
	{
        close(out_pipe[1]);
    }
    if (Status == ERR_SUCCESS)
	{
        waitpid(Pid, &Status, 0);
        if (valid_pipe)
		{
            NSData *outData = [[[NSFileHandle alloc] initWithFileDescriptor:out_pipe[0]] availableData];
			lastOutput = [NSString stringWithUTF8String:[outData bytes]];
        }
    }
    if (valid_pipe)
	{
        close(out_pipe[0]);
    }
    return Status;
}